final: prev: {
  cudaPackages = prev.cudaPackages.overrideScope (_final: previous: {
    # CUDA's compatibility hook converts this array to a string, while the
    # current multiple-outputs hook expects an array. Remove this once the
    # buildRedist hook no longer performs that conversion.
    buildRedist = args:
      (previous.buildRedist args).overrideAttrs (_: {
        __structuredAttrs = false;
      });
  });
  intel-compute-runtime-legacy1 = prev.intel-compute-runtime-legacy1.overrideAttrs (previous: {
    # GCC 16 diagnoses this old runtime's forward declaration during SFINAE.
    # Upstream enables -Werror, so keep that single new warning non-fatal.
    NIX_CFLAGS_COMPILE =
      (previous.NIX_CFLAGS_COMPILE or "")
      + " -Wno-error=sfinae-incomplete";
  });
  input-fonts = prev.callPackage ./input-fonts {};
  logue-cli = prev.callPackage ./logue-cli {};
  q15-auth = prev.callPackage ./q15-auth {};
  shantell-sans = prev.callPackage ./shantell-sans {};
}
