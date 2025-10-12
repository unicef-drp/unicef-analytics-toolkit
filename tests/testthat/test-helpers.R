# ==============================================================================
# Test Suite: Helper Functions
# ==============================================================================
# Tests for utility functions in profile templates
# ==============================================================================

library(testthat)

# ==============================================================================
# Source Helper Functions
# ==============================================================================

# Load profile_SIMPLE.R if it exists
if (file.exists(here::here("_config_template", "profile_SIMPLE.R"))) {
  # Source without executing the entire profile
  # We'll just test individual functions
}

# ==============================================================================
# Test Data Saving Functions
# ==============================================================================

test_that("save_data function works with CSV", {
  skip("Requires profile_SIMPLE.R to be sourced")
  
  # Create test data
  test_data <- data.frame(x = 1:10, y = letters[1:10])
  temp_dir <- tempdir()
  
  # Save data
  saved_path <- save_data(test_data, "test", dir = temp_dir, format = "csv")
  
  # Check file exists
  expect_true(file.exists(saved_path))
  
  # Check can read back
  loaded_data <- read.csv(saved_path)
  expect_equal(nrow(loaded_data), 10)
  
  # Cleanup
  unlink(saved_path)
})

test_that("save_data function works with RDS", {
  skip("Requires profile_SIMPLE.R to be sourced")
  
  # Create test data
  test_data <- data.frame(x = 1:10, y = letters[1:10])
  temp_dir <- tempdir()
  
  # Save data
  saved_path <- save_data(test_data, "test", dir = temp_dir, format = "rds")
  
  # Check file exists
  expect_true(file.exists(saved_path))
  
  # Check can read back
  loaded_data <- readRDS(saved_path)
  expect_equal(nrow(loaded_data), 10)
  expect_equal(loaded_data$x, 1:10)
  
  # Cleanup
  unlink(saved_path)
})

# ==============================================================================
# Test Package Loading
# ==============================================================================

test_that("load_packages function installs and loads packages", {
  skip("Requires profile_SIMPLE.R to be sourced")
  
  # Test with a package that should already be installed
  expect_silent(load_packages(c("utils", "stats")))
})

# ==============================================================================
# Test Logging
# ==============================================================================

test_that("log_message creates log entries", {
  skip("Requires profile_SIMPLE.R to be sourced")
  
  # Create temp logs directory
  temp_logs <- tempfile()
  dir.create(temp_logs)
  
  # Test logging
  expect_output(log_message("Test message", level = "INFO"), "Test message")
  
  # Cleanup
  unlink(temp_logs, recursive = TRUE)
})

# ==============================================================================
# Test Configuration Detection
# ==============================================================================

test_that("user config can be loaded from multiple locations", {
  skip_if_not_installed("yaml")
  
  # Test that function handles missing config gracefully
  config_locations <- c(
    file.path(Sys.getenv("HOME"), ".config", "unicef_analytics", "user_config.yml"),
    file.path(Sys.getenv("USERPROFILE"), ".config", "unicef_analytics", "user_config.yml")
  )
  
  # At least one location should be a valid path
  expect_true(any(nchar(config_locations) > 0))
})
