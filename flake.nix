{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-24.11";
    xlnx-utils.url = "github:moritz-meier/xilinx-nix-utils?ref=2024.2";
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

                overlays = [
                  xlnx-utils.overlays.zynq-srcs
                  xlnx-utils.overlays.zynq-utils
                ];
              };
            };
          })

          xlnx-utils.overlays.default
          xlnx-utils.overlays.zynq-srcs
          xlnx-utils.overlays.zynq-utils

          (final: prev: {
            zynq-srcs = prev.zynq-srcs // {
              uboot-src = pkgs.fetchFromGitHub {
                owner = "Xilinx";
                repo = "u-boot-xlnx";
                rev = "xlnx_rebase_v2025.01";
                hash = "sha256-uN6oXoa6huclsz1c5Z2IyIvJoRfMr1QsfKF6Y2Z4zf4=";
              };
            };
          })

          devshell.overlays.default
        ];
      };

      treefmtEval = treefmt.lib.evalModule pkgs ./treefmt.nix;
    in
    {
      packages.${system} =
        let
          board = pkgs.callPackage ./fw.nix { };
        in
        (nixpkgs.lib.filesystem.packagesFromDirectoryRecursive {
          callPackage = nixpkgs.lib.callPackageWith (pkgs // { thisFlake = self; });
          directory = ./pkgs;
        })
        // {
          inherit (self.nixosConfigurations.minimal-rootfs.config.system.build)
            kernel
            netbootramdisk
            ;
        }
        // {
          fw = board.boot-image;
          dt = board.linux-dt;
          uboot = board.uboot;
          boot = board.boot-jtag;
          flash = board.flash-qspi;
        };

      nixosConfigurations.minimal-rootfs = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          thisFlake = self;
          flakeRoot = ./.;
        };
        modules = [
          (import ./configurations/minimal-rootfs.nix)
        ];
      };

      devShells.${system}.default = pkgs.devshell.mkShell {
        name = "xilinx-dev-shell";

        imports = [ "${devshell}/extra/git/hooks.nix" ];

        packages = [
          pkgs.xilinx-unified
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
