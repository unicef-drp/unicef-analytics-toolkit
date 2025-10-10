# ==============================================================================
# UNICEF Analytics - Simple Profile (Universal)
# ==============================================================================
# Minimal environment setup that works across ALL projects
# Auto-detects workspace paths from VS Code
# ==============================================================================

# Suppress startup messages
options(warn = -1)

# ==============================================================================
# 1. LOAD ESSENTIAL PACKAGES
# ==============================================================================

# Auto-install missing packages
load_packages <- function(packages) {
  for (pkg in packages) {
    if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
      message("Installing missing package: ", pkg)
      install.packages(pkg, quiet = TRUE)
      library(pkg, character.only = TRUE, quietly = TRUE)
    }
  }
}

# Core packages (minimal set)
required_packages <- c(
  "here",        # Auto-detect project root
  "yaml",        # Read config files
  "tidyverse"    # Data manipulation
)

load_packages(required_packages)

# ==============================================================================
# 2. AUTO-DETECT PATHS
# ==============================================================================

# Project root (auto-detected)
project_root <- here::here()

# Workspace detection from VS Code (if available)
workspace_dir <- Sys.getenv("VSCODE_WORKSPACE_DIR")
if (workspace_dir == "") {
  workspace_dir <- project_root  # Fallback to project root
}

# Standard directory structure (auto-detect)
paths <- list(
  root = project_root,
  data_raw = here::here("01_data_prep", "011_raw_data"),
  data_processed = here::here("01_data_prep", "013_processed_data"),
  analysis = here::here("02_analysis"),
  outputs = here::here("03_outputs"),
  docs = here::here("04_documentation")
)

# Create directories if they don't exist
for (path_name in names(paths)) {
  if (!dir.exists(paths[[path_name]]) && path_name != "root") {
    dir.create(paths[[path_name]], recursive = TRUE, showWarnings = FALSE)
  }
}

# ==============================================================================
# 3. LOAD USER CONFIG (if exists)
# ==============================================================================

# Try multiple locations
config_locations <- c(
  file.path(Sys.getenv("HOME"), ".config", "unicef_analytics", "user_config.yml"),
  file.path(Sys.getenv("USERPROFILE"), ".config", "unicef_analytics", "user_config.yml"),
  here::here("user_config.yml")
)

user_config <- NULL
for (config_path in config_locations) {
  if (file.exists(config_path)) {
    user_config <- yaml::read_yaml(config_path)
    message("✓ Loaded user config from: ", config_path)
    break
  }
}

if (is.null(user_config)) {
  message("ℹ No user config found - using defaults")
  user_config <- list(
    paths = list(
      github_dir = dirname(project_root),
      data_dir = here::here("data")
    ),
    preferences = list(
      default_cores = 2,
      figure_format = "png"
    )
  )
}

# ==============================================================================
# 4. LOAD PROJECT CONFIG (optional)
# ==============================================================================

project_config <- NULL
if (file.exists(here::here("project_config.yml"))) {
  project_config <- yaml::read_yaml(here::here("project_config.yml"))
  message("✓ Loaded project config")
}

# ==============================================================================
# 5. LOAD ENVIRONMENT VARIABLES (if .env exists)
# ==============================================================================

if (file.exists(here::here(".env"))) {
  # Simple .env loader
  env_lines <- readLines(here::here(".env"))
  env_lines <- env_lines[!grepl("^\\s*#", env_lines)]  # Remove comments
  env_lines <- env_lines[nzchar(trimws(env_lines))]    # Remove empty lines
  
  for (line in env_lines) {
    parts <- strsplit(line, "=", fixed = TRUE)[[1]]
    if (length(parts) == 2) {
      Sys.setenv(setNames(trimws(parts[2]), trimws(parts[1])))
    }
  }
  message("✓ Loaded environment variables from .env")
}

# ==============================================================================
# 6. HELPER FUNCTIONS
# ==============================================================================

# Save data with automatic timestamping
save_data <- function(data, name, dir = paths$data_processed, format = "csv") {
  timestamp <- format(Sys.time(), "%Y%m%d")
  filename <- paste0(name, "_", timestamp, ".", format)
  filepath <- file.path(dir, filename)
  
  if (format == "csv") {
    write.csv(data, filepath, row.names = FALSE)
  } else if (format == "rds") {
    saveRDS(data, filepath)
  }
  
  message("✓ Saved: ", filename)
  invisible(filepath)
}

# Load most recent file matching pattern
load_latest_data <- function(pattern, dir = paths$data_processed) {
  files <- list.files(dir, pattern = pattern, full.names = TRUE)
  if (length(files) == 0) stop("No files matching pattern: ", pattern)
  
  latest <- files[which.max(file.mtime(files))]
  message("ℹ Loading: ", basename(latest))
  
  if (grepl("\\.rds$", latest)) {
    readRDS(latest)
  } else if (grepl("\\.csv$", latest)) {
    read.csv(latest)
  }
}

# Simple logging
log_message <- function(msg, level = "INFO") {
  timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  log_line <- paste0("[", timestamp, "] [", level, "] ", msg)
  message(log_line)
  
  # Append to log file if logs directory exists
  log_dir <- here::here("logs")
  if (dir.exists(log_dir)) {
    log_file <- file.path(log_dir, paste0("log_", Sys.Date(), ".txt"))
    cat(log_line, "\n", file = log_file, append = TRUE)
  }
}

# ==============================================================================
# 7. GLOBAL OPTIONS
# ==============================================================================

# General R options
options(
  scipen = 999,                    # Avoid scientific notation
  digits = 3,                      # Default decimal places
  stringsAsFactors = FALSE         # Don't auto-convert strings to factors
)

# ggplot2 theme (if tidyverse loaded)
if ("ggplot2" %in% loadedNamespaces()) {
  theme_set(theme_minimal())
}

# Parallel processing
if (!is.null(user_config$preferences$default_cores)) {
  options(mc.cores = user_config$preferences$default_cores)
}

# ==============================================================================
# 8. SESSION INFO
# ==============================================================================

message("═══════════════════════════════════════════════════════════")
message("  UNICEF Analytics Environment Ready")
message("═══════════════════════════════════════════════════════════")
message("Project: ", basename(project_root))
message("Root:    ", project_root)
message("R:       ", R.version.string)
message("───────────────────────────────────────────────────────────")

# Show available paths
message("Available paths:")
for (name in names(paths)) {
  message("  paths$", name)
}
message("═══════════════════════════════════════════════════════════\n")

# Clean up
options(warn = 0)

# ==============================================================================
# USAGE EXAMPLES
# ==============================================================================
# 
# # Start working
# source("profile_SIMPLE.R")
# 
# # Use auto-detected paths
# data <- read.csv(file.path(paths$data_raw, "mydata.csv"))
# 
# # Save with timestamp
# save_data(processed_data, "cleaned_data")
# 
# # Load most recent
# data <- load_latest_data("cleaned_data_.*\\.csv")
# 
# # Log messages
# log_message("Analysis started")
#
# ==============================================================================
