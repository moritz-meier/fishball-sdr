{
  kernel,
  kernelModuleMakeFlags,
  unstableGitUpdater,
}:
kernel.stdenv.mkDerivation {
  pname = "rust-out-of-tree-module";
  version = "0-unstable-2025-11-12";

  src = ./.;

  nativeBuildInputs = kernel.moduleBuildDependencies;
  makeFlags = kernelModuleMakeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];

  passthru.updateScript = unstableGitUpdater { };
}
