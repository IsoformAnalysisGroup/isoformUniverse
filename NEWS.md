# IsoformUniverse (development version)

## Initial release

* Added `isoformUniverse_packages()` to list all member packages with their
  source and repository information.
* Added `isoformUniverse_attach()` to load all member packages; called
  automatically by `.onAttach` when running `library(IsoformUniverse)`.
* Added `isoformUniverse_install()` to install any missing member packages.
* Added `isoformUniverse_update()` to update all member packages to their
  latest versions.
* Initial member packages:
  * [pairedGSEA](https://bioconductor.org/packages/pairedGSEA/) (Bioconductor)
  * [IsoformSwitchAnalyzeR](https://github.com/kvittingsekse/IsoformSwitchAnalyzeR) (GitHub)

## Improvements

* Installation now auto-installs missing helper installers (`BiocManager` and
  `remotes`) from CRAN by default, with an opt-out argument
  `auto_install_helpers = FALSE`.
* Added an explicit `deps` list-column to the package registry so Bioconductor
  pre-dependencies (e.g., for `pairedGSEA`) can be installed before the target
  package.

## Fixes

* Installation now emits clear warnings when a package fails to install,
  including a summary of failed package names at the end of
  `isoformUniverse_install()` / `isoformUniverse_update()`.
* Expanded explicit dependency handling so `deps` can include both
  Bioconductor and GitHub pre-dependencies.
* Added `pfamAnalyzeR` as an explicit GitHub pre-dependency for
  `IsoformSwitchAnalyzeR`.
  
## Testing addition of new package

* Tested developer guide by adding a new R package (BioPred) with
  several dependencies.
