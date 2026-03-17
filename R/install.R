# Install and update helpers ──────────────────────────────────────────────────

# Ensure an installer helper package is available; optionally auto-install.
.ensure_helper <- function(pkg, auto_install = TRUE) {
  if (requireNamespace(pkg, quietly = TRUE)) {
    return(invisible(TRUE))
  }

  if (!auto_install) {
    cli::cli_alert_danger(
      "Package {.pkg {pkg}} is required for this operation but is not \
       installed. Install it from CRAN with \
       {.code install.packages(\"{pkg}\")}."
    )
    stop(sprintf("Package '%s' is required but not installed.", pkg),
      call. = FALSE
    )
  }

  cli::cli_alert_info(
    "Package {.pkg {pkg}} is required and will be installed from CRAN ..."
  )
  utils::install.packages(pkg)

  if (!requireNamespace(pkg, quietly = TRUE)) {
    stop(
      sprintf(
        "Failed to install required helper package '%s' from CRAN.",
        pkg
      ),
      call. = FALSE
    )
  }

  invisible(TRUE)
}

# Install one dependency row (package/source/repo).
.install_dependency <- function(dep, ..., auto_install_helpers = TRUE) {
  dep_pkg <- dep[["package"]]
  dep_source <- dep[["source"]]
  dep_repo <- dep[["repo"]]

  if (.is_installed(dep_pkg)) {
    return(invisible(TRUE))
  }

  cli::cli_alert_info("Installing dependency {.pkg {dep_pkg}} ({.val {dep_source}}) ...")

  if (dep_source == "Bioconductor") {
    .ensure_helper("BiocManager", auto_install = auto_install_helpers)
    BiocManager::install(dep_pkg, update = FALSE, ask = FALSE, ...)
  } else if (dep_source == "GitHub") {
    .ensure_helper("remotes", auto_install = auto_install_helpers)
    remotes::install_github(dep_repo, upgrade = "never", ...)
  } else {
    cli::cli_alert_warning(
      "Unknown dependency source {.val {dep_source}} for {.pkg {dep_pkg}}; skipping."
    )
    return(invisible(FALSE))
  }

  if (!.is_installed(dep_pkg)) {
    cli::cli_alert_warning(
      "Dependency {.pkg {dep_pkg}} could not be installed successfully."
    )
    return(invisible(FALSE))
  }

  invisible(TRUE)
}

# Install a single package given a row from `.isoformverse_pkgs`.
.install_one <- function(row, ..., auto_install_helpers = TRUE) {
  pkg <- row[["package"]]
  source <- row[["source"]]
  repo <- row[["repo"]]
  deps <- row[["deps"]][[1]]

  if (is.data.frame(deps) && nrow(deps) > 0) {
    for (i in seq_len(nrow(deps))) {
      .install_dependency(deps[i, ], ..., auto_install_helpers = auto_install_helpers)
    }
  }

  if (source == "Bioconductor") {
    .ensure_helper("BiocManager", auto_install = auto_install_helpers)
    cli::cli_alert_info("Installing {.pkg {pkg}} from Bioconductor ...")
    BiocManager::install(pkg, update = FALSE, ask = FALSE, ...)
  } else if (source == "GitHub") {
    .ensure_helper("remotes", auto_install = auto_install_helpers)
    cli::cli_alert_info("Installing {.pkg {pkg}} from GitHub ({.val {repo}}) ...")
    remotes::install_github(repo, upgrade = "never", ...)
  } else {
    cli::cli_alert_warning("Unknown source {.val {source}} for {.pkg {pkg}}; skipping.")
    return(invisible(FALSE))
  }

  if (!.is_installed(pkg)) {
    cli::cli_alert_danger(
      "Package {.pkg {pkg}} did not install correctly. Please check installation logs above."
    )
    return(invisible(FALSE))
  }

  cli::cli_alert_success("Installed {.pkg {pkg}}.")
  invisible(TRUE)
}

# Update a single package given a row from `.isoformverse_pkgs`.
.update_one <- function(row, ..., auto_install_helpers = TRUE) {
  pkg <- row[["package"]]
  source <- row[["source"]]
  repo <- row[["repo"]]
  old_version <- if (.is_installed(pkg)) {
    as.character(utils::packageVersion(pkg))
  } else {
    NA_character_
  }

  if (source == "Bioconductor") {
    .ensure_helper("BiocManager", auto_install = auto_install_helpers)
    cli::cli_alert_info("Updating {.pkg {pkg}} from Bioconductor ...")
    BiocManager::install(pkg, update = TRUE, ask = FALSE, ...)
  } else if (source == "GitHub") {
    .ensure_helper("remotes", auto_install = auto_install_helpers)
    cli::cli_alert_info("Updating {.pkg {pkg}} from GitHub ({.val {repo}}) ...")
    remotes::install_github(repo, upgrade = "always", ...)
  } else {
    cli::cli_alert_warning("Unknown source {.val {source}} for {.pkg {pkg}}; skipping.")
    return(invisible(NA))
  }

  if (!.is_installed(pkg)) {
    cli::cli_alert_danger(
      "Package {.pkg {pkg}} is still not installed after update attempt."
    )
    return(invisible(NA))
  }

  new_version <- as.character(utils::packageVersion(pkg))
  updated <- is.na(old_version) || !identical(old_version, new_version)

  if (updated) {
    cli::cli_alert_success("Updated {.pkg {pkg}} ({old_version} -> {new_version}).")
  } else {
    cli::cli_alert_info("{.pkg {pkg}} is already up to date ({new_version}).")
  }

  invisible(updated)
}

# Public API ──────────────────────────────────────────────────────────────────

#' Install IsoformUniverse packages
#'
#' Installs all packages listed in [isoformUniverse_packages()] that are not
#' yet installed on your system. Packages are fetched from the appropriate
#' source (Bioconductor or GitHub) according to the package registry.
#'
#' * **Bioconductor** packages are installed via
#'   [BiocManager::install()][BiocManager::install].
#' * **GitHub** packages are installed via
#'   [remotes::install_github()][remotes::install_github].
#'
#' Installer helper packages (`BiocManager` and `remotes`) are installed from
#' CRAN on demand by default.
#'
#' @param ... Additional arguments passed to the underlying installer
#'   ([BiocManager::install()] or [remotes::install_github()]).
#' @param auto_install_helpers Logical; if `TRUE` (default), automatically
#'   install missing helper packages (`BiocManager` and `remotes`) from CRAN.
#'   If `FALSE`, error when a required helper package is missing.
#'
#' @return Invisibly returns `NULL`. The function is called for its side-effect
#'   of installing packages.
#' @export
#' @examples
#' \dontrun{
#' isoformUniverse_install()
#' }
isoformUniverse_install <- function(..., auto_install_helpers = TRUE) {
  pkgs <- isoformUniverse_packages()
  missing_mask <- !vapply(pkgs$package, .is_installed, logical(1))
  to_install <- pkgs[missing_mask, , drop = FALSE]

  if (nrow(to_install) == 0) {
    cli::cli_alert_success("All IsoformUniverse packages are already installed.")
    return(invisible(NULL))
  }

  cli::cli_h1("Installing IsoformUniverse packages")
  results <- vapply(
    seq_len(nrow(to_install)),
    function(i) {
      .install_one(to_install[i, ], ..., auto_install_helpers = auto_install_helpers)
    },
    logical(1)
  )

  failed <- to_install$package[!results]
  if (length(failed) > 0) {
    cli::cli_alert_warning(
      "Installation finished with failures for: {.pkg {failed}}"
    )
  } else {
    cli::cli_alert_success("Installation complete.")
  }

  invisible(NULL)
}

#' Update IsoformUniverse packages
#'
#' Updates all packages listed in [isoformUniverse_packages()] to their latest
#' versions. Unlike [isoformUniverse_install()], this function also updates
#' packages that are already installed.
#'
#' * **Bioconductor** packages are updated via
#'   [BiocManager::install()][BiocManager::install].
#' * **GitHub** packages are updated via
#'   [remotes::install_github()][remotes::install_github] with
#'   `upgrade = "always"`.
#'
#' @param ... Additional arguments passed to the underlying installer.
#' @param auto_install_helpers Logical; if `TRUE` (default), automatically
#'   install missing helper packages (`BiocManager` and `remotes`) from CRAN.
#'   If `FALSE`, error when a required helper package is missing.
#'
#' @return Invisibly returns `NULL`. The function is called for its side-effect
#'   of updating packages.
#' @export
#' @examples
#' \dontrun{
#' isoformUniverse_update()
#' }
isoformUniverse_update <- function(..., auto_install_helpers = TRUE) {
  pkgs <- isoformUniverse_packages()

  cli::cli_h1("Updating IsoformUniverse packages")
  results <- vapply(
    seq_len(nrow(pkgs)),
    function(i) {
      .update_one(pkgs[i, ], ..., auto_install_helpers = auto_install_helpers)
    },
    logical(1)
  )

  failed <- pkgs$package[is.na(results)]
  any_updated <- any(results, na.rm = TRUE)

  if (length(failed) > 0) {
    cli::cli_alert_warning(
      "Update finished with failures for: {.pkg {failed}}"
    )
  } else if (any_updated) {
    cli::cli_alert_success("Update complete.")
  } else {
    cli::cli_alert_info("Packages are up to date; no update carried out.")
  }

  invisible(NULL)
}
