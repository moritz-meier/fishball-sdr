{
  lib,
  fetchFromGitHub,
  linuxPackages_6_6,
  ...
}@args:
# TODO reassess if this is clever with args passing through

linuxPackages_6_6.kernel.override args
// {
  autoModules = false;
  kernelPreferBuiltin = true;
  enableCommonConfig = false; # dont inject common nixpkgs config stuff
  defconfig = "xilinx_zynq_defconfig";
  argsOverride = {
    src = fetchFromGitHub {
      owner = "Xilinx";
      repo = "linux-xlnx";
      rev = "xlnx_rebase_v6.6_LTS_2024.2";
      hash = "sha256-jI6/r28vhalSqOOq5/cMTcZdzyXOAwBeUV3eWKrsDUs=";
    };
    version = "6.6.40";
    modDirVersion = "6.6.40-xilinx";
    structuredExtraConfig = with lib.kernel; {
      DRM = no;
      # DRM_XLNX = no;
      SOUND = no;
      # SND = no;
      # VIDEO_XILINX = no;
      MEDIA_SUPPORT = no;
      SCSI = no; # ???
      # V4L_PLATFORM_DRIVERS = no;
      # VIDEO_ADV7604 = no;
    };
  };
}
