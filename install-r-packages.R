#!/usr/bin/env Rscript
# ==============================================================================
# R Package Installation Script - UNICEF Analytics Environment
# ==============================================================================
# Usage: Rscript install-r-packages.R
# ==============================================================================

cat("\n")
cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
cat("  UNICEF Analytics Environment - R Package Installation\n")
cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
cat("\n")

# ==============================================================================
# Check R Version
# ==============================================================================

r_version <- getRversion()
cat(sprintf("✓ R version: %s\n", r_version))

if (r_version < "4.0.0") {
  stop("❌ R version 4.0.0 or higher is required. Please upgrade R.")
}

# ==============================================================================
# Configuration
# ==============================================================================

# Determine installation type based on OS
install_type <- ifelse(.Platform$OS.type == "windows", "binary", "both")
cat(sprintf("✓ Installation type: %s\n", install_type))
cat(sprintf("✓ Platform: %s\n\n", .Platform$OS.type))

# Read required packages
if (!file.exists("requirements-r.txt")) {
  stop("❌ requirements-r.txt not found. Please run from repository root.")
}

# Read and parse requirements file
all_lines <- readLines("requirements-r.txt")

# Remove comments, empty lines, and section headers
required_packages <- all_lines[
  !grepl("^#", all_lines) &           # Not a comment
  !grepl("^=", all_lines) &           # Not a separator
  nzchar(trimws(all_lines))           # Not empty
]

# Extract package names (remove inline comments)
required_packages <- trimws(sapply(strsplit(required_packages, "#"), `[`, 1))
required_packages <- required_packages[nzchar(required_packages)]

cat(sprintf("📦 Found %d packages to install/check\n\n", length(required_packages)))

# ==============================================================================
# Package Installation Functions
# ==============================================================================

#' Check if a package is installed
#' @param pkg Package name
#' @return TRUE if installed, FALSE otherwise
is_installed <- function(pkg) {
  pkg %in% rownames(installed.packages())
}

#' Install a single package with error handling
#' @param pkg Package name
#' @param type Installation type
#' @return List with success status, package name, and error message
install_package <- function(pkg, type = install_type) {
  tryCatch({
    if (type == "binary") {
      install.packages(pkg, type = "binary", quiet = TRUE)
    } else {
      install.packages(pkg, quiet = TRUE)
    }
    return(list(success = TRUE, pkg = pkg, error = NULL, retry = FALSE))
  }, error = function(e) {
    # Log the error with details
    error_msg <- conditionMessage(e)
    warning(sprintf("Failed to install %s (%s): %s", pkg, type, error_msg))
    
    # Try source installation if binary fails
    if (type == "binary") {
      message(sprintf("  Retrying %s from source...", pkg))
      tryCatch({
        install.packages(pkg, type = "source", quiet = TRUE)
        return(list(success = TRUE, pkg = pkg, error = NULL, retry = TRUE))
      }, error = function(e2) {
        error_msg2 <- conditionMessage(e2)
        warning(sprintf("  Source install also failed for %s: %s", pkg, error_msg2))
        return(list(success = FALSE, pkg = pkg, error = error_msg2, retry = TRUE))
      })
    }
    return(list(success = FALSE, pkg = pkg, error = error_msg, retry = FALSE))
  }, warning = function(w) {
    # Log warnings but continue
    message(sprintf("  Warning for %s: %s", pkg, conditionMessage(w)))
    return(list(success = TRUE, pkg = pkg, error = NULL, warning = conditionMessage(w)))
  })
}

# ==============================================================================
# Main Installation Process
# ==============================================================================

cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
cat("  Installing Packages\n")
cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n")

# Get list of packages to install
already_installed <- sapply(required_packages, is_installed)
to_install <- required_packages[!already_installed]

if (length(to_install) == 0) {
  cat("✓ All packages already installed!\n\n")
} else {
  cat(sprintf("📥 Installing %d new package(s):\n\n", length(to_install)))
  
  # Installation counters
  success_count <- 0
  fail_count <- 0
  failed_packages <- list()
  
  # Install each package
  for (i in seq_along(to_install)) {
    pkg <- to_install[i]
    cat(sprintf("[%d/%d] Installing: %-30s ... ", i, length(to_install), pkg))
    
    result <- install_package(pkg)
    
    if (result$success) {
      if (result$retry) {
        cat("✓ (from source)\n")
      } else {
        cat("✓\n")
      }
      success_count <- success_count + 1
    } else {
      cat("❌\n")
      fail_count <- fail_count + 1
      failed_packages[[pkg]] <- result$error
    }
  }
  
  cat("\n")
  cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
  cat("  Installation Summary\n")
  cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n")
  
  cat(sprintf("  Already installed:  %d packages\n", sum(already_installed)))
  cat(sprintf("  Newly installed:    %d packages\n", success_count))
  cat(sprintf("  Failed:             %d packages\n\n", fail_count))
  
  if (fail_count > 0) {
    cat("⚠️  Failed packages:\n")
    for (pkg in names(failed_packages)) {
      error_msg <- failed_packages[[pkg]]
      cat(sprintf("   - %s\n", pkg))
      if (!is.null(error_msg)) {
        cat(sprintf("     Error: %s\n", substr(error_msg, 1, 100)))
      }
    }
    cat("\nTroubleshooting:\n")
    cat("  1. Check your internet connection\n")
    cat("  2. Verify CRAN mirror is accessible\n")
    cat("  3. Try installing failed packages manually: install.packages('package_name')\n")
    cat("  4. Check package dependencies\n")
    cat("  5. See installation log for details\n\n")
  }
}

# ==============================================================================
# Update Existing Packages (Optional)
# ==============================================================================

cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
cat("  Checking for Updates\n")
cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n")

old_packages <- old.packages()
if (!is.null(old_packages)) {
  cat(sprintf("🔄 %d package(s) have updates available\n", nrow(old_packages)))
  cat("   To update all packages, run: update.packages(ask = FALSE)\n\n")
} else {
  cat("✓ All packages are up to date\n\n")
}

# ==============================================================================
# Verify Critical Packages
# ==============================================================================

cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
cat("  Verifying Critical Packages\n")
cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n")

critical_packages <- c(
  "tidyverse", "dplyr", "ggplot2", "data.table", 
  "readr", "haven", "yaml", "rmarkdown", "knitr"
)

cat("Checking critical packages:\n")
all_critical_ok <- TRUE
for (pkg in critical_packages) {
  if (requireNamespace(pkg, quietly = TRUE)) {
    cat(sprintf("   ✓ %s\n", pkg))
  } else {
    cat(sprintf("   ❌ %s - FAILED TO LOAD\n", pkg))
    all_critical_ok <- FALSE
  }
}

cat("\n")

# ==============================================================================
# Display Session Info
# ==============================================================================

cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
cat("  System Information\n")
cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n")

cat(sprintf("  R version:        %s\n", R.version.string))
cat(sprintf("  Platform:         %s\n", R.version$platform))
cat(sprintf("  OS:               %s\n", R.version$os))
cat(sprintf("  Packages loaded:  %d\n", length(.packages(all.available = TRUE))))

cat("\n")

# ==============================================================================
# Final Messages
# ==============================================================================

cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")

if (all_critical_ok && fail_count == 0) {
  cat("  ✅ Installation Successful!\n")
  cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n")
  cat("Next steps:\n")
  cat("  1. Install Python packages: pip install -r requirements-python.txt\n")
  cat("  2. Install Stata packages: do requirements-stata.do (if using Stata)\n")
  cat("  3. Run: make check\n\n")
} else {
  cat("  ⚠️  Installation Completed with Warnings\n")
  cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n")
  cat("Some packages may need manual attention.\n")
  cat("Check the logs above for details.\n\n")
}

# ==============================================================================
# Create Installation Log
# ==============================================================================

# Create logs directory if it doesn't exist
if (!dir.exists("logs")) {
  dir.create("logs", recursive = TRUE)
}

# Save installation log
log_file <- file.path("logs", sprintf("r-install-%s.log", format(Sys.time(), "%Y%m%d_%H%M%S")))
sink(log_file, append = FALSE, split = FALSE)
cat("R Package Installation Log\n")
cat("==========================\n\n")
cat(sprintf("Date: %s\n", Sys.time()))
cat(sprintf("R Version: %s\n\n", R.version.string))
cat("Installed Packages:\n")
installed_df <- as.data.frame(installed.packages()[, c("Package", "Version")])
print(installed_df[order(installed_df$Package), ])
sink()

cat(sprintf("📝 Installation log saved to: %s\n\n", log_file))

# ==============================================================================
# End of Script
# ==============================================================================
