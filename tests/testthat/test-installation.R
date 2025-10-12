# ==============================================================================
# Test Suite: Installation Validation
# ==============================================================================
# Tests for critical package installation and loading
# ==============================================================================

library(testthat)

# ==============================================================================
# Test R Version
# ==============================================================================

test_that("R version meets minimum requirements", {
  r_version <- getRversion()
  expect_true(r_version >= "4.0.0",
              info = sprintf("R version %s is below minimum 4.0.0", r_version))
})

# ==============================================================================
# Test Critical Package Installation
# ==============================================================================

test_that("critical data manipulation packages are installed", {
  critical_packages <- c("tidyverse", "dplyr", "tidyr", "data.table")
  
  for (pkg in critical_packages) {
    expect_true(requireNamespace(pkg, quietly = TRUE),
                info = sprintf("Critical package '%s' not installed", pkg))
  }
})

test_that("critical I/O packages are installed", {
  io_packages <- c("readr", "readxl", "haven", "yaml")
  
  for (pkg in io_packages) {
    expect_true(requireNamespace(pkg, quietly = TRUE),
                info = sprintf("I/O package '%s' not installed", pkg))
  }
})

test_that("critical visualization packages are installed", {
  viz_packages <- c("ggplot2")
  
  for (pkg in viz_packages) {
    expect_true(requireNamespace(pkg, quietly = TRUE),
                info = sprintf("Visualization package '%s' not installed", pkg))
  }
})

test_that("configuration packages are installed", {
  config_packages <- c("yaml", "here")
  
  for (pkg in config_packages) {
    expect_true(requireNamespace(pkg, quietly = TRUE),
                info = sprintf("Configuration package '%s' not installed", pkg))
  }
})

# ==============================================================================
# Test Package Loading
# ==============================================================================

test_that("critical packages load without errors", {
  expect_silent(library(tidyverse, quietly = TRUE, warn.conflicts = FALSE))
  expect_silent(library(data.table, quietly = TRUE, warn.conflicts = FALSE))
  expect_silent(library(yaml, quietly = TRUE, warn.conflicts = FALSE))
  expect_silent(library(here, quietly = TRUE, warn.conflicts = FALSE))
})

# ==============================================================================
# Test Package Functionality
# ==============================================================================

test_that("dplyr functions work correctly", {
  skip_if_not_installed("dplyr")
  
  test_data <- data.frame(x = 1:10, y = 11:20)
  result <- dplyr::filter(test_data, x > 5)
  
  expect_equal(nrow(result), 5)
  expect_equal(result$x, 6:10)
})

test_that("yaml package can read YAML", {
  skip_if_not_installed("yaml")
  
  # Create temporary YAML file
  temp_yaml <- tempfile(fileext = ".yml")
  writeLines("test_key: test_value\ntest_number: 42", temp_yaml)
  
  # Test reading
  result <- yaml::read_yaml(temp_yaml)
  expect_equal(result$test_key, "test_value")
  expect_equal(result$test_number, 42)
  
  # Cleanup
  unlink(temp_yaml)
})

test_that("here package finds project root", {
  skip_if_not_installed("here")
  
  root <- here::here()
  expect_true(dir.exists(root))
  expect_type(root, "character")
})

# ==============================================================================
# Test Package Versions
# ==============================================================================

test_that("package versions meet minimum requirements", {
  skip_if_not_installed("tidyverse")
  
  # Get package version
  tv_version <- packageVersion("tidyverse")
  
  # tidyverse should be reasonably recent
  expect_true(tv_version >= "1.3.0",
              info = sprintf("tidyverse version %s may be outdated", tv_version))
})
