# IDE and Editor Installation Guide

This guide provides installation instructions for development environments and document preparation tools.

## Table of Contents

1. [Rtools (Windows)](#rtools-windows) - **Essential for R package development**
2. [VS Code](#vs-code)
3. [RStudio](#rstudio)
4. [Spyder](#spyder)
5. [R Development Tools](#r-development-tools) - radian, languageserver
6. [LaTeX/MiKTeX](#latex-miktex)
7. [Automated Installation](#automated-installation)

---

## Rtools (Windows)

**Rtools is ESSENTIAL for R package development on Windows** - it provides the compiler toolchain needed to build R packages from source.

### What is Rtools?

Rtools is a collection of build tools (gcc, make, etc.) required to:
- Install R packages that need compilation
- Build R packages from source
- Use packages like `data.table`, `Rcpp`, and many others

### Installation

**Option 1: Direct Download (Recommended)**

1. Visit [CRAN Rtools](https://cran.r-project.org/bin/windows/Rtools/)
2. Download **Rtools43** (for R 4.3.x and later) or appropriate version
3. Run the installer
4. ✅ **IMPORTANT**: Check "Add rtools to system PATH"
5. Complete installation

**Option 2: Chocolatey**
```powershell
choco install rtools -y
```

**Option 3: Via R**
```r
# Check if Rtools is installed
pkgbuild::check_build_tools(debug = TRUE)

# If not installed, R will prompt to install
```

### Verification

Check if Rtools is properly installed:

```r
# In R console
Sys.which("make")
# Should show path to make.exe

# Or use pkgbuild
pkgbuild::has_build_tools(debug = TRUE)
# Should return TRUE
```

### Troubleshooting

**Issue**: "WARNING: Rtools is required to build R packages"

**Solution**:
1. Ensure Rtools is in PATH
2. Restart R/RStudio after installation
3. Run: `writeLines('PATH="${RTOOLS43_HOME}\\usr\\bin;${PATH}"', con = "~/.Renviron")`
4. Restart R again

---

## VS Code

### Windows

**Option 1: Direct Download**
1. Download from [code.visualstudio.com](https://code.visualstudio.com/)
2. Run installer
3. ✅ Check "Add to PATH"
4. ✅ Check "Add 'Open with Code' action"

**Option 2: Chocolatey**
```powershell
choco install vscode -y
```

**Option 3: winget**
```powershell
winget install Microsoft.VisualStudioCode
```

### macOS

**Option 1: Direct Download**
1. Download from [code.visualstudio.com](https://code.visualstudio.com/)
2. Open downloaded .dmg
3. Drag to Applications folder

**Option 2: Homebrew**
```bash
brew install --cask visual-studio-code
```

### Linux

**Ubuntu/Debian:**
```bash
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install code
```

**CentOS/RHEL:**
```bash
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf check-update
sudo dnf install code
```

### Recommended Extensions

Install via command line:
```bash
# R development
code --install-extension REditorSupport.r
code --install-extension Ikuyadeu.r-debugger

# Python development
code --install-extension ms-python.python
code --install-extension ms-python.vscode-pylance
code --install-extension ms-toolsai.jupyter

# Stata
code --install-extension kylebarron.stata-enhanced

# General
code --install-extension yzhang.markdown-all-in-one
code --install-extension redhat.vscode-yaml
code --install-extension mechatroner.rainbow-csv
code --install-extension streetsidesoftware.code-spell-checker
```

---

## RStudio

### Windows

**Option 1: Direct Download**
1. Download from [posit.co/download/rstudio-desktop](https://posit.co/download/rstudio-desktop/)
2. Run the .exe installer
3. Follow installation wizard

**Option 2: Chocolatey**
```powershell
choco install r.studio -y
```

**Option 3: winget**
```powershell
winget install Posit.RStudio
```

### macOS

**Option 1: Direct Download**
1. Download from [posit.co/download/rstudio-desktop](https://posit.co/download/rstudio-desktop/)
2. Open the .dmg file
3. Drag RStudio to Applications

**Option 2: Homebrew**
```bash
brew install --cask rstudio
```

### Linux

**Ubuntu/Debian:**
```bash
# Download the latest version
wget https://download1.rstudio.org/electron/jammy/amd64/rstudio-2024.04.0-daily-734-amd64.deb

# Install
sudo dpkg -i rstudio-*-amd64.deb

# Fix dependencies if needed
sudo apt-get install -f
```

**CentOS/RHEL:**
```bash
# Download
wget https://download1.rstudio.org/electron/centos8/x86_64/rstudio-2024.04.0-daily-734-x86_64.rpm

# Install
sudo yum install rstudio-*-x86_64.rpm
```

### Configure RStudio

Create/edit `~/.Rprofile`:
```r
# Set CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org/"))

# Increase memory limit (Windows)
if (Sys.info()["sysname"] == "Windows") {
  memory.limit(size = 16000)
}

# Auto-load commonly used packages
.First <- function() {
  if (interactive()) {
    suppressMessages({
      library(tidyverse)
    })
    cat("\nWelcome to RStudio!\n")
    cat("R version:", R.version.string, "\n\n")
  }
}
```

---

## Spyder

### All Platforms

**Option 1: Via pip (Recommended)**
```bash
# Create dedicated environment (recommended)
python -m venv spyder-env
source spyder-env/bin/activate  # macOS/Linux
spyder-env\Scripts\activate     # Windows

# Install Spyder
pip install spyder

# Or install with extras
pip install spyder spyder-kernels
```

**Option 2: Via conda**
```bash
# Create conda environment
conda create -n spyder-env python=3.11
conda activate spyder-env

# Install Spyder
conda install spyder
```

### Windows-Specific

**Option 3: Standalone Installer**
1. Download from [github.com/spyder-ide/spyder/releases](https://github.com/spyder-ide/spyder/releases)
2. Run the Windows installer (.exe)
3. Follow installation wizard

**Option 4: Chocolatey**
```powershell
choco install spyder -y
```

### macOS-Specific

**Option 3: Homebrew**
```bash
brew install --cask spyder
```

### Linux-Specific

**Ubuntu/Debian:**
```bash
sudo apt install spyder
```

### Launch Spyder

```bash
# If installed via pip/conda
spyder

# Or from system menu
# Windows: Start Menu > Spyder
# macOS: Applications > Spyder
# Linux: Applications Menu > Development > Spyder
```

### Configure Spyder

**Preferences → Python interpreter:**
- Set to your virtual environment Python

**Preferences → IPython console:**
- Graphics backend: Automatic or Qt5
- Enable plotting in separate window

---

## R Development Tools

### radian - Enhanced R Console

**radian** is a modern R console with multiline editing, syntax highlighting, and auto-completion.

#### Installation

**All Platforms:**
```bash
# Requires Python
pip install radian

# Or with pipx (isolated installation)
pipx install radian
```

#### Usage

```bash
# Start radian
radian

# Or with custom options
radian --r-binary=/path/to/R
```

#### Configure radian

Create `~/.radian_profile`:
```r
# Set options
options(
  radian.editing_mode = "vi",  # or "emacs"
  radian.complete_while_typing = TRUE,
  radian.auto_match = TRUE,
  radian.prompt = "\033[0;34mR>\033[0m "
)
```

### languageserver - R Language Server Protocol

**Enables IDE features** like auto-completion, go-to-definition, and diagnostics in VS Code and other editors.

#### Installation

```r
# In R console
install.packages("languageserver")

# Or for development version
remotes::install_github("REditorSupport/languageserver")
```

#### VS Code Integration

The `languageserver` package works automatically with the R extension for VS Code:

1. Install VS Code R extension: `code --install-extension REditorSupport.r`
2. Install `languageserver` in R
3. Restart VS Code
4. Open an R file - language server starts automatically

#### Features

- **Auto-completion**: Function names, arguments, variable names
- **Hover documentation**: Function signatures and help
- **Go to definition**: Jump to function source
- **Find references**: See where symbols are used
- **Diagnostics**: Real-time linting and error checking
- **Symbol outline**: Document structure view

### httpgd - HTTP Graphics Device for R

**httpgd** provides live-updating plots in your browser, great for remote R sessions.

#### Installation

```r
install.packages("httpgd")
```

#### Usage

```r
# Start httpgd server
library(httpgd)
hgd()

# Create a plot
plot(1:10)

# View at http://localhost:8080
```

### Rtools (Windows Only - Covered Above)

See [Rtools section](#rtools-windows) for installation.

---

## LaTeX/MiKTeX

### Windows - MiKTeX

**Option 1: Full Installer (Recommended)**
1. Download from [miktex.org/download](https://miktex.org/download)
2. Run the installer
3. Choose "Install MiKTeX for all users" or "Just for me"
4. Install missing packages: On-the-fly

**Option 2: Chocolatey**
```powershell
choco install miktex -y
```

**Configure MiKTeX:**
```powershell
# Update package database
miktex packages update

# Install commonly used packages
miktex packages install latexmk
miktex packages install babel
miktex packages install xcolor
```

### Windows - TinyTeX (Lightweight Alternative)

```r
# In R console
install.packages('tinytex')
tinytex::install_tinytex()

# Install additional packages as needed
tinytex::tlmgr_install(c('collection-fontsrecommended', 'fancyhdr'))
```

### macOS - MacTeX

**Option 1: Full Installation (3.9 GB)**
1. Download MacTeX from [tug.org/mactex](https://tug.org/mactex/)
2. Run the .pkg installer
3. Follow installation wizard

**Option 2: BasicTeX (Minimal, 80 MB)**
```bash
brew install --cask basictex

# Add to PATH
echo 'export PATH="/Library/TeX/texbin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Install additional packages
sudo tlmgr update --self
sudo tlmgr install latexmk
sudo tlmgr install collection-fontsrecommended
```

**Option 3: TinyTeX**
```r
# In R console
install.packages('tinytex')
tinytex::install_tinytex()
```

### Linux - TeX Live

**Ubuntu/Debian:**
```bash
# Full installation (~5 GB)
sudo apt install texlive-full

# Or minimal installation
sudo apt install texlive-latex-base texlive-latex-recommended

# Additional packages
sudo apt install texlive-latex-extra texlive-fonts-recommended
sudo apt install latexmk
```

**CentOS/RHEL:**
```bash
# Full installation
sudo yum install texlive-scheme-full

# Or minimal
sudo yum install texlive texlive-latex
```

**TinyTeX (All Linux):**
```r
# In R console
install.packages('tinytex')
tinytex::install_tinytex()
```

### Verify LaTeX Installation

```bash
# Check version
pdflatex --version
xelatex --version
lualatex --version

# Test compilation
echo '\documentclass{article}
\begin{document}
Hello World!
\end{document}' > test.tex

pdflatex test.tex
```

### LaTeX Editors (Optional)

**TeXstudio (Cross-platform)**
```bash
# Windows
choco install texstudio

# macOS
brew install --cask texstudio

# Linux
sudo apt install texstudio
```

**Texmaker (Cross-platform)**
```bash
# Windows
choco install texmaker

# macOS
brew install --cask texmaker

# Linux
sudo apt install texmaker
```

---

## Automated Installation

### Windows PowerShell Script

Create `install-ides-windows.ps1`:
```powershell
# Install IDEs and editors using Chocolatey
# Requires: Chocolatey package manager

Write-Host "Installing development environments..." -ForegroundColor Cyan

# VS Code
Write-Host "`nInstalling VS Code..." -ForegroundColor Yellow
choco install vscode -y

# RStudio
Write-Host "`nInstalling RStudio..." -ForegroundColor Yellow
choco install r.studio -y

# Spyder
Write-Host "`nInstalling Spyder..." -ForegroundColor Yellow
choco install spyder -y

# MiKTeX
Write-Host "`nInstalling MiKTeX..." -ForegroundColor Yellow
choco install miktex -y

# Optional: LaTeX editor
Write-Host "`nInstalling TeXstudio..." -ForegroundColor Yellow
choco install texstudio -y

Write-Host "`nAll IDEs installed successfully!" -ForegroundColor Green
Write-Host "Please restart your terminal to update PATH" -ForegroundColor Yellow
```

Run:
```powershell
.\install-ides-windows.ps1
```

### macOS/Linux Shell Script

Create `install-ides-unix.sh`:
```bash
#!/bin/bash

echo "Installing development environments..."

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    echo "Detected macOS"
    
    # VS Code
    echo "Installing VS Code..."
    brew install --cask visual-studio-code
    
    # RStudio
    echo "Installing RStudio..."
    brew install --cask rstudio
    
    # Spyder
    echo "Installing Spyder..."
    brew install --cask spyder
    
    # BasicTeX
    echo "Installing BasicTeX..."
    brew install --cask basictex
    
    # TeXstudio
    echo "Installing TeXstudio..."
    brew install --cask texstudio
    
elif [[ -f /etc/debian_version ]]; then
    # Ubuntu/Debian
    echo "Detected Ubuntu/Debian"
    
    # VS Code
    echo "Installing VS Code..."
    sudo apt update
    sudo apt install code -y
    
    # RStudio
    echo "Installing RStudio..."
    wget https://download1.rstudio.org/electron/jammy/amd64/rstudio-latest-amd64.deb
    sudo dpkg -i rstudio-*-amd64.deb
    sudo apt-get install -f -y
    
    # Spyder
    echo "Installing Spyder..."
    sudo apt install spyder -y
    
    # TeX Live
    echo "Installing TeX Live..."
    sudo apt install texlive-latex-recommended texlive-latex-extra -y
    
    # TeXstudio
    echo "Installing TeXstudio..."
    sudo apt install texstudio -y
fi

echo "Installation complete!"
```

Run:
```bash
chmod +x install-ides-unix.sh
./install-ides-unix.sh
```

### Via Makefile

Add to main `Makefile`:
```makefile
install-ides: ## Install IDEs and editors
	@echo "$(BLUE)📦 Installing development environments...$(NC)"
ifeq ($(OS),Windows_NT)
	@powershell -ExecutionPolicy Bypass -File install-ides-windows.ps1
else
	@./install-ides-unix.sh
endif
	@echo "$(GREEN)✓ IDEs installed$(NC)"

install-vscode: ## Install VS Code only
	@echo "$(BLUE)Installing VS Code...$(NC)"
ifeq ($(OS),Windows_NT)
	choco install vscode -y
else ifeq ($(shell uname),Darwin)
	brew install --cask visual-studio-code
else
	sudo apt install code -y || sudo dnf install code -y
endif

install-rstudio: ## Install RStudio only
	@echo "$(BLUE)Installing RStudio...$(NC)"
ifeq ($(OS),Windows_NT)
	choco install r.studio -y
else ifeq ($(shell uname),Darwin)
	brew install --cask rstudio
else
	@echo "Please download from https://posit.co/download/rstudio-desktop/"
endif

install-spyder: ## Install Spyder only
	@echo "$(BLUE)Installing Spyder...$(NC)"
	$(PIP) install spyder

install-latex: ## Install LaTeX distribution
	@echo "$(BLUE)Installing LaTeX...$(NC)"
ifeq ($(OS),Windows_NT)
	choco install miktex -y
else ifeq ($(shell uname),Darwin)
	brew install --cask basictex
else
	sudo apt install texlive-latex-recommended -y || sudo dnf install texlive -y
endif
```

---

## Post-Installation Configuration

### VS Code

**Settings (Ctrl+, or Cmd+,):**
```json
{
  "r.rterm.windows": "C:\\Program Files\\R\\R-4.3.0\\bin\\x64\\R.exe",
  "python.defaultInterpreterPath": "${workspaceFolder}/venv/bin/python",
  "latex-workshop.latex.autoBuild.run": "onSave",
  "latex-workshop.view.pdf.viewer": "tab"
}
```

### RStudio

**Tools → Global Options:**
- General → Save workspace: Never
- Code → Soft-wrap R source files: Yes
- Appearance → Choose your theme
- Pane Layout → Customize your layout

### Spyder

**Tools → Preferences:**
- IPython console → Graphics → Backend: Automatic
- Editor → Display → Show line numbers: Yes
- Run → Execute in current console: Yes

### LaTeX

**Test your installation:**
```bash
# Create test document
cat > test.tex << 'EOF'
\documentclass{article}
\usepackage[utf8]{inputenc}
\title{Test Document}
\author{Your Name}
\date{\today}

\begin{document}
\maketitle
\section{Introduction}
This is a test document.
\end{document}
EOF

# Compile
pdflatex test.tex
```

---

## Troubleshooting

### VS Code: Extensions Not Installing
```bash
# Clear extension cache
rm -rf ~/.vscode/extensions
code --list-extensions
```

### RStudio: Can't Find R
- Windows: Settings → Global Options → R version
- Set to: `C:\Program Files\R\R-4.3.0\bin\x64\R.exe`

### Spyder: Kernel Connection Issues
```bash
# Reinstall spyder-kernels
pip install --upgrade spyder-kernels
```

### LaTeX: Missing Packages
```bash
# MiKTeX (Windows)
miktex packages install <package-name>

# TeX Live (macOS/Linux)
sudo tlmgr install <package-name>

# TinyTeX (All platforms, in R)
tinytex::tlmgr_install('<package-name>')
```

---

## Quick Reference

| IDE | Windows | macOS | Linux |
|-----|---------|-------|-------|
| **VS Code** | `choco install vscode` | `brew install --cask visual-studio-code` | `apt install code` |
| **RStudio** | `choco install r.studio` | `brew install --cask rstudio` | Download .deb/.rpm |
| **Spyder** | `pip install spyder` | `brew install --cask spyder` | `apt install spyder` |
| **LaTeX** | `choco install miktex` | `brew install --cask basictex` | `apt install texlive` |

---

**For more help, see the main [INSTALL.md](INSTALL.md) guide.**
