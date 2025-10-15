# ==============================================================================
# Test Runner - UNICEF Analytics Toolkit
# ==============================================================================
# This file is used by R CMD check and testthat::test_dir()
# ==============================================================================

library(testthat)
library(here)

# If running inside an R package, test_check will work; otherwise fall back to test_dir
if (requireNamespace("devtools", quietly = TRUE) && devtools::as.package(".", create = FALSE)$package == "unicef_analytics") {
	test_check("unicef_analytics")
} else {
	testthat::test_dir(here::here("tests", "testthat"))
}
