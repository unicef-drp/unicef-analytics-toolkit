# Changelog

All notable changes to the UNICEF Analytics Toolkit will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- **Testing Infrastructure** ([#1](https://github.com/unicef/analytics-toolkit/issues/1))
  - R test suite using `testthat` for installation validation
  - Python test suite using `pytest` for environment validation
  - Test coverage for critical packages, paths, and configuration loading
  - Tests for R, Python package functionality

- **CI/CD Pipeline** ([#2](https://github.com/unicef/analytics-toolkit/issues/2))
  - GitHub Actions workflow for multi-platform testing (Windows, macOS, Linux)
  - Automated testing across multiple R versions (4.0, 4.1, 4.2, 4.3)
  - Automated testing across multiple Python versions (3.9, 3.10, 3.11, 3.12)
  - Linting workflow for Markdown, YAML, R, and Python
  - Status badges in README

- **Enhanced Error Handling** ([#3](https://github.com/unicef/analytics-toolkit/issues/3))
  - Detailed error logging in `install-r-packages.R`
  - Structured error reporting with specific failure reasons
  - Troubleshooting guidance for common installation errors
  - Improved logging in `install-python-packages.py` with error details
  - Installation log files saved to `logs/` directory

- **GitHub Issue Templates**
  - Bug report template
  - Feature request template
  - 8 pre-written issues for roadmap items (P0-P3 priorities)

### Changed

- **install-r-packages.R**
  - `install_package()` now returns structured result with success status and error details
  - Failed packages list now includes error messages
  - Added comprehensive troubleshooting section to output

- **install-python-packages.py**
  - `install_packages()` returns dictionary of failed packages with errors
  - `save_installation_log()` includes full error details
  - Enhanced error messages with truncation for readability

- **profile_TEMPLATE.R**
  - Fixed namespace issues in `check_data_quality()` function
  - Explicit use of `dplyr::`, `tidyr::`, `magrittr::` namespaces
  - Proper use of `.data` pronoun for non-standard evaluation

- **README.md**
  - Added CI/CD status badges
  - Added Testing section with instructions
  - Added Development section
  - Enhanced Contributing guidelines

### Fixed

- R namespace errors in `profile_TEMPLATE.R` ([#5](https://github.com/unicef/analytics-toolkit/issues/5))
  - No visible global function definition for `%>%`
  - No visible binding for global variable `.data`
  - Functions now use explicit namespace qualification

---

## [2.0.0] - 2025-10-10

### Added

- Initial public release
- Renamed from "UNICEF Analytics Setup" to "UNICEF Analytics Toolkit"
- Comprehensive installation scripts for R, Python, and Stata
- Configuration template system
- Profile templates for reproducible workflows
- Makefile with 40+ automation commands
- Comprehensive documentation (README, INSTALL, CONFIG guides)
- World Bank EduAnalyticsToolkit integration analysis

### Changed

- Repository name and branding
- Attribution to UNICEF Chief Statistician Office
- Enhanced documentation structure

---

## [1.0.0] - 2025-10-08

### Added

- Basic installation scripts
- Requirements files for R, Python, Stata
- Configuration templates
- Initial documentation

---

## Issue Tracking

### Current Open Issues

- [P0] Add automated testing infrastructure (#1) - ✅ **COMPLETED**
- [P0] Implement CI/CD pipeline (#2) - ✅ **COMPLETED**
- [P1] Improve error handling and logging (#3) - ✅ **COMPLETED**
- [P1] Create validation framework (#4) - 🔄 In Progress
- [P2] Fix R namespace issues in templates (#5) - ✅ **COMPLETED**
- [P2] Add version lockfiles for reproducibility (#6) - 📋 Planned
- [P3] Fix markdown linting errors (#7) - 📋 Planned
- [Enhancement] Convert to proper R/Python packages (#8) - 📋 Future

---

## Version History

- **v2.0.0** (2025-10-10) - Production-ready release with testing and CI/CD
- **v1.0.0** (2025-10-08) - Initial release

---

*For more details on each change, see the corresponding issue or pull request.*
