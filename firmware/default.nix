{ ... }:
{
  name = "fishball-sdr";

  plat = "zynq7";

  hwplat = {
    src = ./vivado-srcs;
  };

  linux-dt = {
    extraDtsi = [ ./dts/board.dtsi ];
  };

  uboot.extraConfigs = [
    "CONFIG_LOG=y"
    "CONFIG_CMD_LOG=y"
    "CONFIG_LOG_DEFAULT_LEVEL=4"
    "CONFIG_LOG_MAX_LEVEL=7"
    "CONFIG_LOG_CONSOLE=y"
  ];

  flash-qspi = {
    flashPart = "mt25qu128-qspi-x4-single";
  };
}
