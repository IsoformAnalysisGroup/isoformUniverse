# IsoformUniverse <img src="man/figures/logo.png" align="right" height="139" alt="" />

<!-- badges: start -->
<!-- badges: end -->

**IsoformUniverse** is an umbrella R package for isoform-level analysis —
inspired by how [`tidyverse`](https://www.tidyverse.org/) manages its
ecosystem.  

Currently IsoformUniverse only contains two packages many additional packages are currently being developed by the Isoform Analysis Group and collaborators. The vision is a universe of interconnected packages that allows extensive isoform analysis.

A single call to `library(IsoformUniverse)` loads and
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
remotes::install_github("IsoformAnalysisGroup/IsoformUniverse")
```

### Install all member packages

```r
library(IsoformUniverse)

# Install any missing member packages
isoformUniverse_install()

# Attach member packages that are not already loaded
isoformUniverse_attach()
```

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


## Functions

| Function | Description |
|----------|-------------|
| `library(IsoformUniverse)` | Loads all member packages (calls `isoformUniverse_attach()` automatically) |
| `isoformUniverse_packages()` | Returns a data frame of all member packages, sources, repositories, and explicit pre-dependencies |
| `isoformUniverse_install()` | Installs any missing member packages (with optional explicit pre-dependencies (Bioconductor or GitHub)) |
| `isoformUniverse_update()` | Updates all member packages to their latest versions |
| `isoformUniverse_attach()` | Attaches all member packages and prints a startup message |

