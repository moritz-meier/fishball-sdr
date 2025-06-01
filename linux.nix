{
  stdenv,
  fetchgit,
  buildPackages,
  bc,
  bison,
  flex,
  openssl,
  perl,
  pkg-config,
  python3,
}:

stdenv.mkDerivation {
  name = "linux";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git";
    rev = "v6.15";
    hash = "sha256-PQjXBWJV+i2O0Xxbg76HqbHyzu7C0RWkvHJ8UywJSCw=";
  };

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  nativeBuildInputs = [
    bc
    bison
    flex
    openssl
    perl
    pkg-config
    python3
  ];

  #hardeningDisable = [ "all" ];

  configurePhase = ''
    make ARCH=arm CROSS_COMPILE=${stdenv.cc.targetPrefix} O=./build defconfig

    echo "CONFIG_SERIAL_XILINX_PS_UART=y" >> ./build/.config
    echo "CONFIG_SERIAL_XILINX_PS_UART_CONSOLE=y" >> ./build/.config
  '';

  buildPhase = ''
    make ARCH=arm CROSS_COMPILE=${stdenv.cc.targetPrefix} O=./build -j $NIX_BUILD_CORES
  '';

  installPhase = ''
    mkdir $out
    cp -r -- ./build/. $out/
  '';

  dontFixup = true;
}
