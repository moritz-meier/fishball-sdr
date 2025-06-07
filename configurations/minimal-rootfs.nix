# Author: wucke13 2024-2025
{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/netboot/netboot.nix")
    (modulesPath + "/profiles/perlless.nix")
  ];

  config = {
    boot.kernelPackages = pkgs.linuxPackagesFor (
      pkgs.linuxPackages_6_6.kernel.override {
        autoModules = false;
        kernelPreferBuiltin = true;
        enableCommonConfig = false; # dont inject common nixpkgs config stuff
        # defconfig = "xilinx_zynq_defconfig";
        argsOverride = {
          # src = pkgs.fetchFromGitHub {
          #   owner = "Xilinx";
          #   repo = "linux-xlnx";
          #   rev = "xlnx_rebase_v6.6_LTS_2024.2";
          #   hash = "sha256-jI6/r28vhalSqOOq5/cMTcZdzyXOAwBeUV3eWKrsDUs=";
          # };
          # version = "6.6.40";
          # modDirVersion = "6.6.40-xilinx";
          structuredExtraConfig = with lib.kernel; {
            #
            ### Desired features
            #
            CRYPTO_USER_API_HASH = yes;
            # ZSTD = yes;

            EROFS_FS = yes;
            # EROFS_FS_POSIX_ACL = yes;
            # EROFS_FS_XATTR = yes;

            OVERLAY_FS = yes;

            SQUASHFS = yes;
            # SQUASHFS_FS_POSIX_ACL = yes;
            # SQUASHFS_FS_XATTR = yes;
            SQUASHFS_ZSTD = yes;
            SQUASHFS_CHOICE_DECOMP_BY_MOUNT = yes; # make `mount -o threads=multi` work

            # SERIAL_8250 = yes;
            # SERIAL_8250_CONSOLE = yes;

            AEABI = yes; # we assume eabi in the userspace for NixOS on armv7l
            ARCH_MULTI_V7 = yes; # enable Cortex-A support, avoid µ-controller Linux
            ARCH_VIRT = yes; # enable virtualization support
            ARM_THUMBEE = yes; # ThumbEE may be used by our userspace
            COMPAT_32BIT_TIME = yes; # otherwise glibc's pthread_once exits with exit code 4
            MMU = yes; # enable MMU
            NEON = yes; # we assume neon is available
            VFP = yes; # target is gnueabihf -> hardware floating point unit support

            SERIAL_AMBA_PL011 = yes;
            SERIAL_AMBA_PL011_CONSOLE = yes;

            SERIAL_AMBA_PL010 = yes; # for QEMU?
            SERIAL_AMBA_PL010_CONSOLE = yes;

            SERIAL_XILINX_PS_UART = yes; # for real HW
            SERIAL_XILINX_PS_UART_CONSOLE = yes;

            SERIAL_UARTLITE = yes; # or the above?
            SERIAL_UARTLITE_CONSOLE = yes;

            #
            ### Pruning of unecessary stuff
            #

            # ARM_BIG_LITTLE_CPUIDLE = no;
            # KS8851_MLL = no;
            # SERIAL_8250_BCM2835AUX = no;
            # SERIAL_8250_EXTENDED = no;
            # SERIAL_8250_SHARE_IRQ = no;
            # SQUASHFS_FS_POSIX_ACL
            # SQUASHFS_FS_XATTR

            DRM = no;
            SOUND = no;
            MEDIA_SUPPORT = no;

            #
            ### Boot debugging desperation
            #

            # HIGHMEM = no; # something activates this :(
            HIGHPTE = no;
          };
          ignoreConfigErrors = false;
        };
      }
    );

    nixpkgs.overlays = [
      (final: prev: {
        /*
          pkgs/os-specific/linux/kernel/generic.nix unconditionally adds defaults from
          lib/systems/platforms.nix, in particular `stdenv.hostPlatform.linux-kernel.extraConfig`,
          to extraConfig. That is particularly bad, as there is no easy way to get rid of it.

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

        # https://github.com/NixOS/nixpkgs/issues/154163
        makeModulesClosure = x: prev.makeModulesClosure (x // { allowMissing = true; });

        dbus = prev.dbus.override {
          x11Support = false;
        };

        /*
          The linux kernel depends on util-linux' hexdump, util-linux depends on systemd, hence
          changing systemd implies a rebuild of the linux kernel. For deplyoment, we do not
          recommend keeping this, but it cuts development time quite  a bit to comment this in
        */
        # util-linux = prev.util-linux.override {
        #   systemd = prev.systemd;
        # };

        # Workaround
        # Checks fail when SELinux is enforced or permissive (Fedora).
        # Disabeling SELinux completely works, but reenabling it is tedious (machine wont boot anymore)
        composefs = prev.composefs.overrideAttrs (final: prev: { doCheck = false; });

        systemd = prev.systemd.override {
          withAnalyze = false;
          withApparmor = false;
          withAudit = false;
          withCoredump = false;
          withCryptsetup = false;
          withDocumentation = false;
          withFido2 = false;
          withHomed = false;
          withHwdb = true; # required for nixos/modules/services/hardware/udev.nix
          withImportd = false;
          withIptables = false;
          withLibBPF = false;
          withLibarchive = false;
          withLocaled = false;
          withMachined = false;
          withPasswordQuality = false;
          withRemote = false;
          withRepart = false;
          withSysupdate = false;
          withSysusers = false; # we use userborn instead
          withTpm2Tss = false;
          withVmspawn = false;
        };

        /*
          Systemd and systemd minimal end up in the initrd. Hence it makes sense to build just one
          systemd that satisfies both roles. As the systemd is used as bootloader too, it no no to
          enable the relevant features for that as well.
        */
        # TODO try disabling withBootloader and withEfi to enable this optimization
        # systemdMinimal = final.systemd;
        # systemdMinimal = prev.systemdMinimal.override {
        #   withLibBPF = false;
        #   withTpm2Tss = false;
        # };

        /*
          A QEMU specifically tailored to execute this initram. It only contains the relevant target
          architectures, and no support for graphical or audio stuff.
        */
        qemu-common = import (prev.path + "/nixos/lib/qemu-common.nix") {
          inherit lib pkgs;
        };
        qemuForThisConfig = prev.buildPackages.qemu.override {
          guestAgentSupport = true;
          numaSupport = true;
          seccompSupport = true;
          alsaSupport = false;
          pulseSupport = false;
          pipewireSupport = false;
          sdlSupport = false;
          jackSupport = false;
          gtkSupport = false;
          vncSupport = false;
          smartcardSupport = false;
          spiceSupport = false;
          ncursesSupport = true;
          usbredirSupport = false;
          xenSupport = false;
          cephSupport = false;
          glusterfsSupport = false;
          openGLSupport = false;
          rutabagaSupport = false;
          virglSupport = false;
          libiscsiSupport = true;
          smbdSupport = false;
          tpmSupport = false;
          uringSupport = true;
          canokeySupport = true;
          capstoneSupport = true;
          pluginsSupport = true;
          hostCpuTargets = [ "${pkgs.stdenv.hostPlatform.qemuArch}-softmmu" ];
        };

        # TODO remove once userborn 0.4.0 lands in the stable nixpkgs
        # Upstream Issue https://github.com/nikstur/userborn/issues/19
        userborn = prev.userborn.overrideAttrs (old: rec {
          version = "0.4.0";
          src = prev.fetchFromGitHub {
            inherit (old.src) owner repo;
            rev = version;
            hash = "sha256-Zh2u7we/MAIM7varuJA4AmEWeSMuA/C+0NSIUJN7zTs=";
          };
          cargoDeps = old.cargoDeps.overrideAttrs {
            inherit src;
            outputHash = "sha256-pEEdsldl3yFPRB3pj0EE2HC3E0N2tAboJbLjnfg6tYA=";
          };
        });
      })
    ];
    systemd.coredump.enable = false;

    # avoid any software installed by default
    # TODO filter this via nixos/modules/config/system-path.nix
    # See https://github.com/NixOS/nixpkgs/issues/32405 for further info
    environment.systemPackages = lib.mkForce [
      # essentials
      pkgs.bashInteractive # required, it is the default login shell and in the system closure anyhow
      pkgs.coreutils
      pkgs.systemd

      # goodies already included in the system closure
      pkgs.acl
      pkgs.attr
      pkgs.bzip2
      pkgs.cpio
      pkgs.dbus
      pkgs.dosfstools
      pkgs.findutils
      pkgs.fuse
      pkgs.getent
      pkgs.gnugrep
      pkgs.gnused
      pkgs.gzip
      pkgs.kexec-tools
      pkgs.kmod
      pkgs.libcap
      pkgs.ncurses
      pkgs.nettools
      pkgs.shadow
      pkgs.su
      pkgs.util-linux
      pkgs.xz
      pkgs.zstd

      # debugging aids
      # pkgs.iproute2
      # pkgs.netcat
      # pkgs.socat
      # pkgs.strace
    ];

    # use this to add packages to the early boot stage
    boot.initrd.systemd.initrdBin = [ ];

    # disable nix and nixos-rebuild itself
    nix.enable = false;
    nix.gc.automatic = lib.mkForce false;
    nix.optimise.automatic = lib.mkForce false;
    nixpkgs.buildPlatform = "x86_64-linux";
    nixpkgs.hostPlatform = "armv7l-linux";
    system.activatable = true; # Unfortunately required
    system.switch.enable = false;
    system.switch.enableNg = false;

    # disable services et al that are not strictly necessary
    fonts.fontconfig.enable = false;
    programs.nano.enable = false;
    security.enableWrappers = true; # otherwise login does not work
    security.pam.services.su.forwardXAuth = lib.mkForce false; # avoid su.pam depending on X
    security.sudo.enable = false;
    services.lvm.enable = false;
    services.udev.enable = true; # otherwise mount fails due to missing /dev/disk/by-*
    services.userborn.enable = true; # the alternative is a perl activation script
    system.stateVersion = config.system.nixos.release;
    xdg.icons.enable = false;
    xdg.mime.enable = false;
    xdg.sounds.enable = false;

    # disable any documentation from being included
    documentation.doc.enable = false;
    documentation.enable = false;
    documentation.info.enable = false;
    documentation.man.enable = false;
    documentation.nixos.enable = false;

    # use systemd-networkd for network configuration
    networking.dhcpcd.enable = false;
    networking.firewall.enable = false;
    networking.useDHCP = false;
    systemd.network = {
      enable = true;
      networks."99-main" = {
        matchConfig.Name = "br* en* eth* wl* ww*";
        DHCP = "yes";
        networkConfig.LLMNR = false;
        networkConfig.LinkLocalAddressing = "yes";
        networkConfig.MulticastDNS = true;
      };
    };

    /*
      systemd.services.network-local-commands implicates the inclusion of a shell script,
      which in term depends on iproute2, depending ong libbpf which is quite big.
    */
    # TODO verify this has no nasty side-effects
    systemd.services.network-local-commands.enable = false;

    systemd.suppressedSystemUnits = [
      "unit-audit.service"
      "unit-generate-shutdown-ramfs.service"
      "unit-systemd-backlight-.service"
      "unit-systemd-fsck-.service"
      "unit-systemd-importd.service"
      "unit-systemd-mkswap-.service"
    ];

    # setup users
    users.mutableUsers = false;
    # NOTE use `users.users.<name>.hashedPassword` for production use
    users.users.root.initialPassword = "root";

    /*
      The netboot.nix default settings add a dependency on nix itself to register store paths.
      Assuming that nix itself will not be used to modify the system running this initramfs, that
      won't be necessary.
    */
    boot.postBootCommands = lib.mkForce "";

    /*
      This is an NixOS internal information about the system, which closing in the about kernel and
      bootloader, but we don't need it in the initrd.
    */
    boot.bootspec.enable = false;

    boot.initrd.systemd.services.initrd-find-nixos-closure = {
      /*
        The original `initrd-find-nixos-closure.service` requires `init=` to be set with the
        absolute path to `${config.system.build.toplevel}/init`. However, its quite inconvenient
        having to set a long absolute nix-store path in the kernel cmdline for the initramdisk to
        work.

        In this service declaration, it is not easily possible to directly refer to
        `${config.system.build.toplevel}/init` without triggering infinite recursion. But, we know
        that there will only be one nixos-closure root in the store, as we intend to never upgade
        a system without regenerating the squashfs. Therefore, we can just glob the path via
        something like `/sysroot/nix/store/*-nixos-system-*`.
      */
      script = lib.mkForce ''
        set -uo pipefail
        export PATH="/bin:${config.boot.initrd.systemd.package.util-linux}/bin:${pkgs.chroot-realpath}/bin"

        closure=(/sysroot/nix/store/*-nixos-system-*/init)
        closure="''${closure#/sysroot}"

        # Resolve symlinks in the init parameter. We need this for some boot loaders
        # (e.g. boot.loader.generationsDir).
        closure="$(chroot-realpath /sysroot "$closure")"

        # Assume the directory containing the init script is the closure.
        closure="$(dirname "$closure")"

        ln --symbolic "$closure" /nixos-closure

        # If we are not booting a NixOS closure (e.g. init=/bin/sh),
        # we don't know what root to prepare so we don't do anything
        if ! [ -x "/sysroot$(readlink "/sysroot$closure/prepare-root" || echo "$closure/prepare-root")" ]; then
          echo "NEW_INIT=''${initParam[1]}" > /etc/switch-root.conf
          echo "$closure does not look like a NixOS installation - not activating"
          exit 0
        fi
        echo 'NEW_INIT=' > /etc/switch-root.conf
      '';
    };

    # only activate what we need filesystem and mass-storage wise
    boot.bcache.enable = false;
    boot.swraid.enable = lib.mkForce false;
    boot.initrd.supportedFilesystems = {
      cifs = lib.mkForce false;
      bcachefs = lib.mkForce false;
      btrfs = lib.mkForce false;
      xfs = lib.mkForce false;
      zfs = lib.mkForce false;
    };
    boot.supportedFilesystems = {
      cifs = lib.mkForce false;
      bcachefs = lib.mkForce false;
      btrfs = lib.mkForce false;
      xfs = lib.mkForce false;
      zfs = lib.mkForce false;
    };

    # a primitive QEMU runner
    system.build.run-with-qemu = pkgs.writeShellApplication {
      name = "run-in-qemu";
      text = ''
        # QEMU leaves the terminal in an unclean state upon exit.
        # See https://github.com/cirosantilli/linux-kernel-module-cheat/issues/110
        trap 'tput smam' EXIT

        ${pkgs.qemu-common.qemuBinary pkgs.qemuForThisConfig} \
          -m size=1G \
          -kernel ${config.system.build.toplevel}/kernel \
          -initrd ${config.system.build.netbootRamdisk}/initrd \
          -append 'console=${pkgs.qemu-common.qemuSerialDevice}' \
          -netdev user,id=n1 -device virtio-net-pci,netdev=n1 \
          -nographic \
          "''${@}"
      '';
    };
  };
}
