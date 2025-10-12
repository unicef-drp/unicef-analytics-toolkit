# Testing Guide - UNICEF Analytics Toolkit

## Overview

This document describes the test suite and how to run tests for the UNICEF Analytics Toolkit.

## Test Structure

```
tests/
├── testthat/               # R tests
│   ├── test-installation.R
│   ├── test-paths.R
│   └── test-helpers.R
├── python/                 # Python tests
│   ├── test_installation.py
│   ├── test_validation.py
│   └── conftest.py
└── stata/                  # Stata tests (future)
```

## Running Tests

### R Tests

#### Using testthat

```r
# Install testthat if needed
install.packages("testthat")

# Run all tests
testthat::test_dir("tests/testthat")

# Run specific test file
testthat::test_file("tests/testthat/test-installation.R")

# Run with detailed output
testthat::test_dir("tests/testthat", reporter = "progress")
```

#### From Command Line

```bash
# R CMD check style
Rscript -e "testthat::test_dir('tests/testthat')"

# Or use make
make test-r
```

### Python Tests

#### Using pytest

```bash
# Install pytest if needed
pip install pytest

# Run all tests
pytest tests/python/ -v

# Run specific test file
pytest tests/python/test_installation.py -v

# Run with coverage
pip install pytest-cov
pytest tests/python/ --cov=. --cov-report=html
```

#### From Make

```bash
make test-python
```

### All Tests

```bash
# Run all tests (R + Python)
make test
```

## Test Categories

### 1. Installation Tests

**File**: `test-installation.R`, `test_installation.py`

Tests:
- R/Python version meets minimum requirements
- Critical packages are installed
- Packages can be imported/loaded
- Package versions meet requirements
- Basic functionality works

**Example**:

```r
test_that("critical data manipulation packages are installed", {
  critical_packages <- c("tidyverse", "dplyr", "tidyr", "data.table")
  for (pkg in critical_packages) {
    expect_true(requireNamespace(pkg, quietly = TRUE))
  }
})
```

### 2. Path and Configuration Tests

**File**: `test-paths.R`, `test_validation.py`

Tests:
- Project root is correctly detected
- Requirements files exist
- Configuration templates are present
- YAML configs are valid
- Directories can be created and are writable

**Example**:

```python
def test_requirements_files_exist():
    project_root = Path(__file__).parent.parent.parent
    requirements_files = [
        'requirements-python.txt',
        'requirements-r.txt',
        'requirements-stata.do'
    ]
    for req_file in requirements_files:
        assert (project_root / req_file).exists()
```

### 3. Helper Function Tests

**File**: `test-helpers.R`

Tests:
- Data saving functions work
- Package loading functions work
- Logging functions work
- Configuration detection works

## Continuous Integration

Tests run automatically on:
- Every push to `main` or `develop` branches
- Every pull request
- Manual workflow dispatch

### CI Matrix

**R Testing**:
- OS: Ubuntu, Windows, macOS
- R versions: 4.0, 4.1, 4.2, 4.3

**Python Testing**:
- OS: Ubuntu, Windows, macOS
- Python versions: 3.9, 3.10, 3.11, 3.12

See `.github/workflows/test-installation.yml` for details.

## Writing New Tests

### R Test Template

```r
# tests/testthat/test-myfeature.R

library(testthat)

test_that("feature description", {
  # Arrange
  test_data <- data.frame(x = 1:10)
  
  # Act
  result <- my_function(test_data)
  
  # Assert
  expect_equal(nrow(result), 10)
  expect_true(is.data.frame(result))
})
```

### Python Test Template

```python
# tests/python/test_myfeature.py

import pytest

def test_feature_description():
    """Test that feature works as expected"""
    # Arrange
    test_data = [1, 2, 3, 4, 5]
    
    # Act
    result = my_function(test_data)
    
    # Assert
    assert len(result) == 5
    assert all(isinstance(x, int) for x in result)
```

## Test Coverage Goals

- **Critical paths**: 100% coverage
- **Installation validation**: 100% coverage
- **Configuration loading**: 90% coverage
- **Helper functions**: 80% coverage

## Common Issues

### R Tests

**Issue**: Package not found

```r
# Solution: Skip if not installed
test_that("optional feature works", {
  skip_if_not_installed("optional_package")
  # test code
})
```

**Issue**: Platform-specific behavior

```r
# Solution: Skip on certain platforms
test_that("windows feature works", {
  skip_on_os(c("mac", "linux"))
  # windows-specific test
})
```

### Python Tests

**Issue**: Module not found

```python
# Solution: Skip if not available
@pytest.mark.skipif(not importable("module"), reason="module not installed")
def test_feature():
    # test code
```

**Issue**: Temporary files

```python
# Solution: Use pytest fixtures
@pytest.fixture
def temp_file():
    f = tempfile.NamedTemporaryFile(delete=False)
    yield f.name
    os.unlink(f.name)
```

## Resources

- [testthat documentation](https://testthat.r-lib.org/)
- [pytest documentation](https://docs.pytest.org/)
- [R CMD check](https://r-pkgs.org/r-cmd-check.html)
- [GitHub Actions for R](https://github.com/r-lib/actions)
