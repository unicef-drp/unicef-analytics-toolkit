# ==============================================================================
# UNICEF Analytics Project - Profile Script
# ==============================================================================
# Filename: profile_PROJECT-NAME.R
# Purpose: Set up project environment, load packages, define paths
# Usage: Source this file at the start of any project script
#        source("profile_PROJECT-NAME.R")
# ==============================================================================

# ==============================================================================
# SESSION INFO
# ==============================================================================
message("═══════════════════════════════════════════════════════════════")
message("  UNICEF Analytics - Project Environment Setup")
message("  Project: [YOUR PROJECT NAME]")
message("  Date: ", Sys.Date())
message("═══════════════════════════════════════════════════════════════\n")

# ==============================================================================
# CLEAR ENVIRONMENT (OPTIONAL - comment out if not desired)
# ==============================================================================
# rm(list = ls())
# gc()

# ==============================================================================
# SET WORKING DIRECTORY
# ==============================================================================
# Option 1: Use here package (RECOMMENDED)
if (!requireNamespace("here", quietly = TRUE)) install.packages("here")
library(here)
# Working directory will be project root (where .Rproj or .git is)

# Option 2: Manual setting (if here doesn't work)
# setwd("C:/path/to/your/project")

message("✓ Working directory: ", here::here())

# ==============================================================================
# LOAD CONFIGURATION
# ==============================================================================
message("\n📋 Loading configuration...")

# Load YAML configuration
if (!requireNamespace("yaml", quietly = TRUE)) install.packages("yaml")
library(yaml)

# Load project config
if (file.exists(here("config.yml"))) {
  config <<- read_yaml(here("config.yml"))
  message("✓ Project configuration loaded")
} else {
  warning("⚠ config.yml not found. Using defaults.")
  config <<- list()
}

# Load user config (optional)
user_config_path <- path.expand("~/.config/user_config.yml")
if (file.exists(user_config_path)) {
  user_config <<- read_yaml(user_config_path)
  message("✓ User configuration loaded")
} else {
  user_config <<- list()
}

# Load environment variables from .env file (if exists)
if (!requireNamespace("dotenv", quietly = TRUE)) install.packages("dotenv")
if (file.exists(here(".env"))) {
  dotenv::load_dot_env(here(".env"))
  message("✓ Environment variables loaded from .env")
}

# ==============================================================================
# PACKAGE MANAGEMENT
# ==============================================================================
message("\n📦 Loading packages...")

# Function to install and load packages
load_packages <- function(packages) {
  for (pkg in packages) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      message("  Installing ", pkg, "...")
      install.packages(pkg, repos = "https://cloud.r-project.org/")
    }
    suppressPackageStartupMessages(library(pkg, character.only = TRUE))
  }
  message("✓ Loaded ", length(packages), " packages")
}

# Core packages (ALWAYS LOADED)
core_packages <- c(
  "here",          # Path management
  "yaml",          # Configuration
  "dotenv"         # Environment variables
)

# Data manipulation packages
data_packages <- c(
  "tidyverse",     # Data manipulation suite
  "data.table",    # Fast data operations
  "janitor",       # Data cleaning
  "lubridate"      # Date handling
)

# Import/Export packages
io_packages <- c(
  "haven",         # SPSS, Stata, SAS files
  "readxl",        # Excel files
  "openxlsx",      # Excel writing
  "arrow"          # Parquet files
)

# Statistical packages
stats_packages <- c(
  "survey",        # Survey analysis
  "srvyr"          # dplyr-friendly survey analysis
)

# API packages
api_packages <- c(
  "httr",          # HTTP requests
  "jsonlite",      # JSON parsing
  "wbstats"        # World Bank data
)

# Visualization packages
viz_packages <- c(
  "ggplot2",       # Grammar of graphics
  "scales",        # Scale functions
  "patchwork",     # Combine plots
  "viridis"        # Color palettes
)

# Reporting packages
report_packages <- c(
  "rmarkdown",     # R Markdown
  "knitr",         # Report generation
  "quarto"         # Quarto publishing
)

# Quality control packages
quality_packages <- c(
  "testthat",      # Unit testing
  "assertthat"     # Assertions
)

# Load packages based on project needs
# Customize this list for your project
load_packages(c(
  core_packages,
  data_packages,
  io_packages,
  # stats_packages,  # Uncomment if needed
  # api_packages,    # Uncomment if needed
  # viz_packages,    # Uncomment if needed
  # report_packages, # Uncomment if needed
  # quality_packages # Uncomment if needed
))

# ==============================================================================
# PROJECT PATHS
# ==============================================================================
message("\n📁 Setting up project paths...")

# Create paths list
paths <- list(
  root = here(),
  
  # Main directories
  data = here("01_data_prep"),
  analysis = here("02_analysis"),
  outputs = here("03_outputs"),
  docs = here("04_documentation"),
  
  # Data subdirectories
  data_raw = here("01_data_prep", "011_raw_data"),
  data_scripts = here("01_data_prep", "012_codes"),
  data_processed = here("01_data_prep", "013_processed_data"),
  data_cache = here("01_data_prep", "014_cache"),
  
  # Analysis subdirectories
  analysis_scripts = here("02_analysis", "021_codes"),
  analysis_results = here("02_analysis", "022_results"),
  
  # Output subdirectories
  outputs_reports = here("03_outputs", "031_reports"),
  outputs_figures = here("03_outputs", "032_figures"),
  outputs_tables = here("03_outputs", "033_tables"),
  outputs_data = here("03_outputs", "034_data_exports")
)

# Create directories if they don't exist
for (path_name in names(paths)) {
  if (!dir.exists(paths[[path_name]])) {
    dir.create(paths[[path_name]], recursive = TRUE, showWarnings = FALSE)
  }
}

# Make paths available globally
paths <<- paths

message("✓ Project paths configured")
message("  Data directory: ", paths$data)
message("  Outputs directory: ", paths$outputs)

# ==============================================================================
# GLOBAL OPTIONS
# ==============================================================================
message("\n⚙️  Setting global options...")

# General options
options(
  stringsAsFactors = FALSE,
  scipen = 999,  # Avoid scientific notation
  digits = 4,
  encoding = "UTF-8"
)

# ggplot2 theme
if ("ggplot2" %in% loadedNamespaces()) {
  theme_set(theme_minimal(base_size = 12))
  
  # UNICEF color palette
  unicef_colors <- c(
    blue = "#1CABE2",
    green = "#00833D", 
    yellow = "#FFC20E",
    orange = "#F26A21",
    red = "#E2231A",
    purple = "#961A49"
  )
  
  # Make available globally
  unicef_colors <<- unicef_colors
}

# Parallel processing
if (requireNamespace("parallel", quietly = TRUE)) {
  n_cores <- parallel::detectCores() - 1
  options(mc.cores = n_cores)
  message("  Parallel processing: ", n_cores, " cores available")
}

# Set seed for reproducibility
set.seed(12345)

message("✓ Global options configured")

# ==============================================================================
# HELPER FUNCTIONS
# ==============================================================================
message("\n🔧 Loading helper functions...")

# Function: Save data with automatic date stamping
save_data <- function(data, name, format = "rds", add_date = TRUE) {
  if (add_date) {
    filename <- paste0(name, "_", format(Sys.Date(), "%Y%m%d"), ".", format)
  } else {
    filename <- paste0(name, ".", format)
  }
  
  filepath <- file.path(paths$data_processed, filename)
  
  if (format == "rds") {
    saveRDS(data, filepath)
  } else if (format == "csv") {
    write.csv(data, filepath, row.names = FALSE)
  } else if (format == "parquet") {
    arrow::write_parquet(data, filepath)
  }
  
  message("✓ Saved: ", filepath)
  invisible(filepath)
}

# Function: Load most recent version of data
load_latest_data <- function(name, format = "rds") {
  pattern <- paste0(name, "_.*\\.", format, "$")
  files <- list.files(paths$data_processed, pattern = pattern, full.names = TRUE)
  
  if (length(files) == 0) {
    stop("No files found matching pattern: ", pattern)
  }
  
  # Get most recent file
  latest_file <- files[order(file.mtime(files), decreasing = TRUE)][1]
  
  message("Loading: ", basename(latest_file))
  
  if (format == "rds") {
    return(readRDS(latest_file))
  } else if (format == "csv") {
    return(read.csv(latest_file))
  } else if (format == "parquet") {
    return(arrow::read_parquet(latest_file))
  }
}

# Function: Create timestamped log entry
log_message <- function(msg, level = "INFO") {
  timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  log_entry <- sprintf("[%s] %s: %s", timestamp, level, msg)
  
  # Print to console
  message(log_entry)
  
  # Append to log file if it exists
  log_dir <- here("logs")
  if (!dir.exists(log_dir)) dir.create(log_dir, recursive = TRUE)
  
  log_file <- file.path(log_dir, paste0("project_", format(Sys.Date(), "%Y%m%d"), ".log"))
  cat(log_entry, "\n", file = log_file, append = TRUE)
  
  invisible(log_entry)
}

# Function: Check data quality
check_data_quality <- function(data, name = "dataset") {
  log_message(paste("Checking quality of", name))
  
  # Ensure required packages are loaded
  if (!requireNamespace("dplyr", quietly = TRUE)) {
    stop("Package 'dplyr' is required for this function")
  }
  if (!requireNamespace("tidyr", quietly = TRUE)) {
    stop("Package 'tidyr' is required for this function")
  }
  
  # Load magrittr pipe
  `%>%` <- magrittr::`%>%`
  
  # Basic checks
  n_rows <- nrow(data)
  n_cols <- ncol(data)
  
  # Missing values - with explicit namespace and .data pronoun
  missing_summary <- data %>%
    dplyr::summarise(dplyr::across(dplyr::everything(), ~sum(is.na(.)) / dplyr::n())) %>%
    tidyr::pivot_longer(dplyr::everything(), names_to = "variable", values_to = "missing_pct") %>%
    dplyr::filter(dplyr::.data$missing_pct > 0) %>%
    dplyr::arrange(dplyr::desc(dplyr::.data$missing_pct))
  
  # Duplicates
  n_duplicates <- sum(duplicated(data))
  
  # Report
  cat("\n╔════════════════════════════════════════════╗\n")
  cat("  Data Quality Report:", name, "\n")
  cat("╚════════════════════════════════════════════╝\n\n")
  cat("Dimensions:", n_rows, "rows ×", n_cols, "columns\n")
  cat("Duplicates:", n_duplicates, "\n")
  
  if (nrow(missing_summary) > 0) {
    cat("\nVariables with missing data:\n")
    print(missing_summary, n = 10)
  } else {
    cat("\nNo missing data detected\n")
  }
  
  cat("\n")
  
  invisible(list(
    n_rows = n_rows,
    n_cols = n_cols,
    n_duplicates = n_duplicates,
    missing_summary = missing_summary
  ))
}

message("✓ Helper functions loaded")

# ==============================================================================
# PANDOC SETUP (for reporting)
# ==============================================================================
if (requireNamespace("rmarkdown", quietly = TRUE)) {
  if (!rmarkdown::pandoc_available()) {
    message("\n⚠ Pandoc not found. Installing...")
    if (!requireNamespace("tinytex", quietly = TRUE)) install.packages("tinytex")
    # Pandoc comes with TinyTeX or can be installed separately
  } else {
    pandoc_version <- rmarkdown::pandoc_version()
    message("✓ Pandoc version: ", pandoc_version)
  }
}

# ==============================================================================
# SESSION INFORMATION
# ==============================================================================
message("\n📊 Session Information:")
message("  R version: ", R.version.string)
message("  Platform: ", R.version$platform)
message("  Running on: ", Sys.info()["nodename"])
message("  User: ", Sys.info()["user"])

# Save session info to file
session_file <- file.path(here(), "logs", "session_info.txt")
if (!dir.exists(dirname(session_file))) dir.create(dirname(session_file), recursive = TRUE)
sink(session_file)
cat("Session Information\n")
cat("===================\n\n")
cat("Date:", format(Sys.time()), "\n\n")
print(sessionInfo())
sink()

# ==============================================================================
# COMPLETION MESSAGE
# ==============================================================================
message("\n═══════════════════════════════════════════════════════════════")
message("  ✅ Environment setup complete!")
message("  Ready to begin analysis")
message("═══════════════════════════════════════════════════════════════\n")

# ==============================================================================
# CUSTOM PROJECT-SPECIFIC CODE
# ==============================================================================
# Add any project-specific initialization code here
# For example:
# - Load reference data
# - Set up database connections
# - Define custom functions specific to this project
# - Load cached intermediate results

# Example: Load country codes
# country_codes <- read.csv(here("04_documentation/042_references/country_codes.csv"))

# ==============================================================================
# NOTES
# ==============================================================================
# Best Practices:
# 1. Source this file at the start of EVERY script: source("profile_PROJECT.R")
# 2. Don't modify this file for quick tests - create separate test scripts
# 3. Update package list when you add new dependencies
# 4. Keep paths relative using here() package
# 5. Document any project-specific customizations
# 6. Version control this file with your project
# ==============================================================================
