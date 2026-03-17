# CLI wrapper helpers (to make messaging easy to mock in tests) ──────────────

.cli_h1 <- function(...) {
  cli::cli_h1(..., .envir = parent.frame())
}

.cli_bullets <- function(...) {
  cli::cli_bullets(..., .envir = parent.frame())
}

.cli_alert_info <- function(...) {
  cli::cli_alert_info(..., .envir = parent.frame())
}

.cli_alert_success <- function(...) {
  cli::cli_alert_success(..., .envir = parent.frame())
}

.cli_alert_warning <- function(...) {
  cli::cli_alert_warning(..., .envir = parent.frame())
}

.cli_alert_danger <- function(...) {
  cli::cli_alert_danger(..., .envir = parent.frame())
}
