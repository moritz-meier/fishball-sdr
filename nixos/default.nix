{
  config,
  flakeInputs,
  lib,
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/profiles/perlless.nix")
    (modulesPath + "/installer/sd-card/sd-image.nix")

    ./config.nix
  ];

  nixpkgs.buildPlatform = "x86_64-linux";
  nixpkgs.hostPlatform = "armv7l-linux";

  nixpkgs.overlays = [
    flakeInputs.minimal-nixos.overlays.default
  ];

  boot.loader = {
    grub.enable = false;
    systemd-boot.enable = false;

    generic-extlinux-compatible.enable = true;
    generic-extlinux-compatible.useGenerationDeviceTree = false;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelPatches = [
    {
      name = "rust";
      patch = null;
      features = {
        rust = true;
      };
    }
    {
      name = "adi-hdl";
      patch = null;
      structuredExtraConfig = {
        AXI_DMAC = lib.kernel.yes;
        ADI_AXI_ADC = lib.kernel.yes;
        ADI_AXI_DAC = lib.kernel.yes;

      };
    }
  ];

  boot.extraModulePackages = [
    (config.boot.kernelPackages.callPackage ../kmod-rust-out-of-tree-module/default.nix { })
  ];

  sdImage = {
    compressImage = false;

    populateFirmwareCommands = "";
    populateRootCommands = ''
      mkdir -p ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';
  };
}
