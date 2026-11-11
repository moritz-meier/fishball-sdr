{ config, pkgs, ... }:
{
  name = "fishball-sdr";

  plat = "zynq7";

  hwplat = {
    src = ./vivado-srcs;
  };

  linux-dt = {
    extraDtsi = [ ./dts/board.dtsi ];
    extraIncludePaths = [ (config.uboot.src + "/dts/upstream/include") ];
  };

  uboot.src = pkgs.fetchFromGitHub {
    owner = "u-boot";
    repo = "u-boot";
    rev = "v2026.10";
    hash = "sha256-BXIpyAY+uKSohrdG4BxAo0zq4CYmh2z9rFw1jA7Yu8s=";
  };

  uboot.extraConfigs = [
    "CONFIG_CMD_LINK_LOCAL=y"
    "CONFIG_CMD_USB_MASS_STORAGE=y"

    "CONFIG_LOG=y"
    "CONFIG_CMD_LOG=y"
    "CONFIG_LOG_DEFAULT_LEVEL=4"
    "CONFIG_LOG_MAX_LEVEL=7"
    "CONFIG_LOG_CONSOLE=y"
  ];

  uboot.extraPatches = [ ./uboot-env.patch ];

  flash-qspi = {
    flashPart = "mt25qu128-qspi-x4-single";
  };
}
