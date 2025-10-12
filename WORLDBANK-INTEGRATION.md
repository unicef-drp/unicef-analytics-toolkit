# UNICEF Analytics Toolkit - Integration Plan

## Overview

This document outlines how elements from the World Bank's [EduAnalyticsToolkit](https://github.com/worldbank/EduAnalyticsToolkit) can be adapted and integrated into the UNICEF Analytics Toolkit to enhance data management, documentation, and quality assurance capabilities.

---

## About EduAnalyticsToolkit

**Developer**: World Bank Education Global Practice - EduAnalytics Team  
**Purpose**: Toolkit for data management, documentation, and analytics of learning assessments microdata  
**Language**: Primarily Stata  
**License**: Open source

### Key Features Identified

1. **Data Comparison** (`comparefiles`) - Compare datasets and identify differences
2. **Recursive Directory Creation** (`rmkdir`) - Safely create nested folder structures
3. **Metadata Management** (`savemetadata`) - Store and retrieve dataset metadata
4. **Enhanced Save Functions** (`edukit_save`) - Quality checks before saving data
5. **Weight Redistribution** (`nestweight`) - Handle missing nested observations
6. **Automated Documentation** - Generate dataset documentation from metadata
7. **File Structure Validation** - Ensure project folder compliance

---

## Proposed Integration for UNICEF Analytics Toolkit

### 1. **Data Comparison Utilities**

**World Bank Approach**: `edukit_comparefiles` - Stata command that compares two files, handles unsorted data, different observation counts, and generates markdown reports

**UNICEF Adaptation**:

```r
# R Implementation (add to profile_SIMPLE.R or create utility package)
compare_datasets <- function(data1, data2, id_vars = NULL, 
                             output_md = TRUE, output_path = NULL) {
  # Compare two datasets and generate report
  # - Handles different number of rows
  # - Identifies added/removed/changed observations
  # - Creates markdown report of differences
  
  library(dplyr)
  library(diffdf)
  
  # Implementation based on edukit approach
  # Returns list of differences + optional markdown report
}
```

```python
# Python Implementation
def compare_datasets(df1, df2, id_cols=None, output_md=True):
    """Compare two DataFrames and generate diff report"""
    import pandas as pd
    import datacompy
    
    # Similar functionality to edukit_comparefiles
    # Returns comparison object + markdown report
```

**Use Cases**:
- Compare MICS rounds to verify data consistency
- Validate data processing steps
- QA check before/after data transformations
- Cross-country data validation

---

### 2. **Recursive Directory Creation**

**World Bank Approach**: `edukit_rmkdir` - Creates folders and subfolders recursively

**UNICEF Adaptation**: Already implemented in `profile_SIMPLE.R`

```r
# Enhanced version with logging
create_project_structure <- function(project_root = here::here(), 
                                    log = TRUE) {
  directories <- c(
    "01_data_prep/011_raw_data",
    "01_data_prep/012_codes",
    "01_data_prep/013_processed_data",
    "01_data_prep/014_cache",
    "02_analysis/021_codes",
    "02_analysis/022_data",
    "02_analysis/023_temp",
    "03_outputs/031_reports",
    "03_outputs/032_figures",
    "03_outputs/033_tables",
    "03_outputs/034_data_exports",
    "04_documentation",
    "logs"
  )
  
  for (dir in directories) {
    full_path <- file.path(project_root, dir)
    if (!dir.exists(full_path)) {
      dir.create(full_path, recursive = TRUE, showWarnings = FALSE)
      if (log) message("✓ Created: ", dir)
    }
  }
  
  invisible(TRUE)
}
```

**Use Cases**:
- Standardize project structure across UNICEF repos
- Onboard new analysts with consistent folder layout
- Ensure compliance with UNICEF data governance

---

### 3. **Metadata Management System**

**World Bank Approach**: `edukit_save` and `edukit_savemetadata` - Store metadata as dataset characteristics

**UNICEF Adaptation**:

```r
# Enhanced save_data with metadata (add to profile_SIMPLE.R)
save_data_with_metadata <- function(data, name, 
                                    dir = paths$data_processed,
                                    metadata = list(),
                                    format = "csv",
                                    compress = TRUE,
                                    check_id = NULL) {
  
  # 1. Timestamp
  timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
  filename <- paste0(name, "_", timestamp, ".", format)
  filepath <- file.path(dir, filename)
  
  # 2. Compress data (remove duplicates, optimize types)
  if (compress) {
    data <- data %>% distinct()
    # Optimize data types
    data <- data %>% mutate(across(where(is.character), as.factor))
  }
  
  # 3. Check ID uniqueness (like Stata's isid)
  if (!is.null(check_id)) {
    if (any(duplicated(data[[check_id]]))) {
      stop("ID variable '", check_id, "' is not unique!")
    }
  }
  
  # 4. Store metadata
  metadata_enhanced <- c(
    metadata,
    list(
      saved_date = Sys.time(),
      saved_by = Sys.getenv("USER"),
      n_rows = nrow(data),
      n_cols = ncol(data),
      variables = names(data),
      r_version = R.version.string
    )
  )
  
  # 5. Save data
  if (format == "csv") {
    write.csv(data, filepath, row.names = FALSE)
  } else if (format == "rds") {
    # For RDS, can store metadata as attributes
    attr(data, "metadata") <- metadata_enhanced
    saveRDS(data, filepath)
  }
  
  # 6. Save metadata separately
  metadata_file <- file.path(dir, paste0(name, "_", timestamp, "_metadata.yml"))
  yaml::write_yaml(metadata_enhanced, metadata_file)
  
  message("✓ Saved data: ", filename)
  message("✓ Saved metadata: ", basename(metadata_file))
  
  invisible(list(data_path = filepath, metadata_path = metadata_file))
}
```

**Use Cases**:
- Track data provenance (who created, when, from what source)
- Document data transformations
- Enable reproducibility audits
- Generate automated dataset documentation

---

### 4. **Automated Documentation Generation**

**World Bank Approach**: `edukit_save_dyntext` - Template for generating dataset documentation

**UNICEF Adaptation**:

```r
# Create dataset documentation from metadata
generate_data_documentation <- function(data_path, 
                                       metadata_path = NULL,
                                       output_format = "md") {
  
  # Load data and metadata
  if (grepl("\\.rds$", data_path)) {
    data <- readRDS(data_path)
    metadata <- attr(data, "metadata")
  } else {
    data <- read.csv(data_path)
    if (is.null(metadata_path)) {
      metadata_path <- sub("\\.(csv|rds)$", "_metadata.yml", data_path)
    }
    metadata <- yaml::read_yaml(metadata_path)
  }
  
  # Generate documentation
  doc <- c(
    paste("# Dataset Documentation:", basename(data_path)),
    "",
    "## Metadata",
    paste("- **Created**: ", metadata$saved_date),
    paste("- **Created by**: ", metadata$saved_by),
    paste("- **Observations**: ", format(metadata$n_rows, big.mark = ",")),
    paste("- **Variables**: ", metadata$n_cols),
    paste("- **R Version**: ", metadata$r_version),
    "",
    "## Variables",
    ""
  )
  
  # Add variable summary
  var_summary <- data.frame(
    Variable = names(data),
    Type = sapply(data, class),
    Missing = sapply(data, function(x) sum(is.na(x))),
    Unique = sapply(data, function(x) length(unique(x)))
  )
  
  doc <- c(doc, knitr::kable(var_summary, format = "markdown"))
  
  # Save documentation
  doc_file <- sub("\\.(csv|rds)$", "_documentation.md", data_path)
  writeLines(doc, doc_file)
  
  message("✓ Generated documentation: ", basename(doc_file))
  invisible(doc_file)
}
```

---

### 5. **Quality Assurance Framework**

**World Bank Approach**: Multiple validation checks before saving data

**UNICEF Adaptation**:

```r
# Data quality checks (add to profile_SIMPLE.R)
check_data_quality_enhanced <- function(data, rules = list()) {
  
  results <- list()
  
  # 1. Basic checks
  results$completeness <- data.frame(
    variable = names(data),
    missing_count = sapply(data, function(x) sum(is.na(x))),
    missing_pct = sapply(data, function(x) round(100 * sum(is.na(x)) / length(x), 2))
  )
  
  # 2. Duplicate check
  results$duplicates <- sum(duplicated(data))
  
  # 3. Data type consistency
  results$type_issues <- data.frame(
    variable = names(data),
    class = sapply(data, class),
    unique_values = sapply(data, function(x) length(unique(x)))
  )
  
  # 4. Custom rules (e.g., age > 0, dates in valid range)
  if (length(rules) > 0) {
    results$custom_checks <- lapply(rules, function(rule) {
      eval(rule, envir = data)
    })
  }
  
  # 5. Summary report
  cat("\n╔═══════════════════════════════════════════╗\n")
  cat("║  DATA QUALITY REPORT                      ║\n")
  cat("╚═══════════════════════════════════════════╝\n\n")
  
  cat("Dimensions:", nrow(data), "rows ×", ncol(data), "columns\n\n")
  
  cat("Missing Data:\n")
  print(results$completeness[results$completeness$missing_count > 0, ])
  
  cat("\nDuplicates:", results$duplicates, "\n")
  
  if (results$duplicates > 0) {
    warning("⚠ Dataset contains ", results$duplicates, " duplicate rows!")
  }
  
  invisible(results)
}
```

---

### 6. **Project Structure Validation**

**World Bank Approach**: `edukit_dlwcheck` - Validates folder structures

**UNICEF Adaptation**:

```r
# Validate UNICEF project structure
validate_project_structure <- function(project_root = here::here(), 
                                      strict = FALSE) {
  
  # Required folders
  required <- c(
    "01_data_prep",
    "02_analysis",
    "03_outputs",
    "04_documentation"
  )
  
  # Recommended folders
  recommended <- c(
    "01_data_prep/011_raw_data",
    "01_data_prep/012_codes",
    "01_data_prep/013_processed_data",
    "02_analysis/021_codes",
    "03_outputs/031_reports",
    "03_outputs/032_figures",
    "logs"
  )
  
  # Required files
  required_files <- c(
    ".gitignore",
    "README.md"
  )
  
  # Recommended files
  recommended_files <- c(
    "profile_SIMPLE.R",
    "LICENSE",
    "CITATION.cff"
  )
  
  # Check required
  missing_required <- setdiff(required, list.dirs(project_root, full.names = FALSE, recursive = FALSE))
  missing_req_files <- setdiff(required_files, list.files(project_root))
  
  # Check recommended
  missing_recommended <- setdiff(recommended, list.dirs(project_root, full.names = TRUE, recursive = TRUE))
  missing_rec_files <- setdiff(recommended_files, list.files(project_root))
  
  # Report
  cat("\n╔═══════════════════════════════════════════╗\n")
  cat("║  PROJECT STRUCTURE VALIDATION             ║\n")
  cat("╚═══════════════════════════════════════════╝\n\n")
  
  if (length(missing_required) == 0 && length(missing_req_files) == 0) {
    cat("✅ All required structure elements present\n\n")
  } else {
    cat("❌ Missing required elements:\n")
    if (length(missing_required) > 0) {
      cat("  Folders:", paste(missing_required, collapse = ", "), "\n")
    }
    if (length(missing_req_files) > 0) {
      cat("  Files:", paste(missing_req_files, collapse = ", "), "\n")
    }
    cat("\n")
  }
  
  if (length(missing_recommended) > 0 || length(missing_rec_files) > 0) {
    cat("⚠ Missing recommended elements:\n")
    if (length(missing_recommended) > 0) {
      cat("  Folders:", paste(missing_recommended, collapse = ", "), "\n")
    }
    if (length(missing_rec_files) > 0) {
      cat("  Files:", paste(missing_rec_files, collapse = ", "), "\n")
    }
  }
  
  # Return validation status
  valid <- length(missing_required) == 0 && length(missing_req_files) == 0
  
  if (strict && !valid) {
    stop("Project structure validation failed!")
  }
  
  invisible(list(
    valid = valid,
    missing_required = c(missing_required, missing_req_files),
    missing_recommended = c(missing_recommended, missing_rec_files)
  ))
}
```

---

## Implementation Roadmap

### Phase 1: Core Utilities (Weeks 1-2)
- [x] Recursive directory creation (already in `profile_SIMPLE.R`)
- [ ] Enhanced `save_data_with_metadata()` function
- [ ] `compare_datasets()` for R and Python
- [ ] Basic quality checks enhancement

### Phase 2: Documentation System (Weeks 3-4)
- [ ] Automated dataset documentation generation
- [ ] Metadata template system
- [ ] Integration with existing PROFILE system

### Phase 3: Validation Framework (Weeks 5-6)
- [ ] Project structure validation
- [ ] Data quality rule engine
- [ ] Pre-commit hooks for quality checks

### Phase 4: Package Development (Weeks 7-8)
- [ ] Create `unicefanalytics` R package
- [ ] Create `unicef_analytics` Python package
- [ ] Comprehensive testing and documentation
- [ ] Integration with existing repos

---

## Key Differences: World Bank vs UNICEF Approach

| Aspect | World Bank EduKit | UNICEF Analytics |
|--------|------------------|------------------|
| **Language** | Stata-focused | Multi-language (R, Python, Stata) |
| **Scope** | Education assessments | Cross-sectoral (health, education, protection, etc.) |
| **Distribution** | Stata package | Environment setup + utility packages |
| **Platform** | Platform-agnostic Stata | Windows, macOS, Linux specific |
| **Focus** | Microdata analysis | Reproducible research + dashboards + reports |
| **Data Sources** | Learning assessments | APIs (World Bank, UNICEF, ILO) + surveys (MICS, DHS) |

---

## Recommended Actions

### Immediate (Next 2 Weeks)

1. **Enhance `profile_SIMPLE.R`** with:
   - `save_data_with_metadata()` function
   - Enhanced `check_data_quality()` with QA report
   - `validate_project_structure()` function

2. **Create utility modules**:
   - `R/unicef_data_utils.R` - Data management utilities
   - `R/unicef_qa_utils.R` - Quality assurance functions
   - `Python/unicef_utils/` - Python equivalents

3. **Documentation updates**:
   - Add "Data Quality Guidelines" to documentation
   - Create "Metadata Standards" guide
   - Update README with QA workflow examples

### Medium-term (Next 2 Months)

1. **Develop `unicefanalytics` package** (R):
   - Bundle all utility functions
   - Comprehensive testing
   - CRAN-ready documentation

2. **Develop `unicef_analytics` package** (Python):
   - pip-installable package
   - Same functionality as R version
   - Integration with pandas, numpy ecosystem

3. **Create training materials**:
   - Video tutorials on quality assurance
   - Example notebooks demonstrating utilities
   - Best practices guide

### Long-term (Next 6 Months)

1. **Integration with UNICEF data platforms**:
   - Direct API connections to UNICEF Data Warehouse
   - Automated metadata harvesting
   - Cross-platform validation

2. **Governance and compliance**:
   - Align with UNICEF Data Responsibility Framework
   - Privacy-by-design features
   - Audit trail capabilities

3. **Community building**:
   - Internal UNICEF community of practice
   - Collaboration with World Bank, WHO, other UN agencies
   - Contribution to open-source analytics ecosystem

---

## Resources

### Documentation to Create

1. **UNICEF Data Quality Framework** - Standards and practices
2. **Metadata Standards Guide** - Required and recommended metadata fields
3. **Project Structure Convention** - Standard folder layout
4. **Utility Functions Reference** - Complete API documentation

### Example Workflows to Develop

1. **MICS Data Processing** - End-to-end with quality checks
2. **Multi-Country Analysis** - Standardized comparison workflow
3. **Dashboard Development** - From raw data to interactive viz
4. **Report Automation** - Parameterized reporting with QA

---

## Contact and Contributions

**UNICEF Chief Statistician Office**  
Division of Data, Analytics, Planning and Monitoring (DAPM)

**For questions or contributions**:
- Email: [data@unicef.org](mailto:data@unicef.org)
- Internal: UNICEF Data & Analytics Community of Practice
- Repository: [github.com/unicef/analytics-toolkit](https://github.com/unicef/analytics-toolkit)

**Acknowledgments**:
- World Bank EduAnalytics Team for inspiration and best practices from [EduAnalyticsToolkit](https://github.com/worldbank/EduAnalyticsToolkit)
- UNICEF country offices and regional teams for feedback and requirements
- Open-source analytics community for tools and best practices

---

**Project**: UNICEF Analytics Toolkit  
**Last Updated**: 2025-10-10  
**Version**: 2.0  
**Status**: Active Development
