# ==============================================================================
# UNICEF Analytics Environment Setup - Makefile
# ==============================================================================
# Automated installation and management of analytics environment
# Compatible with: Windows, macOS, Linux
# ==============================================================================

.PHONY: help setup check clean test info

# Default target
.DEFAULT_GOAL := help

# Configuration
SHELL := /bin/bash
R := Rscript
PYTHON := python
PIP := pip
STATA := stata-mp

# Directories
INSTALL_DIR := $(shell pwd)
LOGS_DIR := $(INSTALL_DIR)/logs
VENV_DIR := $(INSTALL_DIR)/venv
BACKUP_DIR := $(INSTALL_DIR)/backups

# Files
R_REQUIREMENTS := requirements-r.txt
PYTHON_REQUIREMENTS := requirements-python.txt
PYTHON_BASE := requirements-python.base.txt
PYTHON_CONSTRAINTS := constraints.txt
STATA_REQUIREMENTS := requirements-stata.do
R_INSTALLER := install-r-packages.R
PYTHON_INSTALLER := install-python-packages.py

# Virtual env executables (cross-platform)
ifeq ($(OS),Windows_NT)
VENV_PYTHON := $(VENV_DIR)/Scripts/python.exe
VENV_PIP := $(VENV_DIR)/Scripts/pip.exe
else
VENV_PYTHON := $(VENV_DIR)/bin/python
VENV_PIP := $(VENV_DIR)/bin/pip
endif

# Colors (for Unix-like systems)
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;36m
NC := \033[0m # No Color

# ==============================================================================
# Help
# ==============================================================================

help: ## Show this help message
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  UNICEF Analytics Environment Setup"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "Available commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  $(BLUE)%-25s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "Quick start:"
	@echo "  make setup              # Complete installation"
	@echo "  make check              # Verify installation"
	@echo "  make test               # Run tests"
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# ==============================================================================
# Main Setup Targets
# ==============================================================================

setup: check-prereqs install-all verify ## Complete environment setup
	@echo "$(GREEN)✓ Setup complete!$(NC)"
	@echo ""
	@echo "Next steps:"
	@echo "  1. Run 'make check' to verify installation"
	@echo "  2. See 'make help' for available commands"
	@echo "  3. Configure user settings in ~/.config/user_config.yml"

install-all: create-dirs install-r install-python install-stata ## Install all packages
	@echo "$(GREEN)✓ All packages installed$(NC)"

check: check-prereqs check-r check-python check-stata check-tools ## Verify all dependencies
	@echo ""
	@echo "$(GREEN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(GREEN)  ✓ All checks passed!$(NC)"
	@echo "$(GREEN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"

# ==============================================================================
# Prerequisites Checks
# ==============================================================================

check-prereqs: ## Check system prerequisites
	@echo "$(BLUE)🔍 Checking system prerequisites...$(NC)"
	@$(MAKE) check-os
	@$(MAKE) check-git
	@echo "$(GREEN)✓ Prerequisites satisfied$(NC)"

check-os: ## Detect operating system
	@echo "  Operating System: $$(uname -s 2>/dev/null || echo Windows)"
	@echo "  Architecture: $$(uname -m 2>/dev/null || echo x86_64)"

check-git: ## Check Git installation
	@echo -n "  Git: "
	@command -v git >/dev/null 2>&1 && \
		echo "$(GREEN)✓ $$(git --version)$(NC)" || \
		echo "$(RED)✗ Not found - please install Git$(NC)"

# ==============================================================================
# R Installation
# ==============================================================================

install-r: check-r ## Install all R packages
	@echo "$(BLUE)📊 Installing R packages...$(NC)"
	@$(R) $(R_INSTALLER) 2>&1 | tee $(LOGS_DIR)/r-install.log
	@echo "$(GREEN)✓ R packages installed$(NC)"

check-r: ## Check R installation
	@echo -n "  R: "
	@command -v Rscript >/dev/null 2>&1 && \
		($(R) --version | head -n 1 && echo "$(GREEN)✓$(NC)") || \
		echo "$(RED)✗ Not found - please install R (>= 4.0.0)$(NC)"

test-r: ## Test R environment
	@echo "$(BLUE)🧪 Testing R environment...$(NC)"
	@$(R) -e "testthat::test_dir('tests/testthat')"

update-r: ## Update all R packages
	@echo "$(BLUE)🔄 Updating R packages...$(NC)"
	@$(R) -e "update.packages(ask = FALSE, checkBuilt = TRUE)"

list-r: ## List installed R packages
	@$(R) -e "installed.packages()[,c('Package', 'Version')] |> as.data.frame() |> print()"

# ==============================================================================
# Python Installation
# ==============================================================================

install-python: check-python create-venv ## Install Python packages (supports EXTRAS="geo ml viz ...")
	@echo "$(BLUE)🐍 Installing Python packages...$(NC)"
	@PIP_CMD=$$( [ -x "$(VENV_PIP)" ] && echo "$(VENV_PIP)" || echo "$(PIP)" ); \
	 echo "Using pip: $$PIP_CMD"; \
	 LOG_FILE="$(LOGS_DIR)/python-install.log"; \
	 mkdir -p "$(LOGS_DIR)"; \
	 if [ -f "$(PYTHON_BASE)" ]; then \
	   if [ -s "$(PYTHON_CONSTRAINTS)" ]; then \
	     $$PIP_CMD install -r "$(PYTHON_BASE)" -c "$(PYTHON_CONSTRAINTS)" 2>&1 | tee "$$LOG_FILE"; \
	   else \
	     $$PIP_CMD install -r "$(PYTHON_BASE)" 2>&1 | tee "$$LOG_FILE"; \
	   fi; \
	 fi; \
	 for extra in $(EXTRAS); do \
	   FILE="requirements-python.$${extra}.txt"; \
	   if [ -f "$$FILE" ]; then \
	     echo "Installing extra: $$FILE"; \
	     if [ -s "$(PYTHON_CONSTRAINTS)" ]; then \
	       $$PIP_CMD install -r "$$FILE" -c "$(PYTHON_CONSTRAINTS)" 2>&1 | tee -a "$$LOG_FILE"; \
	     else \
	       $$PIP_CMD install -r "$$FILE" 2>&1 | tee -a "$$LOG_FILE"; \
	     fi; \
	   else \
	     echo "$(YELLOW)⚠ Extra not found: $$FILE$(NC)"; \
	   fi; \
	 done; \
	 if [ -f "$(PYTHON_REQUIREMENTS)" ]; then \
	   echo "Installing legacy requirements: $(PYTHON_REQUIREMENTS)"; \
	   if [ -s "$(PYTHON_CONSTRAINTS)" ]; then \
	     $$PIP_CMD install -r "$(PYTHON_REQUIREMENTS)" -c "$(PYTHON_CONSTRAINTS)" 2>&1 | tee -a "$$LOG_FILE"; \
	   else \
	     $$PIP_CMD install -r "$(PYTHON_REQUIREMENTS)" 2>&1 | tee -a "$$LOG_FILE"; \
	   fi; \
	 fi
	@echo "$(GREEN)✓ Python packages installed$(NC)"

check-python: ## Check Python installation
	@echo -n "  Python: "
	@command -v python >/dev/null 2>&1 && \
		(python --version && echo "$(GREEN)✓$(NC)") || \
		echo "$(RED)✗ Not found - please install Python (>= 3.9)$(NC)"
	@echo -n "  pip: "
	@command -v pip >/dev/null 2>&1 && \
		(pip --version && echo "$(GREEN)✓$(NC)") || \
		echo "$(RED)✗ Not found$(NC)"

create-venv: ## Create Python virtual environment
	@if [ ! -d "$(VENV_DIR)" ]; then \
		echo "$(BLUE)📦 Creating virtual environment...$(NC)"; \
		$(PYTHON) -m venv $(VENV_DIR); \
		echo "$(GREEN)✓ Virtual environment created at $(VENV_DIR)$(NC)"; \
		echo "  Activate with: source $(VENV_DIR)/bin/activate"; \
	else \
		echo "$(YELLOW)⚠ Virtual environment already exists$(NC)"; \
	fi

activate-venv: ## Show command to activate virtual environment
	@echo "To activate the virtual environment, run:"
	@echo "  Windows: $(VENV_DIR)\\Scripts\\activate"
	@echo "  Unix/Mac: source $(VENV_DIR)/bin/activate"

test-python: ## Test Python environment
	@echo "$(BLUE)🧪 Testing Python environment...$(NC)"
	@pytest tests/python/ -v

update-python: ## Update all Python packages
	@echo "$(BLUE)🔄 Updating Python packages...$(NC)"
	@$(PIP) list --outdated --format=freeze | cut -d = -f 1 | xargs -n1 $(PIP) install -U

list-python: ## List installed Python packages
	@$(PIP) list

# ==============================================================================
# Stata Installation
# ==============================================================================

install-stata: check-stata ## Install Stata packages
	@echo "$(BLUE)📈 Installing Stata packages...$(NC)"
	@$(STATA) -b do $(STATA_REQUIREMENTS) 2>&1 | tee $(LOGS_DIR)/stata-install.log || \
		echo "$(YELLOW)⚠ Stata not available - skipping Stata packages$(NC)"

check-stata: ## Check Stata installation
	@echo -n "  Stata: "
	@command -v stata >/dev/null 2>&1 && \
		echo "$(GREEN)✓ Found$(NC)" || \
		command -v stata-mp >/dev/null 2>&1 && \
		echo "$(GREEN)✓ Found (MP)$(NC)" || \
		echo "$(YELLOW)⚠ Not found (optional)$(NC)"

# ==============================================================================
# Additional Tools
# ==============================================================================

check-tools: check-pandoc check-quarto check-jupyter ## Check additional tools

check-pandoc: ## Check Pandoc installation
	@echo -n "  Pandoc: "
	@command -v pandoc >/dev/null 2>&1 && \
		(pandoc --version | head -n 1 && echo "$(GREEN)✓$(NC)") || \
		echo "$(YELLOW)⚠ Not found - install for document conversion$(NC)"

check-quarto: ## Check Quarto installation
	@echo -n "  Quarto: "
	@command -v quarto >/dev/null 2>&1 && \
		(quarto --version && echo "$(GREEN)✓$(NC)") || \
		echo "$(YELLOW)⚠ Not found - install for scientific publishing$(NC)"

check-jupyter: ## Check Jupyter installation
	@echo -n "  Jupyter: "
	@command -v jupyter >/dev/null 2>&1 && \
		(jupyter --version | head -n 1 && echo "$(GREEN)✓$(NC)") || \
		echo "$(YELLOW)⚠ Not found - will be installed with Python packages$(NC)"

install-pandoc: ## Guidance to install Pandoc
	@echo "$(BLUE)📄 Pandoc installation guidance...$(NC)"
	@echo "Pandoc is a system dependency and is not installed from CRAN."
	@echo "Please install Pandoc from: https://pandoc.org/installing.html"
	@echo "Then verify with: pandoc --version"

install-quarto: ## Download Quarto installer
	@echo "$(BLUE)📚 Please install Quarto manually from:$(NC)"
	@echo "  https://quarto.org/docs/get-started/"

install-radian: ## Install radian (enhanced R console)
	@echo "$(BLUE)🎨 Installing radian...$(NC)"
	@$(PIP) install -U radian

# ==============================================================================
# Testing & Validation
# ==============================================================================

test: test-r test-python ## Run all tests
	@echo "$(GREEN)✓ All tests passed$(NC)"

validate: ## Validate installation
	@echo "$(BLUE)🔍 Validating installation...$(NC)"
	@$(MAKE) check
	@$(MAKE) test
	@echo "$(GREEN)✓ Validation complete$(NC)"

diagnose: ## Run diagnostic tests
	@echo "$(BLUE)🔬 Running diagnostics...$(NC)"
	@$(R) -e "sessionInfo()" > $(LOGS_DIR)/r-diagnostics.txt
	@$(PYTHON) -c "import sys; import pip; print(f'Python: {sys.version}'); print('\\nPackages:'); pip.main(['list'])" > $(LOGS_DIR)/python-diagnostics.txt
	@$(MAKE) info > $(LOGS_DIR)/system-diagnostics.txt
	@echo "$(GREEN)✓ Diagnostics saved to $(LOGS_DIR)/$(NC)"
	@cat $(LOGS_DIR)/system-diagnostics.txt

# ==============================================================================
# Information & Documentation
# ==============================================================================

info: ## Show system information
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  System Information"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "Operating System:"
	@uname -a 2>/dev/null || systeminfo | findstr /C:"OS Name" /C:"OS Version"
	@echo ""
	@echo "Software Versions:"
	@echo -n "  R: " && $(R) --version 2>/dev/null | head -n 1 || echo "Not installed"
	@echo -n "  Python: " && $(PYTHON) --version 2>/dev/null || echo "Not installed"
	@echo -n "  Git: " && git --version 2>/dev/null || echo "Not installed"
	@echo -n "  Pandoc: " && pandoc --version 2>/dev/null | head -n 1 || echo "Not installed"
	@echo -n "  Quarto: " && quarto --version 2>/dev/null || echo "Not installed"
	@echo ""
	@echo "Installation Directory: $(INSTALL_DIR)"
	@echo "Virtual Environment: $(VENV_DIR)"
	@echo "Logs Directory: $(LOGS_DIR)"
	@echo ""

docs: ## Open documentation
	@echo "$(BLUE)📖 Opening documentation...$(NC)"
	@if command -v xdg-open >/dev/null 2>&1; then \
		xdg-open README.md; \
	elif command -v open >/dev/null 2>&1; then \
		open README.md; \
	else \
		echo "Please open README.md manually"; \
	fi

list-repos: ## List compatible repositories
	@echo "$(BLUE)📚 Compatible UNICEF repositories:$(NC)"
	@cat PACKAGE-LIST.md | grep -A 100 "Repository Compatibility"

# ==============================================================================
# Maintenance
# ==============================================================================

create-dirs: ## Create necessary directories
	@mkdir -p $(LOGS_DIR)
	@mkdir -p $(BACKUP_DIR)
	@echo "$(GREEN)✓ Directories created$(NC)"

clean: ## Remove temporary files and logs
	@echo "$(BLUE)🧹 Cleaning temporary files...$(NC)"
	@rm -rf $(LOGS_DIR)/*.log
	@rm -rf __pycache__
	@rm -rf .pytest_cache
	@rm -rf *.pyc
	@$(R) -e "unlink(list.files(pattern='^\\.Rhistory$$|^\\.RData$$'), recursive = TRUE)"
	@echo "$(GREEN)✓ Cleanup complete$(NC)"

clean-all: clean ## Deep clean including virtual environment
	@echo "$(YELLOW)⚠ This will remove the virtual environment$(NC)"
	@read -p "Continue? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		rm -rf $(VENV_DIR); \
		echo "$(GREEN)✓ Virtual environment removed$(NC)"; \
	fi

update-all: update-r update-python ## Update all packages
	@echo "$(GREEN)✓ All packages updated$(NC)"

backup: ## Create backup of configuration
	@echo "$(BLUE)💾 Creating backup...$(NC)"
	@mkdir -p $(BACKUP_DIR)
	@cp -r ~/.config/user_config.yml $(BACKUP_DIR)/user_config_$$(date +%Y%m%d_%H%M%S).yml 2>/dev/null || \
		echo "$(YELLOW)⚠ No user config found$(NC)"
	@echo "$(GREEN)✓ Backup saved to $(BACKUP_DIR)$(NC)"

restore: ## Restore configuration from backup
	@echo "$(BLUE)♻️  Available backups:$(NC)"
	@ls -1 $(BACKUP_DIR)
	@read -p "Enter backup filename to restore: " filename; \
	cp $(BACKUP_DIR)/$$filename ~/.config/user_config.yml
	@echo "$(GREEN)✓ Configuration restored$(NC)"

# ==============================================================================
# Verification & Reporting
# ==============================================================================

verify: ## Comprehensive verification
	@echo "$(BLUE)🔍 Running comprehensive verification...$(NC)"
	@$(MAKE) check
	@$(MAKE) test
	@$(MAKE) diagnose
	@echo ""
	@echo "$(GREEN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(GREEN)  ✓ Verification complete - System ready for analysis!$(NC)"
	@echo "$(GREEN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"

report: ## Generate installation report
	@echo "$(BLUE)📊 Generating installation report...$(NC)"
	@echo "UNICEF Analytics Environment - Installation Report" > $(LOGS_DIR)/installation-report.txt
	@echo "Generated: $$(date)" >> $(LOGS_DIR)/installation-report.txt
	@echo "" >> $(LOGS_DIR)/installation-report.txt
	@$(MAKE) info >> $(LOGS_DIR)/installation-report.txt
	@echo "" >> $(LOGS_DIR)/installation-report.txt
	@echo "R Packages:" >> $(LOGS_DIR)/installation-report.txt
	@$(R) -e "cat(paste(installed.packages()[,'Package'], installed.packages()[,'Version'], sep=': ', collapse='\\n'))" >> $(LOGS_DIR)/installation-report.txt
	@echo "" >> $(LOGS_DIR)/installation-report.txt
	@echo "Python Packages:" >> $(LOGS_DIR)/installation-report.txt
	@$(PIP) list >> $(LOGS_DIR)/installation-report.txt
	@echo "$(GREEN)✓ Report saved to $(LOGS_DIR)/installation-report.txt$(NC)"
	@cat $(LOGS_DIR)/installation-report.txt

# ==============================================================================
# Development Helpers
# ==============================================================================

shell-r: ## Open R console
	@$(R)

shell-python: ## Open Python console
	@$(PYTHON)

shell-stata: ## Open Stata console
	@$(STATA)

notebook: ## Start Jupyter notebook
	@jupyter notebook

lab: ## Start Jupyter lab
	@jupyter lab

rstudio: ## Open RStudio (if installed)
	@command -v rstudio >/dev/null 2>&1 && rstudio || echo "$(YELLOW)RStudio not found$(NC)"

# ==============================================================================
# IDE and Editor Installation
# ==============================================================================

install-ides: ## Install all IDEs and editors
	@echo "$(BLUE)📦 Installing development environments...$(NC)"
	@$(MAKE) install-rtools
	@$(MAKE) install-vscode
	@$(MAKE) install-rstudio
	@$(MAKE) install-spyder
	@$(MAKE) install-r-devtools
	@$(MAKE) install-latex
	@echo "$(GREEN)✓ All IDEs installed$(NC)"
	@echo ""
	@echo "Installed:"
	@echo "  - Rtools (Windows build tools)"
	@echo "  - VS Code"
	@echo "  - RStudio"
	@echo "  - Spyder"
	@echo "  - R development tools (radian, languageserver)"
	@echo "  - LaTeX distribution"
	@echo ""
	@echo "See install-ides.md for configuration"

install-rtools: ## Install Rtools (Windows only)
	@echo "$(BLUE)🔧 Installing Rtools...$(NC)"
ifeq ($(OS),Windows_NT)
	@command -v choco >/dev/null 2>&1 && \
		(choco install rtools -y && echo "$(GREEN)✓ Rtools installed via Chocolatey$(NC)") || \
		echo "$(YELLOW)⚠ Chocolatey not found. Download from: https://cran.r-project.org/bin/windows/Rtools/$(NC)"
	@echo ""
	@echo "Verifying Rtools installation..."
	@$(R) -e "pkgbuild::check_build_tools(debug = TRUE)" || \
		echo "$(YELLOW)⚠ Rtools verification failed. You may need to restart your terminal.$(NC)"
else
	@echo "$(BLUE)ℹ Rtools is only needed on Windows. Skipping on $(shell uname).$(NC)"
endif

install-r-devtools: check-r ## Install R development tools (radian, languageserver)
	@echo "$(BLUE)🛠️  Installing R development tools...$(NC)"
	@echo "Installing radian (enhanced R console)..."
	@$(PIP) install radian || echo "$(YELLOW)⚠ radian installation failed$(NC)"
	@echo "Installing R languageserver..."
	@$(R) -e "if (!requireNamespace('languageserver', quietly = TRUE)) install.packages('languageserver')" || \
		echo "$(YELLOW)⚠ languageserver installation failed$(NC)"
	@echo "Installing httpgd (graphics device)..."
	@$(R) -e "if (!requireNamespace('httpgd', quietly = TRUE)) install.packages('httpgd')" || \
		echo "$(YELLOW)⚠ httpgd installation failed$(NC)"
	@echo "$(GREEN)✓ R development tools installed$(NC)"
	@echo ""
	@echo "Try: radian  # for enhanced R console"

install-vscode: ## Install VS Code
	@echo "$(BLUE)📝 Installing VS Code...$(NC)"
ifeq ($(OS),Windows_NT)
	@command -v choco >/dev/null 2>&1 && \
		(choco install vscode -y && echo "$(GREEN)✓ VS Code installed via Chocolatey$(NC)") || \
		echo "$(YELLOW)⚠ Chocolatey not found. Download from: https://code.visualstudio.com/$(NC)"
else ifeq ($(shell uname),Darwin)
	@command -v brew >/dev/null 2>&1 && \
		(brew install --cask visual-studio-code && echo "$(GREEN)✓ VS Code installed via Homebrew$(NC)") || \
		echo "$(YELLOW)⚠ Homebrew not found. Download from: https://code.visualstudio.com/$(NC)"
else
	@if command -v apt-get >/dev/null 2>&1; then \
		sudo apt install code -y && echo "$(GREEN)✓ VS Code installed$(NC)"; \
	elif command -v dnf >/dev/null 2>&1; then \
		sudo dnf install code -y && echo "$(GREEN)✓ VS Code installed$(NC)"; \
	else \
		echo "$(YELLOW)⚠ Package manager not found. Download from: https://code.visualstudio.com/$(NC)"; \
	fi
endif

install-vscode-extensions: install-vscode ## Install recommended VS Code extensions
	@echo "$(BLUE)📦 Installing VS Code extensions...$(NC)"
	@code --install-extension REditorSupport.r || true
	@code --install-extension ms-python.python || true
	@code --install-extension ms-toolsai.jupyter || true
	@code --install-extension kylebarron.stata-enhanced || true
	@code --install-extension yzhang.markdown-all-in-one || true
	@code --install-extension redhat.vscode-yaml || true
	@echo "$(GREEN)✓ VS Code extensions installed$(NC)"

install-rstudio: ## Install RStudio
	@echo "$(BLUE)📊 Installing RStudio...$(NC)"
ifeq ($(OS),Windows_NT)
	@command -v choco >/dev/null 2>&1 && \
		(choco install r.studio -y && echo "$(GREEN)✓ RStudio installed via Chocolatey$(NC)") || \
		echo "$(YELLOW)⚠ Chocolatey not found. Download from: https://posit.co/download/rstudio-desktop/$(NC)"
else ifeq ($(shell uname),Darwin)
	@command -v brew >/dev/null 2>&1 && \
		(brew install --cask rstudio && echo "$(GREEN)✓ RStudio installed via Homebrew$(NC)") || \
		echo "$(YELLOW)⚠ Homebrew not found. Download from: https://posit.co/download/rstudio-desktop/$(NC)"
else
	@echo "$(YELLOW)⚠ Please download RStudio from: https://posit.co/download/rstudio-desktop/$(NC)"
	@echo "   Then install the .deb or .rpm package for your distribution"
endif

install-spyder: check-python ## Install Spyder IDE
	@echo "$(BLUE)🕷️  Installing Spyder...$(NC)"
ifeq ($(OS),Windows_NT)
	@command -v choco >/dev/null 2>&1 && \
		(choco install spyder -y && echo "$(GREEN)✓ Spyder installed via Chocolatey$(NC)") || \
		($(PIP) install spyder && echo "$(GREEN)✓ Spyder installed via pip$(NC)")
else ifeq ($(shell uname),Darwin)
	@command -v brew >/dev/null 2>&1 && \
		(brew install --cask spyder && echo "$(GREEN)✓ Spyder installed via Homebrew$(NC)") || \
		($(PIP) install spyder && echo "$(GREEN)✓ Spyder installed via pip$(NC)")
else
	@if command -v apt-get >/dev/null 2>&1; then \
		sudo apt install spyder -y && echo "$(GREEN)✓ Spyder installed$(NC)" || \
		($(PIP) install spyder && echo "$(GREEN)✓ Spyder installed via pip$(NC)"); \
	else \
		$(PIP) install spyder && echo "$(GREEN)✓ Spyder installed via pip$(NC)"; \
	fi
endif

install-latex: ## Install LaTeX distribution
	@echo "$(BLUE)📄 Installing LaTeX...$(NC)"
ifeq ($(OS),Windows_NT)
	@command -v choco >/dev/null 2>&1 && \
		(choco install miktex -y && echo "$(GREEN)✓ MiKTeX installed via Chocolatey$(NC)") || \
		echo "$(YELLOW)⚠ Chocolatey not found. Download MiKTeX from: https://miktex.org/download$(NC)"
else ifeq ($(shell uname),Darwin)
	@command -v brew >/dev/null 2>&1 && \
		(brew install --cask basictex && echo "$(GREEN)✓ BasicTeX installed via Homebrew$(NC)") || \
		echo "$(YELLOW)⚠ Homebrew not found. Download MacTeX from: https://tug.org/mactex/$(NC)"
else
	@if command -v apt-get >/dev/null 2>&1; then \
		sudo apt install texlive-latex-recommended texlive-latex-extra -y && \
		echo "$(GREEN)✓ TeX Live installed$(NC)"; \
	elif command -v dnf >/dev/null 2>&1; then \
		sudo dnf install texlive -y && echo "$(GREEN)✓ TeX Live installed$(NC)"; \
	else \
		echo "$(YELLOW)⚠ Package manager not found. Install TeX Live manually$(NC)"; \
	fi
endif

install-tinytex: check-r ## Install TinyTeX (lightweight LaTeX via R)
	@echo "$(BLUE)📄 Installing TinyTeX...$(NC)"
	@$(R) -e "if (!requireNamespace('tinytex', quietly = TRUE)) install.packages('tinytex'); tinytex::install_tinytex()"
	@echo "$(GREEN)✓ TinyTeX installed$(NC)"

check-ides: ## Check which IDEs are installed
	@echo "$(BLUE)🔍 Checking installed IDEs...$(NC)"
	@echo ""
	@echo -n "  Rtools:   "
ifeq ($(OS),Windows_NT)
	@$(R) -e "cat(ifelse(pkgbuild::has_build_tools(debug = FALSE), '✓ Installed', '✗ Not found'))" 2>/dev/null || echo "$(YELLOW)✗ Not found$(NC)"
else
	@echo "$(BLUE)N/A (Unix/macOS)$(NC)"
endif
	@echo -n "  VS Code:  "
	@command -v code >/dev/null 2>&1 && echo "$(GREEN)✓ Installed$(NC)" || echo "$(YELLOW)✗ Not found$(NC)"
	@echo -n "  RStudio:  "
	@command -v rstudio >/dev/null 2>&1 && echo "$(GREEN)✓ Installed$(NC)" || echo "$(YELLOW)✗ Not found$(NC)"
	@echo -n "  Spyder:   "
	@command -v spyder >/dev/null 2>&1 && echo "$(GREEN)✓ Installed$(NC)" || \
		($(PYTHON) -c "import spyder" 2>/dev/null && echo "$(GREEN)✓ Installed (Python)$(NC)" || echo "$(YELLOW)✗ Not found$(NC)")
	@echo -n "  LaTeX:    "
	@command -v pdflatex >/dev/null 2>&1 && echo "$(GREEN)✓ Installed$(NC)" || echo "$(YELLOW)✗ Not found$(NC)"
	@echo ""
	@echo "$(BLUE)🛠️  R Development Tools:$(NC)"
	@echo -n "  radian:   "
	@command -v radian >/dev/null 2>&1 && echo "$(GREEN)✓ Installed$(NC)" || echo "$(YELLOW)✗ Not found$(NC)"
	@echo -n "  languageserver: "
	@$(R) -e "cat(ifelse(requireNamespace('languageserver', quietly = TRUE), '✓ Installed', '✗ Not found'))" 2>/dev/null || echo "$(YELLOW)✗ Not found$(NC)"
	@echo -n "  httpgd:   "
	@$(R) -e "cat(ifelse(requireNamespace('httpgd', quietly = TRUE), '✓ Installed', '✗ Not found'))" 2>/dev/null || echo "$(YELLOW)✗ Not found$(NC)"
	@echo ""

# ==============================================================================
# End of Makefile
# ==============================================================================
