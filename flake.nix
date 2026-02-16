{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    # Just as a workaround
    nixpkgs2505.url = "github:nixos/nixpkgs/nixos-25.05";

    xlnx-utils.url = "github:dlr-ft/xilinx-nix-utils/zynq-modules";
    xlnx-utils.inputs.nixpkgs.follows = "nixpkgs";

    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";

    treefmt.url = "github:numtide/treefmt-nix";
    treefmt.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs2505,
      xlnx-utils,
      devshell,
      treefmt,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;

        overlays = [
          # https://github.com/NixOS/nixpkgs/pull/459393
          (
            final: prev:
            let
              pkgs = import nixpkgs2505 { inherit system; };
            in
            {
              ratarmount = pkgs.ratarmount;
            }
          )
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

          xlnx-utils.overlays.xilinx-unified
          xlnx-utils.overlays.zynq-srcs
          xlnx-utils.overlays.zynq-pkgs
          xlnx-utils.overlays.zynq-modules
          xlnx-utils.overlays.zynq-patches

          devshell.overlays.default
        ];
      };

      treefmtEval = treefmt.lib.evalModule pkgs ./treefmt.nix;
    in
    {
      packages.${system} = {
        fw = pkgs.zynq-modules.mkZynqFirmware {
          modules = [
            (import ./firmware)
          ];
        };
      };

      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        modules = [
          (import ./nixos)
        ];
      };

      devShells.${system}.default = pkgs.devshell.mkShell {
        name = "xilinx-dev-shell";

        imports = [ "${devshell}/extra/git/hooks.nix" ];

        packages = [
          pkgs.xilinx-unified
          pkgs.qemu_full
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
