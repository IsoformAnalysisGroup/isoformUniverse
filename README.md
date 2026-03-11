# IsoformUniverse <img src="man/figures/logo.png" align="right" height="139" alt="" />

<!-- badges: start -->
<!-- badges: end -->

**IsoformUniverse** is an umbrella R package for isoform-level analysis —
inspired by how [`tidyverse`](https://www.tidyverse.org/) manages its
ecosystem.  A single call to `library(IsoformUniverse)` loads and
keeps in sync a curated set of isoform-analysis packages hosted on
Bioconductor and GitHub.

---

## Packages included

| Package | Source | Description |
|---------|--------|-------------|
| [pairedGSEA](https://bioconductor.org/packages/pairedGSEA/) | Bioconductor | Paired gene-set enrichment analysis for gene and isoform expression |
| [IsoformSwitchAnalyzeR](https://github.com/kvittingseerup/IsoformSwitchAnalyzeR) | GitHub | Identify, annotate, and visualise isoform switches with functional consequences |

---

## Installation

### Install IsoformUniverse

```r
# Install from GitHub
remotes::install_github("elena-iri/IsoformUniverse")
```

### Install all member packages

```r
library(IsoformUniverse)

# Install any missing member packages (helper installers are auto-installed from CRAN)
isoformUniverse_install()
```

> Note: GitHub package dependencies declared in a package DESCRIPTION are typically installed automatically by `remotes::install_github()`. If a package has an extra dependency that is not installed automatically (for example, `pfamAnalyzeR` for `IsoformSwitchAnalyzeR`), declare it in the registry `deps` field shown below.

---

## Usage

```r
library(IsoformUniverse)
#> ── IsoformUniverse ─────────────────────────────────────────────────────────
#> ✔ pairedGSEA 1.4.0
#> ✔ IsoformSwitchAnalyzeR 2.4.0
```

### Update all member packages

```r
isoformUniverse_update()
```

### Inspect the package registry

```r
isoformUniverse_packages()
#>                  package        source                                repo
#> 1             pairedGSEA  Bioconductor                                <NA>
#> 2  IsoformSwitchAnalyzeR        GitHub  kvittingseerup/IsoformSwitchAnalyzeR
#> deps: <list-column; each element is a dependency data.frame>
```

---

## Adding new packages

IsoformUniverse is designed to grow as the team develops more tools.  To add
a new package:

1. **Edit `R/packages.R`** — add a row to the `.isoformverse_pkgs` data frame:

   ```r
   .isoformverse_pkgs <- data.frame(
     package = c(
       "pairedGSEA",
       "IsoformSwitchAnalyzeR",
       "myNewPackage"          # ← add your package here
     ),
     source = c(
       "Bioconductor",
       "GitHub",
       "GitHub"                # ← "Bioconductor" or "GitHub"
     ),
     repo = c(
       NA_character_,
       "kvittingseerup/IsoformSwitchAnalyzeR",
       "myOrg/myNewPackage"    # ← "owner/repo", or NA for Bioconductor
     ),
     deps = I(list(
       data.frame(
         package = c("SummarizedExperiment", "S4Vectors"),
         source = c("Bioconductor", "Bioconductor"),
         repo = c(NA_character_, NA_character_)
       ),
       data.frame(
         package = "pfamAnalyzeR",
         source = "GitHub",
         repo = "kvittingseerup/pfamAnalyzeR"
       ),
       data.frame(
         package = character(0),
         source = character(0),
         repo = character(0)
       )
     )),
     stringsAsFactors = FALSE
   )
   ```

2. **Regenerate documentation**:

   ```r
   devtools::document()
   ```

3. **Add a `NEWS.md` entry** describing the new package.

4. **Open a pull request** against `main`.

The install and update machinery will automatically pick up the new entry —
no other code changes are needed.

---

## Functions

| Function | Description |
|----------|-------------|
| `library(IsoformUniverse)` | Loads all member packages (calls `isoformUniverse_attach()` automatically) |
| `isoformUniverse_packages()` | Returns a data frame of all member packages, sources, repositories, and explicit pre-dependencies |
| `isoformUniverse_install()` | Installs any missing member packages (with optional explicit pre-dependencies (Bioconductor or GitHub)) |
| `isoformUniverse_update()` | Updates all member packages to their latest versions |
| `isoformUniverse_attach()` | Attaches all member packages and prints a startup message |

---

## License

MIT © Elena Iri