# Configuration Templates - Quick Reference

## Overview

This directory contains comprehensive configuration templates for UNICEF analytics projects. These templates establish best practices for reproducible research, team collaboration, and data protection.

---

## Available Templates

### 1. Configuration Files

| File | Purpose | Version Control |
|------|---------|-----------------|
| `project_config.yml` | Project-wide settings shared across team | ✅ Commit to Git |
| `user_config.yml` | Template for personal paths | ✅ Commit to Git |
| `.env.example` | Template for environment variables | ✅ Commit to Git |

**Note**: After copying templates, `user_config.yml` and `.env` should be added to `.gitignore` (personal files).

### 2. Project Scripts

| File | Purpose | When to Use |
|------|---------|-------------|
| `profile_TEMPLATE.R` | Environment setup script | Source at start of every session |
| `run_TEMPLATE.R` | Master pipeline executor | Run complete analysis pipeline |

### 3. Version Control

| File | Purpose | Description |
|------|---------|-------------|
| `.gitignore` | Files to exclude from Git | Protects sensitive data, keeps repo clean |

### 4. Documentation

| File | Purpose |
|------|---------|
| `CONFIG-GUIDE.md` | Complete configuration system guide (530+ lines) |
| `PROFILE-RUN-GUIDE.md` | How to use PROFILE and RUN files (900+ lines) |
| `GITIGNORE-GUIDE.md` | Version control best practices (800+ lines) |
| `README.md` | This file - quick reference |

---

## Quick Start

### New Project Setup (5 Minutes)

```powershell
# 1. Navigate to your new project
cd C:\path\to\your\new\project

# 2. Copy templates
$TEMPLATE_DIR = "C:\GitHub\mytasks\unicef-analytics-setup\_config_template"

Copy-Item "$TEMPLATE_DIR\project_config.yml" .
Copy-Item "$TEMPLATE_DIR\user_config.yml" .
Copy-Item "$TEMPLATE_DIR\profile_TEMPLATE.R" "profile_MYPROJECT.R"
Copy-Item "$TEMPLATE_DIR\run_TEMPLATE.R" "run_MYPROJECT.R"
Copy-Item "$TEMPLATE_DIR\.gitignore" .

# 3. Edit configurations
notepad project_config.yml  # Update project settings
notepad user_config.yml     # Add your personal paths

# 4. Test setup
Rscript -e "source('profile_MYPROJECT.R')"
```

---

## Platform-Specific Paths

### Windows Example (`user_config.yml`)

```yaml
paths:
  github_dir: "C:/GitHub"
  teams_dir: "C:/Users/username/OneDrive - UNICEF/Teams"
  data_dir: "Z:/SharedData"  # Network drive
  output_dir: "C:/Users/username/Documents/Outputs"
```

### macOS Example

```yaml
paths:
  github_dir: "/Users/username/GitHub"
  teams_dir: "/Users/username/Library/CloudStorage/Teams"
  data_dir: "/Volumes/SharedData"
  output_dir: "/Users/username/Documents/Outputs"
```

### Linux Example

```yaml
paths:
  github_dir: "/home/username/GitHub"
  teams_dir: "/home/username/Teams"
  data_dir: "/mnt/shared_data"
  output_dir: "/home/username/outputs"
```

---

## Usage Patterns

### Pattern 1: Interactive Development

```r
# Load environment
source("profile_MYPROJECT.R")

# Work interactively
data <- read.csv(file.path(paths$data_raw, "data.csv"))
summary(data)

# Use helper functions
save_data(cleaned_data, "processed_data")
```

### Pattern 2: Automated Pipeline

```r
# Execute full pipeline
source("run_MYPROJECT.R")

# Or from command line
# Rscript run_MYPROJECT.R
```

---

## What Goes Where?

### Commit to Git (Version Controlled)

- `project_config.yml` - Shared project settings
- `profile_MYPROJECT.R` - Environment setup code
- `run_MYPROJECT.R` - Pipeline orchestration
- `.gitignore` - Files to ignore
- All `.R`, `.py`, `.do` scripts
- Documentation (`.md` files)

### Do NOT Commit (Add to .gitignore)

- `user_config.yml` - Personal paths
- `.env` - Credentials and API keys
- `.Rhistory`, `.RData` - R session files
- Data files (`.csv`, `.dta`, `.xlsx`)
- Large outputs (`.pdf`, `.png` generated files)

---

## Detailed Guides

### For Configuration Setup
**Read**: `CONFIG-GUIDE.md` (530+ lines)
- How to structure configurations
- Loading configs in R and Python
- Best practices and validation
- Troubleshooting

### For PROFILE and RUN Files
**Read**: `PROFILE-RUN-GUIDE.md` (900+ lines)
- What are PROFILE and RUN files?
- How they work together
- Team collaboration workflows
- Multiple examples

### For Version Control
**Read**: `GITIGNORE-GUIDE.md` (800+ lines)
- What to ignore and what to track
- Data protection guidelines
- Handling sensitive files
- Common patterns

---

## Customization Checklist

When starting a new project:

### project_config.yml
- [ ] Update project name and description
- [ ] Set geographic scope (countries, regions)
- [ ] Define indicators and data sources
- [ ] Configure output preferences

### profile_MYPROJECT.R
- [ ] Rename file to match your project
- [ ] Update PROJECT_NAME variable
- [ ] Add project-specific packages
- [ ] Add custom helper functions

### run_MYPROJECT.R
- [ ] Rename file to match your project
- [ ] Update PROFILE source path
- [ ] Define pipeline stages
- [ ] Configure error handling

### user_config.yml
- [ ] Set your GitHub directory
- [ ] Set your OneDrive/Teams path
- [ ] Set data storage locations

### .gitignore
- [ ] Review data file patterns
- [ ] Add project-specific exceptions
- [ ] Test with `git status`

---

## Troubleshooting

### Configuration file not found
```r
# Check working directory
getwd()  # Should be project root

# Use here package
library(here)
here()
```

### Packages not loading
```r
# PROFILE includes auto-install
source("profile_MYPROJECT.R")
```

### Paths not working
```r
# Verify user config
config <- yaml::read_yaml("user_config.yml")
print(config$paths)
```

---

## Additional Resources

### External Documentation
- [R for Data Science](https://r4ds.had.co.nz/)
- [here package](https://here.r-lib.org/)
- [yaml package](https://cran.r-project.org/package=yaml)
- [renv package](https://rstudio.github.io/renv/)

### UNICEF Analytics
- Main repository: `C:\GitHub\mytasks\unicef-analytics-setup\`
- IDE installation: See `install-ides.md`
- Package installation: See `Makefile`

---

## Support

For questions:
1. Check relevant guide (CONFIG-GUIDE.md, PROFILE-RUN-GUIDE.md, GITIGNORE-GUIDE.md)
2. Review examples in this README
3. Consult team lead or senior analyst

---

**Last Updated**: 2025-01-09  
**Version**: 1.0  
**Maintainer**: UNICEF Analytics Team

```yaml
your_username:
  # Core paths
  githubFolder: "/path/to/GitHub"
  teamsRoot: "/path/to/Teams"
  
  # Project-specific
  dwProduction: "/path/to/DW-Production"
  sdgReporting: "/path/to/PROD-SDG-REP-2025"
  
  # Data sources
  micsData: "/path/to/MICS"
  adminData: "/path/to/admin"
  
  # Outputs
  reports: "/path/to/reports"
  figures: "/path/to/figures"
```
