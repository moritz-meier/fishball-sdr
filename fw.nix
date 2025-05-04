{ zynq-utils }:

zynq-utils.zynq7.board {
  name = "fishball-sdr";
  src = ./vivado-srcs;

  sdt = {
    extraDtsi = ./dts/board.dtsi;
  };

  uboot.extraConfig = ''
    CONFIG_LOG=y
    CONFIG_CMD_LOG=y
    CONFIG_LOG_DEFAULT_LEVEL=4
    CONFIG_LOG_MAX_LEVEL=7
    CONFIG_LOG_CONSOLE=y
  '';

  flash-qspi = {
    flashType = "qspi-x4-single";
    flashDensity = 128;
  };
}
