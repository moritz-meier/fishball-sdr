{ lib, ... }:
{
  config = {
    # https://github.com/wucke13/minimal-nixos/blob/12046eeae2db771455f7b740eb54adba7b03974d/nixos-modules/embedded/nixos-debloat.nix

    nixpkgs.overlays = [
      (final: prev: {
        # https://github.com/NixOS/nixpkgs/issues/154163
        makeModulesClosure = x: prev.makeModulesClosure (x // { allowMissing = true; });

        dbus = prev.dbus.override {
          x11Support = false;
        };

        /*
          These two tweaks saves 3 MiB of storage in the standalone initrd by butchering the
          glibc's available localization. However, they do change a package in the late nixpkgs
          bootstrapping process, effectively forcing you to recompile **every** package for this
          configuration, e.g. the official binary cache wil almost not be used. To enable quicker
          builds this setting is kept commented out for day-to-day development.
        */
        # glibcLocales = prev.glibcLocales.override {
        #   allLocales = false;
        # };
        # util-linux = prev.util-linux.override {
        #   nlsSupport = false;
        #   translateManpages = false;
        # };

        /*
          The linux kernel depends on util-linux' hexdump, util-linux depends on systemd, hence
          changing systemd implies a rebuild of the linux kernel. For deplyoment, we do not
          recommend keeping this, but it cuts development time quite  a bit to comment this in
        */
        # util-linux = prev.util-linux.override {
        #   systemd = prev.systemd;
        # };

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
      })
    ];
    systemd.coredump.enable = false;

    # disable nix and nixos-rebuild itself
    nix.enable = false;
    nix.gc.automatic = false;
    nix.optimise.automatic = false;
    system.activatable = true; # Unfortunately required to boot
    system.switch.enable = false;

    # disable services et al that are not strictly necessary
    programs.nano.enable = false;
    security.enableWrappers = true; # otherwise login does not work
    security.pam.services.su.forwardXAuth = lib.mkForce false; # avoid su.pam depending on X
    security.sudo.enable = false;
    services.lvm.enable = false;
    services.udev.enable = true; # otherwise mount fails due to missing /dev/disk/by-*
    services.userborn.enable = true; # the alternative is a perl activation script

    # disable desktop stuff
    fonts.fontconfig.enable = false;
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
      "unit-systemd-oomd.service"
    ];

    /*
      The netboot.nix default settings add a dependency on nix itself to register store paths.
      Assuming that nix itself will not be used to modify the system running this initramfs, that
      won't be necessary.
    */
    boot.postBootCommands = lib.mkForce "";

    # only activate what we need filesystem and mass-storage wise
    boot.bcache.enable = false;
    boot.swraid.enable = false;
    boot.initrd.supportedFilesystems = {
      cifs = false;
      bcachefs = false;
      btrfs = false;
      xfs = false;
      zfs = false;
    };
    boot.supportedFilesystems = {
      cifs = false;
      bcachefs = false;
      btrfs = false;
      xfs = false;
      zfs = false;
    };
  };
}
