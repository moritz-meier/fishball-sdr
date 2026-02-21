{ lib, pkgs, ... }:
{
  config = {
    nixpkgs.overlays = [
      (final: prev: {
        makeModulesClosure = x: prev.makeModulesClosure (x // { allowMissing = true; });

        /*
          `pkgs/os-specific/linux/kernel/generic.nix` unconditionally adds defaults from
          `lib/systems/platforms.nix`, in particular `stdenv.hostPlatform.linux-kernel.extraConfig`,
          to `extraConfig`. That is particularly bad, as there is no easy way to get rid of it.

          Upstream PR: https://github.com/NixOS/nixpkgs/pull/413059
        */
        stdenv =
          let
            removeByPath =
              pathList: set:
              lib.updateManyAttrsByPath [
                {
                  path = lib.init pathList;
                  update = old: lib.filterAttrs (n: v: n != (lib.last pathList)) old;
                }
              ] set;
          in
          removeByPath [ "hostPlatform" "linux-kernel" "extraConfig" ] prev.stdenv;
      })
    ];

    boot.kernelPackages = pkgs.linuxPackagesFor (
      pkgs.linuxPackages.kernel.override {
        # autoModules = false;
        # kernelPreferBuiltin = true;
        # enableCommonConfig = false;
        # defconfig = "tinyconfig";
        # argsOverride = {
        # structuredExtraConfig = with lib.kernel; {
        #   MODULES = yes;

        #   AEABI = yes;
        #   ARCH_VIRT = yes;
        #   ARM_THUMBEE = yes;
        #   COMPAT_32BIT_TIME = yes;
        #   MMU = yes;
        #   NEON = yes;
        #   VFP = yes;

        #   BINFMT_ELF = yes;
        #   BINFMT_SCRIPT = yes;
        #   BLK_DEV_INITRD = yes;

        #   PRINTK = yes;
        #   TTY = yes;

        #   FILE_LOCKING = yes;
        #   FUTEX = yes;

        #   CGROUPS = yes;
        #   EPOLL = yes;
        #   EVENTFD = yes;
        #   FHANDLE = yes;
        #   INOTIFY_USER = yes;
        #   SIGNALFD = yes;
        #   TIMERFD = yes;

        #   DEVTMPFS = yes;
        #   SYSFS = yes;
        #   PROC_FS = yes;

        #   BLOCK = yes;
        #   BLK_DEV_LOOP = yes;
        #   MISC_FILESYSTEMS = yes;

        #   TMPFS = yes;
        #   OVERLAY_FS = yes;

        #   SQUASHFS = yes;
        #   SQUASHFS_ZSTD = yes;
        #   SQUASHFS_CHOICE_DECOMP_BY_MOUNT = yes;

        #   SERIAL_AMBA_PL011 = yes;
        #   SERIAL_AMBA_PL011_CONSOLE = yes;
        # };
        # ignoreConfigErrors = false;
        # };
      }
    );
  };
}
