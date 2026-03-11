# IsoformUniverse package registry
#
# This file defines the list of packages managed by IsoformUniverse.
#
# ── How to add a new package ─────────────────────────────────────────────────
#
# 1. Add a new row to `.isoformverse_pkgs` below.
#    Fill in:
#      * `package` – the exact R package name (case-sensitive).
#      * `source`  – one of "Bioconductor" or "GitHub".
#      * `repo`    – the "owner/repo" GitHub path for GitHub packages, or
#                    NA_character_ for Bioconductor packages (they are
#                    identified by name alone).
#      * `deps`    – optional pre-install dependencies, as a data frame with
#                    columns `package`, `source`, and `repo`.
#
# 2. Regenerate documentation:
#      devtools::document()
#
# 3. Add an entry to NEWS.md so users know a new package was added.
#
# ─────────────────────────────────────────────────────────────────────────────

# Internal package registry.
# Columns:
#   package – R package name
#   source  – "Bioconductor" | "GitHub"
#   repo    – GitHub "owner/repo" path, or NA for Bioconductor
#   deps    – Optional data.frame of explicit pre-install dependencies
.isoformverse_pkgs <- data.frame(
  package = c(
    "pairedGSEA",
    "IsoformSwitchAnalyzeR"
  ),
  source = c(
    "Bioconductor",
    "GitHub"
  ),
  repo = c(
    NA_character_,
    "kvittingseerup/IsoformSwitchAnalyzeR"
  ),
  deps = I(list(
    data.frame(
      package = c(
        "SummarizedExperiment",
        "S4Vectors",
        "DESeq2",
        "DEXSeq",
        "fgsea",
        "sva",
        "BiocParallel"
      ),
      source = rep("Bioconductor", 7),
      repo = rep(NA_character_, 7),
      stringsAsFactors = FALSE
    ),
    data.frame(
      package = "pfamAnalyzeR",
      source = "GitHub",
      repo = "kvittingseerup/pfamAnalyzeR",
      stringsAsFactors = FALSE
    )
  )),
  stringsAsFactors = FALSE
)

#' List all IsoformUniverse packages
#'
#' Returns a data frame describing every package that belongs to the
#' IsoformUniverse ecosystem. Each row is one package.
#'
#' @return A `data.frame` with four columns:
#'   \describe{
#'     \item{`package`}{The R package name (character).}
#'     \item{`source`}{Where the package is hosted: `"Bioconductor"` or
#'       `"GitHub"` (character).}
#'     \item{`repo`}{For GitHub packages, the `"owner/repo"` path needed by
#'       [remotes::install_github()]. `NA` for Bioconductor packages
#'       (character).}
#'     \item{`deps`}{A list-column where each entry is a data frame of
#'       explicit pre-install dependencies with columns `package`, `source`,
#'       and `repo`. Use an empty data frame when no extra dependencies are
#'       needed.}
#'   }
#'
#' @section Adding packages:
#' Edit the internal `.isoformverse_pkgs` data frame in `R/packages.R`.
#' See the comments at the top of that file for step-by-step instructions.
#'
#' @export
#' @examples
#' isoformUniverse_packages()
isoformUniverse_packages <- function() {
  .isoformverse_pkgs
}
