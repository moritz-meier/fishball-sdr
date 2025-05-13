{
  linuxManualConfig,
  linuxPackages_6_6,
  linuxPackages ? linuxPackages_6_6,
  kernel ? linuxPackages.kernel,
}:

(linuxManualConfig {
  inherit (linuxPackages.kernel) version src;
  configfile = ./.config;

})
// {
  passthru = {
    # To configure:
    #
    # nix develop ../..\#kernel.passthru.configEnv
    #
    # $ runPhase unpackPhase
    # $ runPhase patchPhase
    # $ make $makeFlags menuconfig
    # $ cp .config ../
    inherit (kernel) configEnv;
  };
}
