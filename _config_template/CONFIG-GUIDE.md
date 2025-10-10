# UNICEF Analytics - Configuration Guide

## Overview

This guide explains how to set up and use configuration files for UNICEF analytics projects.

---

## Configuration Files

### 1. `user_config.yml` - Personal Settings

**Purpose**: User-specific paths and preferences (not version controlled)

**Location**: `~/.config/user_config.yml` or project root

**Contents**:
- Local file paths
- Personal API keys
- User preferences
- System-specific settings

**Example**:
```yaml
paths:
  data: "D:/UNICEF/Data"
  projects: "C:/Users/YourName/Projects"
  
credentials:
  world_bank_api_key: "your-key-here"
  
preferences:
  default_output: "html"
  parallel_cores: 4
```

### 2. `project_config.yml` - Project Settings

**Purpose**: Project-wide configuration (version controlled)

**Location**: Project root directory

**Contents**:
- Project metadata
- Directory structure
- Data sources
- Processing parameters
- Output settings

**Example**: See `_config_template/project_config.yml`

---

## Setup Instructions

### Step 1: Copy Template to Your Project

```bash
# Navigate to your project
cd /path/to/your/project

# Copy template
cp /path/to/unicef-analytics-setup/_config_template/project_config.yml ./config.yml

# Edit for your project
code config.yml  # or vim, nano, etc.
```

### Step 2: Create User Config

```bash
# Create config directory
mkdir -p ~/.config

# Copy user template
cp /path/to/unicef-analytics-setup/_config_template/user_config.yml ~/.config/

# Edit with your personal settings
code ~/.config/user_config.yml
```

### Step 3: Load Configuration in Your Scripts

#### R

```r
# Install yaml package if needed
if (!requireNamespace("yaml", quietly = TRUE)) {
  install.packages("yaml")
}

# Load project config
config <- yaml::read_yaml("config.yml")

# Load user config
user_config <- yaml::read_yaml("~/.config/user_config.yml")

# Access values
data_path <- config$paths$data
author <- config$project$author
api_key <- user_config$credentials$world_bank_api_key

# Use in script
cat("Project:", config$project$name, "\n")
cat("Data directory:", file.path(config$paths$root, config$paths$data), "\n")
```

#### Python

```python
import yaml
from pathlib import Path

# Load project config
with open('config.yml', 'r') as f:
    config = yaml.safe_load(f)

# Load user config
user_config_path = Path.home() / '.config' / 'user_config.yml'
with open(user_config_path, 'r') as f:
    user_config = yaml.safe_load(f)

# Access values
data_path = config['paths']['data']
author = config['project']['author']
api_key = user_config['credentials']['world_bank_api_key']

# Use in script
print(f"Project: {config['project']['name']}")
print(f"Data directory: {Path(config['paths']['root']) / config['paths']['data']}")
```

---

## Configuration Sections Explained

### Project Metadata

```yaml
project:
  name: "Your Project Name"
  version: "1.0.0"
  author: "Your Name"
  organization: "UNICEF"
```

**Why**: Track project information, version history, and ownership.

### Directory Structure

```yaml
paths:
  data: "01_data_prep"
  analysis: "02_analysis"
  outputs: "03_outputs"
```

**Why**: Standardize folder structure across projects, make scripts portable.

**Best Practice**: Use relative paths from project root.

### Data Sources

```yaml
data_sources:
  apis:
    world_bank:
      base_url: "https://api.worldbank.org/v2"
  files:
    mics:
      path: "01_data_prep/011_raw_data/MICS"
```

**Why**: Centralize data source definitions, easy to update URLs or paths.

### Parameters

```yaml
parameters:
  analysis_period:
    start_year: 2015
    end_year: 2024
  statistics:
    confidence_level: 0.95
```

**Why**: Control analysis behavior without changing code, ensure reproducibility.

### Output Settings

```yaml
output:
  figures:
    width: 10
    height: 6
    dpi: 300
  tables:
    format: "latex"
    digits: 2
```

**Why**: Consistent output formatting, easy to change for different audiences.

---

## Best Practices

### 1. Version Control

**DO**:
- ✅ Commit `project_config.yml`
- ✅ Add to `.gitignore`: `user_config.yml`, `.env`
- ✅ Include `config_template.yml` for team

**DON'T**:
- ❌ Commit API keys or passwords
- ❌ Hardcode personal paths in project config
- ❌ Store sensitive data in YAML files

### 2. Separation of Concerns

```yaml
# Project config (version controlled)
project:
  name: "Global Education Analysis"
paths:
  data: "data"  # Relative path

# User config (not version controlled)
paths:
  data_root: "D:/UNICEF/Projects/GlobalEdu/data"  # Absolute path
credentials:
  api_key: "secret-key-here"
```

### 3. Use Environment Variables for Secrets

Create `.env` file:
```bash
WORLD_BANK_API_KEY=your-secret-key
DATABASE_PASSWORD=your-password
```

Reference in config:
```yaml
resources:
  credentials:
    use_env_file: true
    env_file: ".env"
```

Load in R:
```r
library(dotenv)
load_dot_env()
api_key <- Sys.getenv("WORLD_BANK_API_KEY")
```

Load in Python:
```python
from dotenv import load_dotenv
import os

load_dotenv()
api_key = os.getenv('WORLD_BANK_API_KEY')
```

### 4. Document Your Configuration

```yaml
# ==============================================================================
# CUSTOM PARAMETERS
# ==============================================================================
# outlier_threshold: Number of standard deviations for outlier detection
#   - Type: numeric
#   - Range: 2-5 (typically 3)
#   - Impact: Higher values = fewer outliers flagged
# ==============================================================================
parameters:
  statistics:
    outlier_threshold: 3
```

### 5. Validate Configuration

Create validation script:

**R** (`validate_config.R`):
```r
validate_config <- function(config) {
  # Check required fields
  required <- c("project", "paths", "parameters")
  missing <- setdiff(required, names(config))
  
  if (length(missing) > 0) {
    stop("Missing required sections: ", paste(missing, collapse = ", "))
  }
  
  # Check paths exist
  data_path <- file.path(config$paths$root, config$paths$data)
  if (!dir.exists(data_path)) {
    warning("Data directory does not exist: ", data_path)
  }
  
  # Check parameter ranges
  if (config$parameters$statistics$confidence_level < 0 || 
      config$parameters$statistics$confidence_level > 1) {
    stop("confidence_level must be between 0 and 1")
  }
  
  message("✓ Configuration validated successfully")
  invisible(TRUE)
}

# Usage
config <- yaml::read_yaml("config.yml")
validate_config(config)
```

**Python** (`validate_config.py`):
```python
def validate_config(config):
    """Validate configuration structure and values"""
    # Check required fields
    required = ['project', 'paths', 'parameters']
    missing = [f for f in required if f not in config]
    
    if missing:
        raise ValueError(f"Missing required sections: {', '.join(missing)}")
    
    # Check paths exist
    from pathlib import Path
    data_path = Path(config['paths']['root']) / config['paths']['data']
    if not data_path.exists():
        print(f"Warning: Data directory does not exist: {data_path}")
    
    # Check parameter ranges
    conf_level = config['parameters']['statistics']['confidence_level']
    if not 0 < conf_level < 1:
        raise ValueError("confidence_level must be between 0 and 1")
    
    print("✓ Configuration validated successfully")
    return True

# Usage
import yaml
with open('config.yml') as f:
    config = yaml.safe_load(f)
validate_config(config)
```

---

## Common Patterns

### Pattern 1: Multi-Environment Config

```yaml
# config.yml
defaults: &defaults
  project:
    name: "Analytics Project"
  
development:
  <<: *defaults
  environment: "dev"
  paths:
    data: "data/dev"
  logging:
    level: "DEBUG"

production:
  <<: *defaults
  environment: "prod"
  paths:
    data: "/data/production"
  logging:
    level: "INFO"
```

Load based on environment:
```r
env <- Sys.getenv("ENVIRONMENT", "development")
config <- yaml::read_yaml("config.yml")[[env]]
```

### Pattern 2: Conditional Processing

```yaml
workflow:
  stages:
    - name: "download_data"
      enabled: true
    - name: "clean_data"
      enabled: true
    - name: "expensive_analysis"
      enabled: false  # Skip for quick runs
```

Use in script:
```r
stages <- config$workflow$stages
for (stage in stages) {
  if (stage$enabled) {
    cat("Running:", stage$name, "\n")
    source(stage$script)
  }
}
```

### Pattern 3: Dynamic Paths

```yaml
paths:
  root: "."
  data: "01_data_prep"
  
  # Computed paths (construct in code)
  # data_raw = root + "/" + data + "/011_raw_data"
```

Construct paths in R:
```r
get_path <- function(config, ...) {
  parts <- list(config$paths$root, ...)
  do.call(file.path, parts)
}

# Usage
data_raw <- get_path(config, config$paths$data, "011_raw_data")
```

---

## Troubleshooting

### Issue: "Cannot find config file"

**Solution**:
```r
# Check working directory
getwd()

# Set to project root
setwd("/path/to/project")

# Or use here package
library(here)
config <- yaml::read_yaml(here("config.yml"))
```

### Issue: "Invalid YAML syntax"

**Solution**: Validate YAML online at [yamllint.com](http://www.yamllint.com/)

Common errors:
- Incorrect indentation (use spaces, not tabs)
- Missing quotes around special characters
- Inconsistent list formatting

### Issue: "Config values not updating"

**Solution**: Clear R environment or restart Python kernel

```r
# R: Clear and reload
rm(list = ls())
config <- yaml::read_yaml("config.yml")
```

```python
# Python: Reload module
import importlib
importlib.reload(yaml)
```

---

## Examples

### Example 1: Education Analysis Project

```yaml
project:
  name: "Global Primary Education Analysis"
  focus: "Learning Poverty"

parameters:
  geography:
    countries: ["ETH", "KEN", "NGA", "UGA"]
  indicators:
    - "SE.PRM.NENR"
    - "LO.PISA.REA"
  
workflow:
  stages:
    - name: "download_wb_data"
      script: "scripts/01_download.R"
    - name: "clean_data"
      script: "scripts/02_clean.R"
    - name: "calculate_lp"
      script: "scripts/03_learning_poverty.R"
```

### Example 2: Health Monitoring Dashboard

```yaml
project:
  name: "Child Health Monitoring"
  update_frequency: "monthly"

data_sources:
  apis:
    dhis2:
      base_url: "https://dhis2.org/api"
      
output:
  dashboard:
    format: "html"
    refresh_interval: 3600  # seconds
    auto_update: true
```

---

## Additional Resources

- **YAML Syntax**: [yaml.org](https://yaml.org/)
- **R yaml package**: [CRAN](https://cran.r-project.org/package=yaml)
- **Python PyYAML**: [pyyaml.org](https://pyyaml.org/)
- **Config management**: [12factor.net/config](https://12factor.net/config)

---

**Next Steps**:
1. Copy `project_config.yml` template
2. Customize for your project
3. Create user config with personal settings
4. Load in your scripts
5. Test and validate
