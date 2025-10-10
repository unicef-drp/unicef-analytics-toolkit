# PROFILE and RUN Files Guide

## Overview

This guide explains the purpose, structure, and usage of **PROFILE** and **RUN** files in UNICEF analytics projects. These files are core components of a reproducible, collaborative analytical workflow.

---

## Table of Contents

- [What are PROFILE and RUN files?](#what-are-profile-and-run-files)
- [PROFILE File](#profile-file)
- [RUN File](#run-file)
- [How They Work Together](#how-they-work-together)
- [Setup Instructions](#setup-instructions)
- [Team Collaboration](#team-collaboration)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)
- [Examples](#examples)

---

## What are PROFILE and RUN files?

### PROFILE File (`profile_PROJECT-NAME.R`)

**Purpose**: Sets up the complete R environment for your project

**Key Functions**:
- Load required R packages
- Read configuration files (YAML, `.env`)
- Set up project paths and directory structure
- Define global options (plot themes, UNICEF colors)
- Create helper functions for common tasks
- Initialize logging

**When to use**:
- At the beginning of every analysis session
- Before running any project scripts
- When starting interactive R sessions

**Analogy**: Think of the PROFILE as your project's "startup sequence" - it prepares everything you need before any analysis begins.

---

### RUN File (`run_PROJECT-NAME.R`)

**Purpose**: Executes the complete analytical pipeline from start to finish

**Key Functions**:
- Source the PROFILE to set up environment
- Execute analysis scripts in correct order
- Manage workflow stages (data download → processing → analysis → outputs)
- Handle errors and logging
- Create execution reports
- Archive outputs

**When to use**:
- To run the complete analysis pipeline
- For automated/scheduled analysis runs
- Before delivering final outputs
- To ensure reproducibility

**Analogy**: Think of the RUN file as your project's "master conductor" - it orchestrates all analysis steps in the right sequence.

---

## PROFILE File

### Structure

```r
# ==============================================================================
# SECTION 1: ENVIRONMENT SETUP
# ==============================================================================
# - Load required packages
# - Set working directory
# - Configure R options

# ==============================================================================
# SECTION 2: CONFIGURATION LOADING
# ==============================================================================
# - Load project_config.yml (version controlled)
# - Load user_config.yml (personal paths)
# - Load .env file (credentials)

# ==============================================================================
# SECTION 3: PATH SETUP
# ==============================================================================
# - Define project directory structure
# - Create paths list for easy access

# ==============================================================================
# SECTION 4: GLOBAL OPTIONS
# ==============================================================================
# - ggplot2 theme
# - UNICEF colors
# - Scientific notation settings
# - Default figure dimensions

# ==============================================================================
# SECTION 5: HELPER FUNCTIONS
# ==============================================================================
# - save_data() - Save with date stamping
# - load_latest_data() - Load most recent file
# - log_message() - Structured logging
# - check_data_quality() - Validation checks
```

### Key Features

#### 1. Package Management

```r
# Define required packages
required_packages <- c(
  "tidyverse",   # Data manipulation
  "here",        # Path management
  "yaml",        # Config file reading
  "logger"       # Logging
)

# Function to load packages (installs if missing)
load_packages <- function(packages) {
  for (pkg in packages) {
    if (!require(pkg, character.only = TRUE)) {
      install.packages(pkg)
      library(pkg, character.only = TRUE)
    }
  }
}

load_packages(required_packages)
```

#### 2. Configuration Loading

```r
# Load configurations
project_config <- yaml::read_yaml("project_config.yml")
user_config <- yaml::read_yaml("user_config.yml")

# Load environment variables
if (file.exists(".env")) {
  dotenv::load_dot_env()
}
```

#### 3. Path Setup

```r
# Define project paths
paths <- list(
  root = here::here(),
  data_raw = here::here("01_data_prep", "011_raw_data"),
  data_processed = here::here("01_data_prep", "013_processed_data"),
  analysis = here::here("02_analysis", "021_codes"),
  outputs = here::here("03_outputs")
)
```

#### 4. Helper Functions

```r
# Save data with timestamp
save_data <- function(data, name, type = "csv") {
  timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
  filename <- paste0(name, "_", timestamp, ".", type)
  filepath <- file.path(paths$data_processed, filename)
  
  write.csv(data, filepath, row.names = FALSE)
  message("✓ Saved: ", filename)
  
  invisible(filepath)
}
```

### Customization

**For Your Project**:
1. Rename to `profile_YOUR-PROJECT-NAME.R`
2. Update required packages list
3. Add project-specific helper functions
4. Customize global options
5. Add any project-specific initializations

---

## RUN File

### Structure

```r
# ==============================================================================
# SECTION 1: SETUP ENVIRONMENT
# ==============================================================================
# - Source PROFILE file
# - Record start time
# - Display banner

# ==============================================================================
# SECTION 2: PIPELINE CONFIGURATION
# ==============================================================================
# - Define which stages to run (TRUE/FALSE flags)
# - Set execution options

# ==============================================================================
# SECTION 3: HELPER FUNCTIONS
# ==============================================================================
# - run_stage() - Execute a script with error handling
# - create_execution_log() - Generate execution report

# ==============================================================================
# SECTION 4: PIPELINE EXECUTION
# ==============================================================================
# - Stage 1: Data Acquisition
# - Stage 2: Data Processing
# - Stage 3: Analysis
# - Stage 4: Outputs
# - Stage 5: Optional (QA, archiving)

# ==============================================================================
# SECTION 5: SUMMARY AND CLEANUP
# ==============================================================================
# - Display execution summary
# - Create execution log
# - Send notifications (optional)
# - Clean temporary files
```

### Key Features

#### 1. Pipeline Configuration

```r
PIPELINE_CONFIG <- list(
  download_data = TRUE,
  clean_data = TRUE,
  statistical_analysis = TRUE,
  generate_figures = TRUE,
  create_archive = FALSE  # Set TRUE for final runs
)
```

**Benefits**:
- Easy to enable/disable specific stages
- Quick iteration during development
- Selective re-runs after fixing issues

#### 2. Stage Execution with Error Handling

```r
run_stage <- function(stage_name, script_path, description = "") {
  tryCatch({
    source(script_path, local = new.env())
    # Success handling
  }, error = function(e) {
    # Error handling and logging
    if (STOP_ON_ERROR) stop("Pipeline halted")
  })
}
```

**Benefits**:
- Consistent error handling across all stages
- Detailed logging of execution
- Option to continue or stop on errors

#### 3. Execution Logging

```r
create_execution_log <- function(results) {
  # Creates detailed log file with:
  # - Timestamp
  # - Success/failure for each stage
  # - Duration of each stage
  # - Total execution time
  # - Summary statistics
}
```

**Benefits**:
- Audit trail for all runs
- Performance monitoring
- Debugging aid

### Customization

**For Your Project**:
1. Rename to `run_YOUR-PROJECT-NAME.R`
2. Update script paths to match your directory structure
3. Add/remove pipeline stages as needed
4. Customize execution options
5. Add project-specific validation steps

---

## How They Work Together

### Workflow Sequence

```
┌─────────────────────────────────────────────────────────┐
│  START: User runs RUN file                              │
│  > source("run_PROJECT-NAME.R")                         │
└────────────────┬────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────┐
│  STEP 1: RUN file sources PROFILE file                  │
│  > source("profile_PROJECT-NAME.R")                     │
└────────────────┬────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────┐
│  STEP 2: PROFILE sets up environment                    │
│  - Loads packages                                       │
│  - Reads configurations                                 │
│  - Defines paths                                        │
│  - Creates helper functions                             │
└────────────────┬────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────┐
│  STEP 3: RUN executes pipeline stages                   │
│  - Stage 1: Download data                               │
│  - Stage 2: Clean data                                  │
│  - Stage 3: Analyze data                                │
│  - Stage 4: Create outputs                              │
└────────────────┬────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────┐
│  STEP 4: Generate reports and logs                      │
│  - Execution log                                        │
│  - Summary statistics                                   │
│  - Error reports (if any)                               │
└────────────────┬────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────┐
│  END: Analysis complete                                 │
│  Results saved in 03_outputs/                           │
└─────────────────────────────────────────────────────────┘
```

### Interactive vs Automated Usage

**Interactive Development** (using PROFILE only):
```r
# 1. Start R/RStudio
source("profile_PROJECT-NAME.R")

# 2. Work interactively
data <- read.csv(file.path(paths$data_raw, "mydata.csv"))
summary(data)

# 3. Use helper functions
save_data(processed_data, "cleaned_data")
```

**Automated Production** (using RUN):
```r
# Run complete pipeline
source("run_PROJECT-NAME.R")

# Or from command line:
# Rscript run_PROJECT-NAME.R
```

---

## Setup Instructions

### 1. Initial Setup

```bash
# Navigate to your project
cd path/to/your/project

# Copy templates
cp path/to/templates/profile_TEMPLATE.R profile_MYPROJECT.R
cp path/to/templates/run_TEMPLATE.R run_MYPROJECT.R

# Copy configuration files
cp path/to/templates/project_config.yml .
cp path/to/templates/user_config.yml .
```

### 2. Customize PROFILE

```r
# Edit profile_MYPROJECT.R

# 1. Update project name
PROJECT_NAME <- "MYPROJECT"

# 2. Add required packages
required_packages <- c(
  "tidyverse",
  "your-specific-package"
)

# 3. Add custom helper functions
my_custom_function <- function() {
  # Your code
}
```

### 3. Customize RUN

```r
# Edit run_MYPROJECT.R

# 1. Update PROFILE source path
source("profile_MYPROJECT.R")

# 2. Configure pipeline stages
PIPELINE_CONFIG <- list(
  download_data = TRUE,
  your_custom_stage = TRUE
)

# 3. Add stage execution
if (PIPELINE_CONFIG$your_custom_stage) {
  run_stage("your_custom_stage", 
            here("02_analysis", "your_script.R"))
}
```

### 4. Test Setup

```r
# Test PROFILE
source("profile_MYPROJECT.R")
# Should load without errors

# Test RUN
source("run_MYPROJECT.R")
# Should execute all enabled stages
```

---

## Team Collaboration

### Version Control Strategy

**COMMIT** (version controlled):
- `profile_PROJECT-NAME.R` - Core environment setup
- `run_PROJECT-NAME.R` - Pipeline orchestration
- `project_config.yml` - Shared project settings

**DO NOT COMMIT** (add to .gitignore):
- `user_config.yml` - Personal paths
- `.env` - Credentials
- `.Rhistory`, `.RData`

### Team Workflow

#### Setup for New Team Member

```r
# 1. Clone repository
git clone https://github.com/your-org/your-project.git

# 2. Copy user config template
cp user_config_TEMPLATE.yml user_config.yml

# 3. Edit user_config.yml with personal paths
# github_dir: "C:/Users/YourName/GitHub"
# teams_dir: "C:/Users/YourName/OneDrive/Teams"

# 4. Create .env file (if needed)
echo "API_KEY=your_key_here" > .env

# 5. Run setup
source("profile_PROJECT-NAME.R")  # Test environment
source("run_PROJECT-NAME.R")       # Run pipeline
```

#### Updating Shared Configuration

```r
# When updating project_config.yml:

# 1. Make changes
# 2. Test locally
source("run_PROJECT-NAME.R")

# 3. Commit changes
git add project_config.yml
git commit -m "Updated data sources configuration"
git push

# 4. Team members pull changes
git pull

# 5. Team re-runs pipeline
source("run_PROJECT-NAME.R")
```

### Communication Protocols

**When to update PROFILE**:
- Adding new required packages
- New helper functions that all team members need
- Changes to path structure
- Updates to global options

**When to update RUN**:
- Adding new pipeline stages
- Changing execution order
- Updates to error handling
- New validation checks

**Communicate changes**:
- Create pull request
- Document changes in commit message
- Update project documentation
- Notify team (Slack, email)

---

## Best Practices

### PROFILE File Best Practices

1. **Keep it Minimal**
   - Only load packages actually needed
   - Avoid computationally expensive operations
   - Profile should run in seconds

2. **Document Everything**
   - Explain why each package is needed
   - Document helper function usage
   - Include examples in comments

3. **Make it Portable**
   - Use `here()` for all paths
   - Avoid hard-coded absolute paths
   - Use configuration files for varying settings

4. **Version Dependencies**
   - Document minimum required package versions
   - Test with different R versions
   - Use `renv` for package management

5. **Provide Feedback**
   - Use `message()` to show progress
   - Indicate successful loading
   - Warn about missing optional components

### RUN File Best Practices

1. **Modular Design**
   - Each stage should be independent
   - Use functions for repeated operations
   - Keep stage scripts focused

2. **Robust Error Handling**
   - Validate inputs before each stage
   - Provide informative error messages
   - Log all errors with context

3. **Progress Tracking**
   - Show current stage
   - Display time remaining estimates
   - Create detailed execution logs

4. **Testing Strategy**
   - Test each stage independently first
   - Run full pipeline in development
   - Validate outputs before archiving

5. **Documentation**
   - Document expected runtime
   - List stage dependencies
   - Explain when to run which stages

### General Best Practices

1. **Naming Conventions**
   ```r
   # Good
   profile_SDG-REPORT-2025.R
   run_SDG-REPORT-2025.R
   
   # Avoid
   profile.R
   run.R
   my_script.R
   ```

2. **Configuration Management**
   ```r
   # Good: Use configuration files
   config <- yaml::read_yaml("project_config.yml")
   threshold <- config$parameters$outlier_threshold
   
   # Avoid: Hard-coded values
   threshold <- 3  # What is this? Where did it come from?
   ```

3. **Path Management**
   ```r
   # Good: Use here() and path functions
   data_file <- here("01_data_prep", "011_raw_data", "data.csv")
   
   # Avoid: Hard-coded paths
   data_file <- "C:/Users/John/Projects/data.csv"
   ```

4. **Logging**
   ```r
   # Good: Structured logging
   log_message("Processing started", level = "INFO")
   log_message("Error in stage 3", level = "ERROR")
   
   # Avoid: print() or cat() for important messages
   print("something happened")
   ```

---

## Troubleshooting

### Common Issues

#### Issue 1: PROFILE won't load

**Symptom**: Error when sourcing PROFILE file

**Possible Causes**:
- Missing packages
- Configuration file not found
- Path issues

**Solution**:
```r
# Check package installation
required_packages <- c("tidyverse", "here", "yaml")
missing <- required_packages[!sapply(required_packages, requireNamespace, quietly = TRUE)]
if (length(missing) > 0) {
  install.packages(missing)
}

# Check configuration files
file.exists("project_config.yml")  # Should be TRUE
file.exists("user_config.yml")      # Should be TRUE

# Check working directory
getwd()  # Should be project root
```

#### Issue 2: RUN file fails mid-pipeline

**Symptom**: Pipeline stops at specific stage

**Debugging Steps**:
```r
# 1. Source PROFILE manually
source("profile_PROJECT-NAME.R")

# 2. Run failed stage directly
source(here("02_analysis", "021_codes", "problematic_script.R"))

# 3. Check inputs
list.files(paths$data_processed)

# 4. Validate data
check_data_quality(your_data)

# 5. Review logs
readLines("logs/latest.log")
```

#### Issue 3: Different results on different machines

**Possible Causes**:
- Different package versions
- Different random seeds
- Path differences
- Data version differences

**Solution**:
```r
# 1. Use renv for package management
renv::init()
renv::snapshot()

# 2. Set seeds explicitly
set.seed(12345)

# 3. Use configuration files
# Don't hard-code paths

# 4. Version your data
save_data(data, name = "cleaned_v1")
```

#### Issue 4: Slow execution

**Profiling**:
```r
# Time each stage
system.time(source(here("02_analysis", "slow_script.R")))

# Profile code
Rprof("profile.out")
source(here("02_analysis", "slow_script.R"))
Rprof(NULL)
summaryRprof("profile.out")
```

**Optimization**:
- Use `data.table` instead of `dplyr` for large data
- Parallelize independent stages
- Cache intermediate results
- Optimize data reading (use `.parquet` instead of `.csv`)

---

## Examples

### Example 1: Simple Education Analysis Project

**Profile** (`profile_EDU-ANALYSIS.R`):
```r
# Load packages
library(tidyverse)
library(here)
library(yaml)

# Load configuration
config <- yaml::read_yaml("project_config.yml")

# Setup paths
paths <- list(
  data = here("data"),
  output = here("outputs")
)

# Helper function
calculate_learning_poverty <- function(data) {
  data %>%
    mutate(learning_poor = (reading_score < 400) | (is_out_of_school == 1))
}

message("✓ Education analysis environment ready")
```

**Run** (`run_EDU-ANALYSIS.R`):
```r
# Setup
source("profile_EDU-ANALYSIS.R")

# Download data
source(here("scripts", "01_download_mics.R"))

# Calculate indicators
source(here("scripts", "02_calculate_lp.R"))

# Create figures
source(here("scripts", "03_visualize.R"))

message("✓ Analysis complete!")
```

### Example 2: Multi-Country Health Dashboard

**Profile** (`profile_HEALTH-DASHBOARD.R`):
```r
# Load packages
required_packages <- c(
  "tidyverse", "here", "yaml",
  "plotly", "flexdashboard", "DT"
)
lapply(required_packages, library, character.only = TRUE)

# Configuration
config <- yaml::read_yaml("project_config.yml")
countries <- config$geography$countries

# Helper: Fetch health data
fetch_health_data <- function(country, indicator) {
  # API call logic here
}

# UNICEF health colors
health_colors <- list(
  good = "#80BD41",
  warning = "#FFC20E",
  critical = "#E2231B"
)
```

**Run** (`run_HEALTH-DASHBOARD.R`):
```r
source("profile_HEALTH-DASHBOARD.R")

message("Processing ", length(countries), " countries...")

for (country in countries) {
  message("▶ ", country)
  
  # Fetch data
  data <- fetch_health_data(country, "immunization")
  
  # Process
  source(here("scripts", "process_country_data.R"))
  
  # Update dashboard
  source(here("scripts", "update_dashboard.R"))
}

# Render final dashboard
rmarkdown::render("dashboard.Rmd")
message("✓ Dashboard available at: outputs/dashboard.html")
```

### Example 3: Automated SDG Reporting

**Profile** (`profile_SDG-REPORT-2025.R`):
```r
# Full environment setup
library(tidyverse)
library(here)
library(yaml)
library(COINr)
library(countrycode)

# Load configurations
config <- yaml::read_yaml("project_config.yml")
user_config <- yaml::read_yaml("user_config.yml")

# Setup all paths
paths <- list(
  data_raw = here("01_data_prep", "011_raw_data"),
  data_proc = here("01_data_prep", "013_processed_data"),
  outputs = here("03_outputs")
)

# Multiple helper functions
save_data <- function(...) { }
fetch_wb_data <- function(...) { }
calculate_composite <- function(...) { }

# Initialize logging
log_file <- file.path(paths$outputs, paste0("log_", Sys.Date(), ".txt"))
```

**Run** (`run_SDG-REPORT-2025.R`):
```r
source("profile_SDG-REPORT-2025.R")

# Configure pipeline
PIPELINE_CONFIG <- list(
  download_wb_data = TRUE,
  download_unicef_data = TRUE,
  clean_data = TRUE,
  calculate_indicators = TRUE,
  create_composite_index = TRUE,
  generate_country_profiles = TRUE,
  generate_regional_summaries = TRUE,
  compile_final_report = TRUE
)

# Execute pipeline with full error handling
# (Full implementation as in template)

# Create archive for publication
if (all_stages_successful) {
  archive_name <- paste0("SDG_Report_2025_", Sys.Date(), ".zip")
  zip(archive_name, paths$outputs)
  message("✓ Report archived: ", archive_name)
}
```

---

## Additional Resources

### Related Documentation
- [Configuration Guide](CONFIG-GUIDE.md) - YAML configuration setup
- [.gitignore Guide](GITIGNORE-GUIDE.md) - Version control patterns
- [Project Structure](PROJECT-STRUCTURE.md) - Directory organization

### Templates
- `profile_TEMPLATE.R` - PROFILE file template
- `run_TEMPLATE.R` - RUN file template
- `project_config.yml` - Configuration template

### Tools
- [`renv`](https://rstudio.github.io/renv/) - R package management
- [`here`](https://here.r-lib.org/) - Path management
- [`yaml`](https://cran.r-project.org/package=yaml) - Configuration files
- [`logger`](https://daroczig.github.io/logger/) - Structured logging

---

## Questions?

For questions or issues:
1. Check troubleshooting section above
2. Review example implementations
3. Consult team lead or senior analyst
4. Open issue in project repository

---

**Last Updated**: 2025-01-09  
**Version**: 1.0  
**Maintainer**: UNICEF Analytics Team
