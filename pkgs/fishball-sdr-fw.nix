{
  stdenvNoCC,
  thisFlake,
  ubootTools,
  nixosConfig ? thisFlake.nixosConfigurations.minimal-rootfs,
}:

stdenvNoCC.mkDerivation {
  name = "fishball-sdr-fw";
  dontUnpack = true;

  nativeBuildInputs = [ ubootTools ];
  installPhase = ''
    mkdir --parent -- "$out"
    cd "$out"

    # copy kernel
    ln --symbolic -- ${nixosConfig.config.system.build.kernel}/zImage ./

    # make initrd image
    mkimage -A arm -T ramdisk -d  ${nixosConfig.config.system.build.netbootRamdisk}/initrd.* ./initrd.img
  '';
}
