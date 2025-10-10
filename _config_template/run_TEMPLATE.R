# ==============================================================================
# UNICEF Analytics Project - Master Run Script
# ==============================================================================
# Filename: run_PROJECT-NAME.R
# Purpose: Execute complete analysis pipeline from start to finish
# Usage: Rscript run_PROJECT-NAME.R
#        Or source("run_PROJECT-NAME.R") in R console
# ==============================================================================

# Clear console
cat("\014")

# ==============================================================================
# SETUP ENVIRONMENT
# ==============================================================================
message("╔═══════════════════════════════════════════════════════════════╗")
message("║  UNICEF Analytics - Master Pipeline Execution                ║")
message("║  Project: [YOUR PROJECT NAME]                                ║")
message("╚═══════════════════════════════════════════════════════════════╝\n")

# Record start time
pipeline_start <- Sys.time()
message("Pipeline started: ", format(pipeline_start, "%Y-%m-%d %H:%M:%S"))

# Source profile to load environment
message("\n▶ Loading project environment...")
source("profile_PROJECT-NAME.R")  # Replace with your actual profile name

# ==============================================================================
# PIPELINE CONFIGURATION
# ==============================================================================
message("\n⚙️  Pipeline Configuration")

# Define pipeline stages
# Set to TRUE/FALSE to enable/disable specific stages
PIPELINE_CONFIG <- list(
  # Data acquisition
  download_data = TRUE,          # Download data from APIs/external sources
  import_raw_data = TRUE,         # Import raw data files
  
  # Data processing
  clean_data = TRUE,              # Data cleaning and validation
  process_data = TRUE,            # Data transformation and feature engineering
  merge_datasets = TRUE,          # Merge multiple data sources
  
  # Analysis
  descriptive_analysis = TRUE,    # Descriptive statistics
  statistical_analysis = TRUE,    # Statistical modeling
  create_indicators = TRUE,       # Calculate composite indicators
  
  # Outputs
  generate_figures = TRUE,        # Create visualizations
  generate_tables = TRUE,         # Create summary tables
  generate_reports = TRUE,        # Compile reports
  export_data = TRUE,             # Export processed data
  
  # Optional stages
  run_quality_checks = TRUE,      # Data quality validation
  create_archive = FALSE,         # Archive outputs (set TRUE for final run)
  send_notifications = FALSE      # Send email notifications (if configured)
)

# Execution options
STOP_ON_ERROR <- TRUE            # Stop pipeline if any stage fails
SAVE_INTERMEDIATE <- TRUE        # Save intermediate results
VERBOSE <- TRUE                  # Print detailed progress messages

# Display enabled stages
message("\nEnabled pipeline stages:")
enabled_stages <- names(PIPELINE_CONFIG)[sapply(PIPELINE_CONFIG, isTRUE)]
for (stage in enabled_stages) {
  message("  ✓ ", gsub("_", " ", stage))
}

# ==============================================================================
# HELPER FUNCTIONS
# ==============================================================================

# Function to execute a script stage
run_stage <- function(stage_name, script_path, description = "") {
  stage_label <- ifelse(description != "", description, stage_name)
  
  message("\n╔═══════════════════════════════════════════════════════════════╗")
  message("║  STAGE: ", toupper(stage_label))
  message("╚═══════════════════════════════════════════════════════════════╝")
  
  stage_start <- Sys.time()
  
  if (!file.exists(script_path)) {
    warning("⚠ Script not found: ", script_path)
    return(list(success = FALSE, duration = 0))
  }
  
  tryCatch({
    message("▶ Running: ", basename(script_path))
    source(script_path, local = new.env())
    stage_end <- Sys.time()
    duration <- difftime(stage_end, stage_start, units = "secs")
    
    message("✓ Stage completed successfully")
    message("  Duration: ", round(duration, 2), " seconds")
    
    log_message(paste("Completed stage:", stage_label, "in", round(duration, 2), "seconds"))
    
    return(list(success = TRUE, duration = as.numeric(duration)))
    
  }, error = function(e) {
    message("✗ ERROR in stage: ", stage_label)
    message("  Error message: ", e$message)
    
    log_message(paste("ERROR in stage:", stage_label, "-", e$message), level = "ERROR")
    
    if (STOP_ON_ERROR) {
      stop("Pipeline halted due to error in stage: ", stage_label)
    }
    
    return(list(success = FALSE, duration = 0, error = e$message))
  })
}

# Function to create execution log
create_execution_log <- function(results) {
  log_file <- file.path(paths$outputs, paste0("pipeline_log_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".txt"))
  
  sink(log_file)
  cat("═══════════════════════════════════════════════════════════════\n")
  cat("  UNICEF Analytics - Pipeline Execution Log\n")
  cat("═══════════════════════════════════════════════════════════════\n\n")
  cat("Project: [YOUR PROJECT NAME]\n")
  cat("Date: ", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n")
  cat("User: ", Sys.info()["user"], "\n")
  cat("R Version: ", R.version.string, "\n\n")
  
  cat("Pipeline Configuration:\n")
  cat("  Stop on error: ", STOP_ON_ERROR, "\n")
  cat("  Save intermediate: ", SAVE_INTERMEDIATE, "\n")
  cat("  Verbose output: ", VERBOSE, "\n\n")
  
  cat("Execution Results:\n")
  cat("─────────────────────────────────────────────────────────────\n")
  
  total_duration <- 0
  successful_stages <- 0
  
  for (stage in names(results)) {
    status <- ifelse(results[[stage]]$success, "✓ SUCCESS", "✗ FAILED")
    duration <- round(results[[stage]]$duration, 2)
    
    cat(sprintf("%-30s %10s %8.2f sec\n", stage, status, duration))
    
    if (results[[stage]]$success) {
      successful_stages <- successful_stages + 1
      total_duration <- total_duration + duration
    }
  }
  
  cat("─────────────────────────────────────────────────────────────\n")
  cat("\nSummary:\n")
  cat("  Total stages executed: ", length(results), "\n")
  cat("  Successful: ", successful_stages, "\n")
  cat("  Failed: ", length(results) - successful_stages, "\n")
  cat("  Total duration: ", round(total_duration / 60, 2), " minutes\n")
  
  cat("\n═══════════════════════════════════════════════════════════════\n")
  sink()
  
  message("\n✓ Execution log saved: ", log_file)
}

# ==============================================================================
# PIPELINE EXECUTION
# ==============================================================================

# Initialize results tracker
pipeline_results <- list()

message("\n\n╔═══════════════════════════════════════════════════════════════╗")
message("║  BEGINNING PIPELINE EXECUTION                                 ║")
message("╚═══════════════════════════════════════════════════════════════╝\n")

# ---------------------------------------------------------------------------
# STAGE 1: DATA ACQUISITION
# ---------------------------------------------------------------------------

if (PIPELINE_CONFIG$download_data) {
  pipeline_results$download_data <- run_stage(
    "download_data",
    here("01_data_prep", "012_codes", "01_download_data.R"),
    "Download Data from APIs"
  )
}

if (PIPELINE_CONFIG$import_raw_data) {
  pipeline_results$import_raw_data <- run_stage(
    "import_raw_data",
    here("01_data_prep", "012_codes", "02_import_raw_data.R"),
    "Import Raw Data Files"
  )
}

# ---------------------------------------------------------------------------
# STAGE 2: DATA PROCESSING
# ---------------------------------------------------------------------------

if (PIPELINE_CONFIG$clean_data) {
  pipeline_results$clean_data <- run_stage(
    "clean_data",
    here("01_data_prep", "012_codes", "03_clean_data.R"),
    "Data Cleaning and Validation"
  )
}

if (PIPELINE_CONFIG$process_data) {
  pipeline_results$process_data <- run_stage(
    "process_data",
    here("01_data_prep", "012_codes", "04_process_data.R"),
    "Data Processing and Transformation"
  )
}

if (PIPELINE_CONFIG$merge_datasets) {
  pipeline_results$merge_datasets <- run_stage(
    "merge_datasets",
    here("01_data_prep", "012_codes", "05_merge_data.R"),
    "Merge Multiple Datasets"
  )
}

# ---------------------------------------------------------------------------
# STAGE 3: ANALYSIS
# ---------------------------------------------------------------------------

if (PIPELINE_CONFIG$descriptive_analysis) {
  pipeline_results$descriptive_analysis <- run_stage(
    "descriptive_analysis",
    here("02_analysis", "021_codes", "01_descriptive_stats.R"),
    "Descriptive Statistics"
  )
}

if (PIPELINE_CONFIG$statistical_analysis) {
  pipeline_results$statistical_analysis <- run_stage(
    "statistical_analysis",
    here("02_analysis", "021_codes", "02_statistical_models.R"),
    "Statistical Analysis and Modeling"
  )
}

if (PIPELINE_CONFIG$create_indicators) {
  pipeline_results$create_indicators <- run_stage(
    "create_indicators",
    here("02_analysis", "021_codes", "03_composite_indicators.R"),
    "Calculate Composite Indicators"
  )
}

# ---------------------------------------------------------------------------
# STAGE 4: OUTPUTS
# ---------------------------------------------------------------------------

if (PIPELINE_CONFIG$generate_figures) {
  pipeline_results$generate_figures <- run_stage(
    "generate_figures",
    here("03_outputs", "01_create_figures.R"),
    "Generate Visualizations"
  )
}

if (PIPELINE_CONFIG$generate_tables) {
  pipeline_results$generate_tables <- run_stage(
    "generate_tables",
    here("03_outputs", "02_create_tables.R"),
    "Generate Summary Tables"
  )
}

if (PIPELINE_CONFIG$generate_reports) {
  pipeline_results$generate_reports <- run_stage(
    "generate_reports",
    here("03_outputs", "03_compile_report.Rmd"),
    "Compile Reports"
  )
}

if (PIPELINE_CONFIG$export_data) {
  pipeline_results$export_data <- run_stage(
    "export_data",
    here("03_outputs", "04_export_data.R"),
    "Export Processed Data"
  )
}

# ---------------------------------------------------------------------------
# STAGE 5: OPTIONAL STAGES
# ---------------------------------------------------------------------------

if (PIPELINE_CONFIG$run_quality_checks) {
  pipeline_results$quality_checks <- run_stage(
    "quality_checks",
    here("02_analysis", "021_codes", "99_quality_checks.R"),
    "Data Quality Validation"
  )
}

if (PIPELINE_CONFIG$create_archive) {
  # Create timestamped archive of outputs
  message("\n▶ Creating output archive...")
  archive_name <- paste0("outputs_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".zip")
  archive_path <- file.path(here(), "archives", archive_name)
  
  if (!dir.exists(dirname(archive_path))) dir.create(dirname(archive_path), recursive = TRUE)
  
  zip(archive_path, paths$outputs, flags = "-r9X")
  message("✓ Archive created: ", archive_path)
}

# ==============================================================================
# PIPELINE SUMMARY
# ==============================================================================

pipeline_end <- Sys.time()
total_duration <- difftime(pipeline_end, pipeline_start, units = "mins")

message("\n\n╔═══════════════════════════════════════════════════════════════╗")
message("║  PIPELINE EXECUTION COMPLETE                                  ║")
message("╚═══════════════════════════════════════════════════════════════╝\n")

# Calculate summary statistics
total_stages <- length(pipeline_results)
successful_stages <- sum(sapply(pipeline_results, function(x) x$success))
failed_stages <- total_stages - successful_stages

# Display summary
message("📊 Execution Summary:")
message("  Total stages executed: ", total_stages)
message("  ✓ Successful: ", successful_stages)
if (failed_stages > 0) {
  message("  ✗ Failed: ", failed_stages)
}
message("  Total duration: ", round(total_duration, 2), " minutes")
message("  Completed: ", format(pipeline_end, "%Y-%m-%d %H:%M:%S"))

# Create execution log
create_execution_log(pipeline_results)

# Final status
if (failed_stages == 0) {
  message("\n✅ All stages completed successfully!")
  log_message("Pipeline completed successfully", level = "SUCCESS")
} else {
  message("\n⚠ Pipeline completed with ", failed_stages, " failed stage(s)")
  message("  Check logs for details")
  log_message(paste("Pipeline completed with", failed_stages, "failures"), level = "WARNING")
}

# Optional: Send notification (if configured)
if (PIPELINE_CONFIG$send_notifications) {
  # Add your notification code here
  # Example: send email, Slack message, etc.
  message("\n📧 Sending notifications...")
}

# ==============================================================================
# CLEANUP
# ==============================================================================

# Clean up temporary files if configured
if (!SAVE_INTERMEDIATE && dir.exists(paths$analysis_temp)) {
  message("\n🧹 Cleaning up temporary files...")
  unlink(file.path(paths$analysis_temp, "*"), recursive = TRUE)
  message("✓ Temporary files removed")
}

# Save workspace (optional)
# save.image(file = file.path(here(), ".RData"))

message("\n═══════════════════════════════════════════════════════════════\n")

# ==============================================================================
# NOTES
# ==============================================================================
# Usage Examples:
#
# 1. Run full pipeline:
#    source("run_PROJECT-NAME.R")
#
# 2. Run from command line:
#    Rscript run_PROJECT-NAME.R
#
# 3. Run with custom configuration:
#    Modify PIPELINE_CONFIG before sourcing
#
# 4. Schedule automated runs:
#    Windows: Use Task Scheduler
#    macOS/Linux: Use cron
#
# Customization Tips:
# - Add/remove stages as needed for your project
# - Modify script paths to match your directory structure
# - Add project-specific validation steps
# - Configure notifications for automated runs
# - Add database connections if needed
# - Include data backup steps for important runs
# ==============================================================================
