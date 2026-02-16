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
        autoModules = false;
        kernelPreferBuiltin = true;
        enableCommonConfig = false;
        defconfig = "tinyconfig";
        argsOverride = {
          # https://github.com/wucke13/minimal-nixos/blob/main/pkgs/minimal-linux-kernel.nix

          structuredExtraConfig = with lib.kernel; {
            # nixos nags about these
            AUTOFS_FS = yes;
            MODULES = yes;
            CRYPTO_HMAC = yes;
            CRYPTO_SHA256 = yes;
            SECCOMP = yes;

            # essentials
            BINFMT_ELF = yes;
            BINFMT_SCRIPT = yes; # otherwise shebangs wont work for systemd services
            BLK_DEV_INITRD = yes;
            CRYPTO = yes;
            CRYPTO_USER_API_HASH = yes;
            FILE_LOCKING = yes; # otherwise libmount fails to updat the userpace mount table
            MULTIUSER = yes;
            SMP = yes; # enable multi-core support

            # armv7 specials
            AEABI = yes; # we assume eabi in the userspace for NixOS on armv7l
            ARCH_MULTI_V7 = yes; # enable Cortex-A support, avoid µ-controller Linux
            ARCH_VIRT = yes; # enable virtualization support
            ARM_THUMBEE = yes; # ThumbEE may be used by our userspace
            COMPAT_32BIT_TIME = yes; # otherwise glibc's pthread_once exits with exit code 4
            MMU = yes; # enable MMU
            NEON = yes; # we assume neon is available
            VFP = yes; # target is gnueabihf -> hardware floating point unit support

            # network
            INET = yes;
            IPV6 = yes;
            NET = yes;
            NETDEVICES = yes; # otherwise systemd-resolved can't bind using SO_BINDTOIFINDEX
            PACKET = yes; # otherwise sytemd-networkd fails to acquire DHCP leases

            # erofs support
            EROFS_FS = yes;
            EROFS_FS_POSIX_ACL = yes;
            EROFS_FS_XATTR = yes;

            # overlayfs support
            OVERLAY_FS = yes;

            # squashfs support
            BLOCK = yes;
            BLK_DEV_LOOP = yes;
            MISC_FILESYSTEMS = yes;
            SQUASHFS = yes;
            SQUASHFS_ZSTD = yes;
            SQUASHFS_CHOICE_DECOMP_BY_MOUNT = yes; # make `mount -o threads=multi` work

            # tmpfs support
            SHMEM = yes; # required for TMPFS
            TMPFS = yes;
            TMPFS_POSIX_ACL = yes;
            TMPFS_XATTR = yes;

            # glibc
            FUTEX = yes; # for pthreads implementation

            # systemd requirements form the manual
            DEVTMPFS = yes;
            CGROUPS = yes;
            INOTIFY_USER = yes;
            SIGNALFD = yes;
            TIMERFD = yes;
            EPOLL = yes;
            UNIX = yes;
            SYSFS = yes;
            PROC_FS = yes;
            FHANDLE = yes;

            # systemd goodies from the manual
            SECCOMP_FILTER = yes;
            NET_SCHED = yes;
            NET_SCH_FQ_CODEL = yes;
            KCMP = yes;
            EVENTFD = yes; # systemd calls it config_event_fd

            # unofficial systemd requirements
            POSIX_TIMERS = yes; # required for systemd-update-utmp
            RSEQ = yes; # used by systemd-update-utmp

            # IO
            PRINTK = yes;
            SERIAL_AMBA_PL011 = yes;
            SERIAL_AMBA_PL011_CONSOLE = yes;
            TTY = yes;

            # make the kernel behave better as a guest
            PARAVIRT = yes;
            VIRTIO = yes;
            VIRTIO_CONSOLE = yes;

            # virtio networking
            ETHERNET = yes;
            PCI = yes;
            VIRTIO_MENU = yes;
            VIRTIO_NET = yes;
            VIRTIO_PCI = yes;

            # xilinx
            ARCH_ZYNQ = yes;
            SERIAL_XILINX_PS_UART = yes;
            SERIAL_XILINX_PS_UART_CONSOLE = yes;
          };
          ignoreConfigErrors = false;
        };
      }
    );
  };
}
