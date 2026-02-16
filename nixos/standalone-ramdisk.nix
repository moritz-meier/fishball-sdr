{
  config,
  lib,
  pkgs,
  ...
}:
{
  config =
    let
      fakeProcCmdline = pkgs.writeTextFile {
        name = "fake-proc-cmdline";
        text = ''
          init=${config.specialisation.squashfs-toplevel.configuration.system.build.toplevel}/init
        '';
      };
      nixosInitServices = [
        "initrd-find-etc"
        "initrd-find-nixos-closure"
        "initrd-nixos-activation"
        "initrd-switch-root"
      ];
    in
    {
      # https://github.com/wucke13/minimal-nixos/blob/main/nixos-modules/embedded/standalone-ramdisk.nix

      boot.initrd.systemd.services = lib.attrsets.genAttrs nixosInitServices (serviceName: {
        serviceConfig.BindReadOnlyPaths = "${fakeProcCmdline}:/proc/cmdline";
      });
      boot.initrd.systemd.storePaths = [ fakeProcCmdline ];
      system.nixos-init.enable = true; # faking via /proc/cmdline only works with `nixos-init`

      /*
        The standalone ramdisk contains a squashfs with the system's
        `my-configuraton.config.system.build.toplevel`. However, at the time when that squashfs is
        mounted, both initrd and kernel are already loaded. Hence it does not make sense to include
        them in the squashfs, they are redundant. Thus we create a specialisation of the current
        configuration with all the unnecessary things removed, in order to get a smaller squashfs.
      */
      specialisation.squashfs-toplevel.configuration = {
        boot.kernel.enable = false;
        boot.initrd.enable = false;

        # TODO remove this hack once https://github.com/NixOS/nixpkgs/issues/467069 is fixed
        system.build.kernel.config = {
          isSet = _: false;
        };
      };

      fileSystems."/" = {
        fsType = "tmpfs";
        options = [ "mode=0755" ];
      };

      # Mount the squashfs containing the fully populated nix-store
      fileSystems."/nix/.ro-store" = lib.mkImageMediaOverride {
        fsType = "squashfs";
        device = "../nix-store.squashfs";
        options = [
          "loop"
        ]
        ++ lib.optional (config.boot.kernelPackages.kernel.kernelAtLeast "6.2") "threads=multi";
        neededForBoot = true;
      };

      fileSystems."/nix/.rw-store" = lib.mkImageMediaOverride {
        fsType = "tmpfs";
        options = [ "mode=0755" ];
        neededForBoot = true;
      };

      fileSystems."/nix/store" = lib.mkImageMediaOverride {
        overlay = {
          lowerdir = [ "/nix/.ro-store" ];
          upperdir = "/nix/.rw-store/store";
          workdir = "/nix/.rw-store/work";
        };
        neededForBoot = true;
      };

      boot.loader.systemd-boot.enable = false;
      boot.loader.grub.enable = false;

      boot.initrd.availableKernelModules = [ "squashfs" ];

      boot.initrd.kernelModules = [ "loop" ];

      /*
        This is an NixOS internal information about the system, closing in kernel and
        bootloader --- but we don't need it in the initrd.
      */
      boot.bootspec.enable = false;

      # Create the initrd
      system.build.standaloneRamdisk = pkgs.buildPackages.makeInitrdNG {
        inherit (config.boot.initrd) compressor;
        prepend = [ "${config.system.build.initialRamdisk}/initrd" ];

        contents = [
          {
            source = config.system.build.squashfsStore;
            target = "/nix-store.squashfs";
          }
        ];
      };

      # Create the squashfs image that contains the Nix store.
      system.build.squashfsStore =
        pkgs.buildPackages.callPackage (pkgs.path + "/nixos/lib/make-squashfs.nix")
          {
            storeContents = [ config.specialisation.squashfs-toplevel.configuration.system.build.toplevel ];
            comp = "zstd";
          };
    };
}
