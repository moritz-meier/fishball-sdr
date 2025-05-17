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
    # TODO

    # make initrd image
    mkimage -A arm -T ramdisk -d  ${nixosConfig.config.system.build.netbootRamdisk}/initrd.* ./initrd.img

    # make FIT image
    substitute ${./boot.its} ./boot.its \
      --subst-var-by kernel ${escapeShellArg kernel} \
      --subst-var-by initrd ${escapeShellArg initrd}
    mkimage -f ./boot.its ./fit-image.fit
  '';
}
