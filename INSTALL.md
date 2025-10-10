# Installation Guide - UNICEF Analytics Environment

This guide provides detailed installation instructions for the UNICEF Analytics Environment on Windows, macOS, and Linux.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Quick Installation](#quick-installation)
3. [Platform-Specific Setup](#platform-specific-setup)
4. [Manual Installation](#manual-installation)
5. [Verification](#verification)
6. [Configuration](#configuration)
7. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Required Software

#### R (>= 4.0.0)
**Required** - Core statistical computing platform

- **Windows**: Download from [CRAN](https://cran.r-project.org/bin/windows/base/)
- **macOS**: Download from [CRAN](https://cran.r-project.org/bin/macosx/)
- **Linux**: 
  ```bash
  # Ubuntu/Debian
  sudo apt-get update
  sudo apt-get install r-base r-base-dev
  
  # CentOS/RHEL
  sudo yum install R
  ```

#### Python (>= 3.9)
**Recommended** - Data science and automation

- **Windows**: Download from [python.org](https://www.python.org/downloads/)
  - ✅ Check "Add Python to PATH"
- **macOS**: Download from [python.org](https://www.python.org/downloads/) or use Homebrew:
  ```bash
  brew install python3
  ```
- **Linux**:
  ```bash
  # Ubuntu/Debian
  sudo apt-get install python3 python3-pip python3-venv
  
  # CentOS/RHEL
  sudo yum install python3 python3-pip
  ```

#### Git
**Recommended** - Version control

- **Windows**: Download from [git-scm.com](https://git-scm.com/download/win)
- **macOS**: Install Xcode Command Line Tools:
  ```bash
  xcode-select --install
  ```
- **Linux**:
  ```bash
  # Ubuntu/Debian
  sudo apt-get install git
  
  # CentOS/RHEL
  sudo yum install git
  ```

### Optional Software

#### Stata (>= 15)
**Optional** - Some projects require Stata

- License required from [stata.com](https://www.stata.com/)
- Add Stata to system PATH for automation

#### Pandoc (>= 2.11)
**Recommended** - Document conversion

- Download from [pandoc.org](https://pandoc.org/installing.html)
- Or install via R: `install.packages("pandoc")`

#### Quarto (>= 1.3)
**Recommended** - Scientific publishing

- Download from [quarto.org](https://quarto.org/docs/get-started/)

#### Development Environments
- **VS Code**: Download from [code.visualstudio.com](https://code.visualstudio.com/)
- **RStudio**: Download from [posit.co](https://posit.co/download/rstudio-desktop/)

---

## Quick Installation

### Automated Installation (Recommended)

#### Windows
```powershell
# Navigate to repository
cd unicef-analytics-setup

# Run installer
.\install-windows.bat
```

#### macOS/Linux
```bash
# Navigate to repository
cd unicef-analytics-setup

# Make installer executable
chmod +x install-unix.sh

# Run installer
./install-unix.sh
```

### Using Makefile
```bash
# Complete setup
make setup

# Or step by step
make check              # Verify prerequisites
make install-r          # Install R packages
make install-python     # Install Python packages
make install-stata      # Install Stata packages (optional)
make verify             # Verify installation
```

---

## Platform-Specific Setup

### Windows

#### Using Make on Windows

**Option 1: Git Bash** (recommended)
- Comes with Git for Windows
- Run `make` commands in Git Bash terminal

**Option 2: WSL (Windows Subsystem for Linux)**
```powershell
# Install WSL
wsl --install

# In WSL terminal
cd /mnt/c/path/to/unicef-analytics-setup
make setup
```

**Option 3: Chocolatey Make**
```powershell
# Install Chocolatey package manager first
choco install make
```

#### Network Drive Configuration
If using UNICEF network drives (Z:):
```powershell
# Map network drive
net use Z: \\server\share /persistent:yes

# Verify access
dir Z:\
```

### macOS

#### Install Homebrew (optional but recommended)
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### Install Additional Tools
```bash
# Using Homebrew
brew install r
brew install python3
brew install git
brew install pandoc
brew install --cask rstudio
brew install --cask visual-studio-code
```

#### XQuartz (for some R graphics)
```bash
brew install --cask xquartz
```

### Linux (Ubuntu/Debian)

#### Install All Prerequisites
```bash
# Update package list
sudo apt-get update

# Install R
sudo apt-get install -y r-base r-base-dev

# Install Python
sudo apt-get install -y python3 python3-pip python3-venv

# Install development tools
sudo apt-get install -y build-essential git curl wget

# Install system dependencies for R packages
sudo apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    libgdal-dev \
    libproj-dev \
    libudunits2-dev
```

---

## Manual Installation

If you prefer manual control or the automated scripts don't work:

### Step 1: Install Core Software
Follow the [Prerequisites](#prerequisites) section above.

### Step 2: Clone Repository
```bash
git clone https://github.com/unicef/analytics-setup
cd analytics-setup
```

### Step 3: Install R Packages
```r
# In R console or RStudio
source("install-r-packages.R")

# Or from command line
Rscript install-r-packages.R
```

### Step 4: Install Python Packages

#### Using Virtual Environment (Recommended)
```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate
# macOS/Linux:
source venv/bin/activate

# Install packages
python install-python-packages.py
```

#### Global Installation
```bash
# Install directly
python install-python-packages.py

# Or with pip
pip install -r requirements-python.txt
```

### Step 5: Install Stata Packages (Optional)
```stata
* In Stata console
do requirements-stata.do
```

### Step 6: Configure User Settings
```bash
# Windows
mkdir %USERPROFILE%\.config
copy _config_template\user_config.yml %USERPROFILE%\.config\user_config.yml

# macOS/Linux
mkdir -p ~/.config
cp _config_template/user_config.yml ~/.config/user_config.yml
```

Edit `~/.config/user_config.yml`:
```yaml
your_username:
  githubFolder: "/path/to/GitHub"
  teamsRoot: "/path/to/Teams"
  workingDir: "/path/to/working"
```

---

## Verification

### Using Makefile
```bash
make check          # Check all dependencies
make test           # Run test suite
make validate       # Comprehensive validation
make report         # Generate installation report
```

### Manual Verification

#### R Environment
```r
# In R console
# Check R version
R.version.string

# Check installed packages
nrow(installed.packages())

# Test loading critical packages
library(tidyverse)
library(data.table)
library(ggplot2)
```

#### Python Environment
```python
# In Python console
import sys
print(sys.version)

# Check installed packages
import subprocess
subprocess.run([sys.executable, "-m", "pip", "list"])

# Test importing critical packages
import numpy
import pandas
import matplotlib
```

#### Stata Environment
```stata
* In Stata console
version
which gtools
which reghdfe
```

---

## Configuration

### R Configuration

#### Set R Library Path
```r
# Add to ~/.Rprofile
.libPaths(c("~/R/library", .libPaths()))
```

#### RStudio Configuration
Create `~/.Rprofile`:
```r
# Personal R configuration
options(
  repos = c(CRAN = "https://cloud.r-project.org/"),
  browser = "firefox",
  editor = "code"
)
```

### Python Configuration

#### Virtual Environment Best Practices
```bash
# Always activate before work
source venv/bin/activate  # macOS/Linux
venv\Scripts\activate     # Windows

# Deactivate when done
deactivate
```

#### Python Path Configuration
Add to `~/.bashrc` or `~/.zshrc`:
```bash
export PYTHONPATH="${PYTHONPATH}:/path/to/your/modules"
```

### VS Code Configuration

#### Recommended Extensions
- R: `REditorSupport.r`
- Python: `ms-python.python`
- Jupyter: `ms-toolsai.jupyter`
- YAML: `redhat.vscode-yaml`

#### Settings
```json
{
  "r.rterm.windows": "C:\\Program Files\\R\\R-4.3.0\\bin\\x64\\R.exe",
  "python.defaultInterpreterPath": "${workspaceFolder}/venv/bin/python"
}
```

---

## Troubleshooting

### Common Issues

#### R Package Installation Fails

**Problem**: Package compilation errors on Windows
```r
# Solution: Use binary packages
install.packages("package_name", type = "binary")
```

**Problem**: Missing system dependencies on Linux
```bash
# Install development libraries
sudo apt-get install libcurl4-openssl-dev libssl-dev libxml2-dev
```

#### Python Package Installation Fails

**Problem**: pip version too old
```bash
python -m pip install --upgrade pip
```

**Problem**: Permission denied (Unix)
```bash
# Use virtual environment (recommended)
python -m venv venv
source venv/bin/activate
pip install -r requirements-python.txt
```

#### Network Issues

**Problem**: Firewall blocking downloads
- Configure proxy settings
- Use institutional mirror/repository

**Problem**: SSL certificate errors
```r
# R: Disable SSL verification (temporary)
options(download.file.method = "wininet")

# Python: Use --trusted-host
pip install --trusted-host pypi.org package_name
```

#### PATH Issues

**Problem**: Command not found
```bash
# Windows: Add to PATH in System Properties
# macOS/Linux: Add to ~/.bashrc or ~/.zshrc
export PATH="/usr/local/bin:$PATH"
```

### Getting More Help

1. Check logs in `logs/` directory
2. Run diagnostics: `make diagnose`
3. See [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
4. Check repository issues on GitHub
5. Contact: UNICEF Data & Analytics Section

---

## Next Steps

After successful installation:

1. **Test with a Sample Project**
   ```bash
   cd ../DW-Production
   make check
   ```

2. **Configure Your Workspace**
   - Set up user configuration
   - Configure Git credentials
   - Set default working directories

3. **Learn the Tools**
   - Review Makefile commands: `make help`
   - Explore documentation
   - Try example workflows

4. **Stay Updated**
   ```bash
   make update-all      # Update all packages
   git pull             # Get latest setup scripts
   ```

---

**For additional help, see:**
- [README.md](README.md) - Overview and quick start
- [REQUIREMENTS.md](REQUIREMENTS.md) - Detailed requirements
- [PACKAGE-LIST.md](PACKAGE-LIST.md) - Complete package inventory
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Common issues and solutions
