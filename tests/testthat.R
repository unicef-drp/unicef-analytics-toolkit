# ==============================================================================
# Test Runner - UNICEF Analytics Toolkit
# ==============================================================================
# This file is used by R CMD check and testthat::test_dir()
# ==============================================================================

library(testthat)
library(here)

# Run tests depending on context: package vs. standalone repo
if (file.exists("DESCRIPTION")) {
	# Try to read package name and run test_check
	pkg <- tryCatch({
		as.character(read.dcf("DESCRIPTION")[, "Package"]) 
	}, error = function(e) NA_character_)
	if (!is.na(pkg) && nchar(pkg) > 0) {
		test_check(pkg)
	} else {
		testthat::test_dir(here::here("tests", "testthat"))
	}
} else {
	testthat::test_dir(here::here("tests", "testthat"))
}
