test_that("isoformUniverse_install() returns NULL invisibly when all packages installed", {
  local_mocked_bindings(
    .is_installed = function(pkg) TRUE,
    .package = "IsoformUniverse"
  )
  result <- isoformUniverse_install()
  expect_null(result)
})

test_that(".ensure_helper() errors informatively when package is missing and auto-install disabled", {
  expect_error(
    IsoformUniverse:::.ensure_helper("__not_a_real_package__", auto_install = FALSE),
    regexp = "__not_a_real_package__"
  )
})

test_that(".ensure_helper() returns silently when package is available", {
  expect_silent(IsoformUniverse:::.ensure_helper("utils"))
})

test_that(".install_one() returns FALSE for unknown source", {
  row <- data.frame(
    package = "dummy",
    source = "Unknown",
    repo = NA_character_,
    stringsAsFactors = FALSE
  )
  row$deps <- list(data.frame(
    package = character(0),
    source = character(0),
    repo = character(0),
    stringsAsFactors = FALSE
  ))
  expect_false(IsoformUniverse:::.install_one(row[1, ], auto_install_helpers = FALSE))
})
