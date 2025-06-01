{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=master";
    xlnx-utils.url = "github:moritz-meier/xilinx-nix-utils?ref=feat/dram-test";
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
                hash = "sha256-RTcd7MR37E4yVGWP3RMruyKBI4tz8ex7mY1f5F2xd00=";
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
        {
          fw = board.boot-image;
          dt = board.linux-dt;
          dram-test = board.dram-test;
          uboot = board.uboot;
          boot = board.boot-jtag;
          flash = board.flash-qspi;

          linux = pkgs.pkgsCross.armv7l-hf-multiplatform.callPackage ./linux.nix { };
        };

      nixosConfigurations.foo = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          flakeRoot = ./.;
        };
        modules = [
          (
            {
              modulesPath,
              ...
            }:
            {
              imports = [
                (modulesPath + "/installer/netboot/netboot.nix")
              ];

              nixpkgs.buildPlatform = "x86_64-linux";
              nixpkgs.hostPlatform = "armv7l-linux";
            }
          )
        ];
      };

      devShells.${system}.default = pkgs.devshell.mkShell {
        name = "xilinx-dev-shell";

        imports = [ "${devshell}/extra/git/hooks.nix" ];

        packages = [
          pkgs.pkgsCross.armv7l-hf-multiplatform.stdenv.cc
          pkgs.gdb
          pkgs.xilinx-unified
        ];

        # git.hooks = {
        #   enable = true;
        #   pre-commit.text = ''
        #     nix fmt
        #     nix flake check
        #   '';
        # };
      };

      # for `nix fmt`
      formatter.${system} = treefmtEval.config.build.wrapper;

      # for `nix flake check`
      checks.${system}.formatting = treefmtEval.config.build.check self;
    };
}
