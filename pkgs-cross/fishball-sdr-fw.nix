{
  stdenvNoCC,
  thisFlake,
  buildPlatform,
  ubootTools,
  nixosConfig ? thisFlake.nixosConfigurations.minimal-rootfs,
}:

stdenvNoCC.mkDerivation {
  name = "fishball-sdr-fw";

  nativeBuildInputs = [ ubootTools ];
  installPhase = ''
    mkdir --parent -- "$out"
    cp -- ${thisFlake.packages.${buildPlatform.system}.kernel} "$out/"
    cp -- ${nixosConfig.config.system.build.netbootRamdisk}/initrd.* "$out/"
    mkimage -A arm -T ramdisk -d "$out/initrd.zst" "$out/initrd.img"
  '';
}
