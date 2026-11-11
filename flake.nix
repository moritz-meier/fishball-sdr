{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    xlnx-utils.url = "git+file:///home/moritz/Repositories/dlr/xilinx-nix-utils";
    xlnx-utils.inputs.nixpkgs.follows = "nixpkgs";

    minimal-nixos.url = "github:wucke13/minimal-nixos";
    minimal-nixos.inputs.nixpkgs.follows = "nixpkgs";

    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";

    treefmt.url = "github:numtide/treefmt-nix";
    treefmt.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      xlnx-utils,
      devshell,
      treefmt,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;

        overlays = [
          (final: prev: {
            pkgsCross = prev.pkgsCross // {
              armhf-embedded = import nixpkgs {
                localSystem = system;
                crossSystem = {
                  config = "arm-none-eabihf";
                  gcc.arch = "armv7-a+fp";
                  gcc.tune = "cortex-a9";
                };

                overlays = final.overlays;
              };
            };
          })

          xlnx-utils.overlays.default
          devshell.overlays.default
        ];
      };

      treefmtEval = treefmt.lib.evalModule pkgs ./treefmt.nix;
    in
    rec {
      packages.${system} = {
        fw = pkgs.zynq-modules.mkZynqFirmware {
          modules = [
            (import ./firmware)
          ];
        };

        adi-hdl = pkgs.stdenv.mkDerivation {
          name = "adi-hdl";

          src = pkgs.fetchgit {
            url = "https://github.com/analogdevicesinc/hdl.git";
            rev = "2026.1.0";
            hash = "sha256-WN6H7do4UumXqwXpBoKFsvr1/X+3Hma713g83+OWpDY=";
            fetchLFS = true;
          };

          nativeBuildInputs = with pkgs; [
            flock
            gnumake
            tcl
            xilinx-unified
          ];

          patchPhase = ''
            runHook prePatch

            substituteInPlace ./scripts/adi_env.tcl \
              --replace-fail "set required_vivado_version \"2025.1\"" "set required_vivado_version \"2025.2.1\""

            runHook postPatch
          '';

          dontConfigure = true;

          buildPhase = ''
            runHook preBuild

            make lib

            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall

            mkdir $out
            cp -r ./. $out/

            runHook postInstall
          '';

          dontFixup = true;
        };
      };

      nixosConfigurations.fishball-sdr = nixpkgs.lib.nixosSystem {
        specialArgs = {
          flakeInputs = inputs;
        };
        modules = [ (import ./nixos) ];
      };

      devShells.${system}.default =
        let
          kernel = kernelPackages.kernel;
          kernelPackages = nixosConfigurations.fishball-sdr.config.boot.kernelPackages;
        in
        pkgs.devshell.mkShell {
          name = "xilinx-dev-shell";

          imports = [ "${devshell}/extra/git/hooks.nix" ];

          packages =
            with pkgs;
            [
              _3cpio
              dtc
              gnumake
              qemu_full
              (pkgs.lowPrio pkgs.xilinx-unified)
              kernel.dev
            ]
            ++ kernel.moduleBuildDependencies;

          env = [
            {
              name = "KERNEL_DIR";
              value = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
            }
            {
              name = "MAKEFLAGS";
              value = "${pkgs.lib.concatStringsSep " " kernelPackages.kernelModuleMakeFlags}";
            }
          ];

          git.hooks = {
            enable = true;
            pre-commit.text = ''
              nix fmt
              nix flake check
            '';
          };
        };

      # for `nix fmt`
      formatter.${system} = treefmtEval.config.build.wrapper;

      # for `nix flake check`
      checks.${system}.formatting = treefmtEval.config.build.check self;
    };
}
