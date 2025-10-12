# ==============================================================================
# Test Suite: Path Configuration
# ==============================================================================
# Tests for path detection and configuration loading
# ==============================================================================

library(testthat)
library(here)

# ==============================================================================
# Test Path Detection
# ==============================================================================

test_that("project root is correctly detected", {
  root <- here::here()
  
  expect_true(dir.exists(root))
  expect_type(root, "character")
  expect_gt(nchar(root), 0)
})

test_that("here() returns absolute paths", {
  test_path <- here::here("test")
  
  # Check if path is absolute (starts with / or drive letter on Windows)
  is_absolute <- grepl("^(/|[A-Za-z]:)", test_path)
  expect_true(is_absolute, info = "here() should return absolute paths")
})

# ==============================================================================
# Test Configuration File Detection
# ==============================================================================

test_that("requirements files exist", {
  root <- here::here()
  
  r_req <- file.path(root, "requirements-r.txt")
  py_req <- file.path(root, "requirements-python.txt")
  stata_req <- file.path(root, "requirements-stata.do")
  
  expect_true(file.exists(r_req), 
              info = "requirements-r.txt should exist in project root")
  expect_true(file.exists(py_req), 
              info = "requirements-python.txt should exist in project root")
  expect_true(file.exists(stata_req), 
              info = "requirements-stata.do should exist in project root")
})

test_that("README exists and is readable", {
  root <- here::here()
  readme <- file.path(root, "README.md")
  
  expect_true(file.exists(readme))
  
  # Try to read first line
  first_line <- readLines(readme, n = 1)
  expect_type(first_line, "character")
  expect_gt(nchar(first_line), 0)
})

# ==============================================================================
# Test Configuration Loading
# ==============================================================================

test_that("config template directory exists", {
  root <- here::here()
  config_dir <- file.path(root, "_config_template")
  
  expect_true(dir.exists(config_dir),
              info = "_config_template directory should exist")
})

test_that("configuration templates are present", {
  root <- here::here()
  config_dir <- file.path(root, "_config_template")
  
  templates <- c(
    "user_config.yml",
    "project_config.yml",
    "profile_TEMPLATE.R",
    "profile_SIMPLE.R"
  )
  
  for (template in templates) {
    template_path <- file.path(config_dir, template)
    expect_true(file.exists(template_path),
                info = sprintf("Template '%s' should exist", template))
  }
})

test_that("YAML config templates are valid", {
  skip_if_not_installed("yaml")
  
  root <- here::here()
  config_dir <- file.path(root, "_config_template")
  
  user_config <- file.path(config_dir, "user_config.yml")
  
  # Should not throw error when reading
  expect_silent(yaml::read_yaml(user_config))
})

# ==============================================================================
# Test Directory Creation
# ==============================================================================

test_that("logs directory can be created", {
  root <- here::here()
  logs_dir <- file.path(root, "logs")
  
  # Create if doesn't exist
  if (!dir.exists(logs_dir)) {
    dir.create(logs_dir, showWarnings = FALSE)
  }
  
  expect_true(dir.exists(logs_dir))
  
  # Test write permissions
  test_file <- file.path(logs_dir, "test.txt")
  expect_silent(writeLines("test", test_file))
  expect_true(file.exists(test_file))
  
  # Cleanup
  unlink(test_file)
})
