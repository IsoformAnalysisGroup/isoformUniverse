test_that("isoformUniverse_packages() returns a data frame", {
  pkgs <- isoformUniverse_packages()
  expect_s3_class(pkgs, "data.frame")
})

test_that("isoformUniverse_packages() has required columns", {
  pkgs <- isoformUniverse_packages()
  expect_true(all(c("package", "source", "repo", "deps") %in% names(pkgs)))
})

test_that("isoformUniverse_packages() contains expected packages", {
  pkgs <- isoformUniverse_packages()
  pkg_names <- pkgs$package
  expect_true("pairedGSEA" %in% pkg_names)
  expect_true("IsoformSwitchAnalyzeR" %in% pkg_names)
})

test_that("isoformUniverse_packages() source values are valid", {
  pkgs <- isoformUniverse_packages()
  valid_sources <- c("Bioconductor", "GitHub")
  expect_true(all(pkgs$source %in% valid_sources))
})

test_that("GitHub packages have a repo path", {
  pkgs <- isoformUniverse_packages()
  github_pkgs <- pkgs[pkgs$source == "GitHub", ]
  expect_true(all(!is.na(github_pkgs$repo)))
  # repo paths should be in "owner/repo" format
  expect_true(all(grepl("^[^/]+/[^/]+$", github_pkgs$repo)))
})

test_that("Bioconductor packages have NA repo", {
  pkgs <- isoformUniverse_packages()
  bioc_pkgs <- pkgs[pkgs$source == "Bioconductor", ]
  expect_true(all(is.na(bioc_pkgs$repo)))
})

test_that("isoformUniverse_packages() returns no duplicate package names", {
  pkgs <- isoformUniverse_packages()
  expect_equal(length(unique(pkgs$package)), nrow(pkgs))
})

test_that("deps column is a list of data frames with required columns", {
  pkgs <- isoformUniverse_packages()
  expect_true(is.list(pkgs$deps))
  expect_true(all(vapply(pkgs$deps, is.data.frame, logical(1))))
  expect_true(all(vapply(
    pkgs$deps,
    function(x) all(c("package", "source", "repo") %in% names(x)),
    logical(1)
  )))
})
