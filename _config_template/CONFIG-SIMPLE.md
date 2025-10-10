# Universal Configuration System - Quick Start

## Philosophy

**ONE config file for ALL your UNICEF repos** - no per-project configuration needed!

### Key Principles

1. **Universal, not project-specific** - Same config works everywhere
2. **Auto-detection first** - Paths detected from VS Code workspace
3. **Minimal configuration** - Only set what can't be auto-detected
4. **No duplication** - Set GitHub root once, not for every project

---

## Quick Setup (One-Time)

### Step 1: Create Universal Config (Once)

```powershell
# Windows - Create config directory
mkdir "$env:USERPROFILE\.config\unicef_analytics"

# Copy template
copy _config_template\user_config.yml "$env:USERPROFILE\.config\unicef_analytics\user_config.yml"

# Edit with your paths
notepad "$env:USERPROFILE\.config\unicef_analytics\user_config.yml"
```

```bash
# macOS/Linux
mkdir -p ~/.config/unicef_analytics
cp _config_template/user_config.yml ~/.config/unicef_analytics/user_config.yml

# Edit
nano ~/.config/unicef_analytics/user_config.yml
```

### Step 2: Set Your Paths (Only 3 things!)

```yaml
# ~/.config/unicef_analytics/user_config.yml

paths:
  github_dir: "C:/GitHub"              # Where you clone all repos
  teams_dir: "C:/Users/You/OneDrive"   # UNICEF Teams/OneDrive
  data_dir: "Z:/SharedData"            # Network data location

preferences:
  default_cores: 4                     # CPU cores to use
```

**That's it!** This config now works for ALL projects.

---

## How It Works

### Auto-Detection Hierarchy

```
1. VS Code Workspace → Auto-detected (if workspace open)
2. Project Root      → Auto-detected via here::here()
3. User Config       → ~/.config/unicef_analytics/user_config.yml
4. Fallback          → Sensible defaults
```

### Example: Three Projects, One Config

```
C:/GitHub/
  ├── project-A/           # Uses universal config
  ├── project-B/           # Uses universal config  
  └── project-C/           # Uses universal config

C:/Users/You/.config/unicef_analytics/
  └── user_config.yml      # ONE config for all!
```

---

## Usage in Projects

### Option 1: Simple Profile (Recommended)

Copy `profile_SIMPLE.R` to your project:

```r
# In your project (any project!)
source("profile_SIMPLE.R")

# Everything auto-configured:
# - paths$data_raw    → auto-detected
# - paths$outputs     → auto-detected
# - project_root      → auto-detected
# - workspace_dir     → from VS Code
```

### Option 2: Without Profile

```r
library(here)

# Auto-detect project root
project_root <- here::here()

# Standard paths
data_dir <- here::here("01_data_prep", "011_raw_data")
output_dir <- here::here("03_outputs")

# Load universal config if needed
user_config <- yaml::read_yaml(
  file.path(Sys.getenv("USERPROFILE"), ".config", "unicef_analytics", "user_config.yml")
)
```

---

## When to Use project_config.yml (Rarely)

**Only create project_config.yml if:**

- Using specific APIs (World Bank, UNICEF data)
- Need project-specific parameters (country lists, indicators)
- Complex multi-stage workflows
- Team needs to share specific settings

**Most projects DON'T need it!**

---

## VS Code Integration

### Workspace Detection

When you open a folder in VS Code, the profile auto-detects it:

```r
# Auto-detected from VS Code
workspace_dir <- Sys.getenv("VSCODE_WORKSPACE_DIR")

# Falls back to project root if not in VS Code
if (workspace_dir == "") {
  workspace_dir <- here::here()
}
```

### VS Code Settings (Optional)

Add to `.vscode/settings.json` in your project:

```json
{
  "r.rterm.windows": "C:\\Program Files\\R\\R-4.3.0\\bin\\x64\\R.exe",
  "r.workspaceViewer.showWorkspace": true,
  "env": {
    "VSCODE_WORKSPACE_DIR": "${workspaceFolder}"
  }
}
```

---

## Examples

### Example 1: Quick Analysis

```r
# Any project, any repo
source("profile_SIMPLE.R")

# Auto-detected paths work immediately
data <- read.csv(file.path(paths$data_raw, "mydata.csv"))

# Process
clean_data <- data %>% filter(!is.na(value))

# Save with auto-timestamp
save_data(clean_data, "cleaned")
# → Saves to: 01_data_prep/013_processed_data/cleaned_20250109.csv
```

### Example 2: Using Network Data

```r
source("profile_SIMPLE.R")

# Your universal config has data_dir = "Z:/SharedData"
network_data <- file.path(user_config$paths$data_dir, "MICS", "country_data.csv")

# Copy to local project
file.copy(network_data, paths$data_raw)
```

### Example 3: Multi-Project Workflow

```r
# In project A
source("profile_SIMPLE.R")
results_A <- analyze_data()
save_data(results_A, "results")

# In project B (different repo)
source("profile_SIMPLE.R")

# Access project A results via github_dir
project_A_path <- file.path(user_config$paths$github_dir, "project-A", "03_outputs")
results_A <- read.csv(file.path(project_A_path, "results_latest.csv"))

# Combine with project B
combined <- merge(results_A, results_B)
```

---

## Directory Structure

### Minimal Project (No Config Files Needed)

```
my-project/
├── profile_SIMPLE.R          # Universal profile
├── scripts/
│   └── analysis.R
├── 01_data_prep/
│   ├── 011_raw_data/         # Auto-detected
│   └── 013_processed_data/   # Auto-detected
└── 03_outputs/               # Auto-detected
```

**No user_config.yml in project** - uses universal config!  
**No project_config.yml needed** - auto-detection handles it!

### Complex Project (Optional project_config.yml)

```
complex-project/
├── profile_SIMPLE.R
├── project_config.yml        # Optional: API settings, parameters
├── .env                      # Credentials (not committed)
├── scripts/
└── (standard directories auto-detected)
```

---

## Credentials (.env)

For sensitive data, use `.env` **per project**:

```bash
# .env (in project root, NOT committed)
API_KEY=your_key_here
DB_PASSWORD=your_password
UNICEF_TOKEN=abc123
```

Profile automatically loads it:

```r
source("profile_SIMPLE.R")

# Credentials available
api_key <- Sys.getenv("API_KEY")
```

---

## Migration from Old System

### If You Have Per-Project Configs

**Old way** (per-project config):
```
project-A/user_config.yml
project-B/user_config.yml  
project-C/user_config.yml
```

**New way** (universal config):
```
~/.config/unicef_analytics/user_config.yml  # One file!
```

**Migration steps:**

1. Create universal config (once)
2. Copy `profile_SIMPLE.R` to each project
3. Delete per-project `user_config.yml` files
4. Add `user_config.yml` to `.gitignore`

---

## Comparison

### Old: Project-Specific Config ❌

```yaml
# In EVERY project
project: "SDG-Report"
paths:
  root: "C:/GitHub/SDG-Report"
  data_raw: "C:/GitHub/SDG-Report/01_data_prep/011_raw_data"
  github_dir: "C:/GitHub"
  # ... dozens of duplicated paths
```

### New: Universal Config ✅

```yaml
# ONE file for all projects
paths:
  github_dir: "C:/GitHub"
  data_dir: "Z:/SharedData"
  
# Everything else auto-detected!
```

---

## FAQ

**Q: Do I need user_config.yml in each project?**  
A: No! One universal config in `~/.config/unicef_analytics/`

**Q: What if I have project-specific settings?**  
A: Use `project_config.yml` (optional) or `.env` for credentials

**Q: How does it find my project root?**  
A: Auto-detected via `here::here()` package

**Q: What about VS Code workspace?**  
A: Auto-detected from `VSCODE_WORKSPACE_DIR` environment variable

**Q: Can I still override paths for special cases?**  
A: Yes! Set them in `project_config.yml` or directly in your script

**Q: What if no config file exists?**  
A: Profile uses sensible defaults and auto-detection

---

## Best Practices

### ✅ DO

- Create ONE universal config in `~/.config/unicef_analytics/`
- Use `profile_SIMPLE.R` in all projects
- Let auto-detection handle paths
- Use `.env` for credentials (per-project)
- Only create `project_config.yml` when truly needed

### ❌ DON'T

- Don't create `user_config.yml` in every project
- Don't hard-code paths in scripts
- Don't commit credentials to Git
- Don't duplicate settings across projects

---

## Summary

**Before**: Configure every project individually  
**After**: Configure once, works everywhere!

```r
# This works in ANY project:
source("profile_SIMPLE.R")

# All paths auto-configured ✓
# User preferences loaded ✓
# Credentials loaded ✓
# Helper functions available ✓

# Just start working!
```

---

**Questions?** See full documentation in CONFIG-GUIDE.md
