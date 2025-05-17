{
  lib,
  stdenvNoCC,
  thisFlake,
  ubootTools,
  dtc,
  nixosConfig ? thisFlake.nixosConfigurations.minimal-rootfs,
}:

let
  kernel = "${nixosConfig.config.system.build.kernel}/zImage";
  initrd = "${nixosConfig.config.system.build.netbootRamdisk}/initrd.zst";
  dts = ./linux-dt.dts;
  inherit (lib.strings) escapeShellArg;
in
stdenvNoCC.mkDerivation {
  name = "fishball-sdr-fw";
  dontUnpack = true;

  nativeBuildInputs = [
    dtc
    ubootTools
  ];
  installPhase = ''
    mkdir --parent -- "$out"
    cd "$out"

    # copy kernel
    ln --symbolic -- ${kernel} ./

    # copy initrd
    ln --symbolic -- ${initrd} ./

    # copy devicetree
    ln --symbolic -- ${dts} ./
    dtc -I dts -O dtb -o system.dtb ${dts}

    # make initrd image
    mkimage -A arm -T ramdisk -d  ${nixosConfig.config.system.build.netbootRamdisk}/initrd.* ./initrd.img

    # make FIT image
    substitute ${./boot.its} ./boot.its \
      --subst-var-by kernel ${escapeShellArg kernel} \
      --subst-var-by initrd ${escapeShellArg initrd} \
      --subst-var-by dtb "$out/system.dtb"
    mkimage -f ./boot.its ./fit-image.fit
  '';
}
