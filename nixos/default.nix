{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [
    ./kernel.nix
    # (modulesPath + "/installer/netboot/netboot.nix")
    ./standalone-ramdisk.nix
    (modulesPath + "/profiles/perlless.nix")
    ./debloat.nix
    ./config.nix
  ];

  config = {
    system.stateVersion = config.system.nixos.release;

    nixpkgs.buildPlatform = lib.mkForce "x86_64-linux";
    nixpkgs.hostPlatform = lib.mkForce "armv7l-linux";

    system.build.sdCard = pkgs.pkgsBuildBuild.linkFarmFromDrvs "sdcard" [
      config.system.build.kernel
      config.system.build.kernel.configfile
      config.system.build.standaloneRamdisk
    ];

    system.build.qemuVm = pkgs.pkgsBuildBuild.writeShellApplication {
      name = "run-${config.system.name}-vm";
      checkPhase = if pkgs.stdenv.buildPlatform == pkgs.stdenv.hostPlatform then null else "";

      text = ''
        # QEMU leaves the terminal in an unclean state upon exit.
        # See https://github.com/cirosantilli/linux-kernel-module-cheat/issues/110
        trap 'tput smam' EXIT

        echo 'launching QEMU'
        ${pkgs.pkgsBuildBuild.qemu_full}/bin/qemu-system-arm \
          -machine virt \
          -m size=4G -nographic \
          -nographic \
          -serial mon:stdio \
          -kernel ${config.system.build.kernel}/zImage \
          -initrd ${config.system.build.standaloneRamdisk}/initrd
      '';
    };
  };
}
