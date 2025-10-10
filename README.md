# UNICEF Analytics Environment Setup

**One-command installation of all core software and dependencies for UNICEF data analytics and research reproduction.**

## 🎯 Purpose

This repository provides automated setup for the complete UNICEF analytics environment, enabling researchers and analysts to quickly configure their local machines with all required free and open-source software needed to reproduce analysis across UNICEF's research repositories.

## 📦 What Gets Installed

### Core Software
- **R** (>= 4.0.0) - Statistical computing
- **Python** (>= 3.9) - Data science and automation
- **Stata** (if available) - Econometric analysis
- **Pandoc** (>= 2.11) - Document conversion
- **Quarto** (>= 1.3) - Scientific publishing
- **Git** - Version control

### Development Tools
- **VS Code** (recommended) - Integrated development environment
- **radian** - Enhanced R console
- **Jupyter** - Interactive notebooks
- **RStudio** (optional) - R-specific IDE

### R Packages (90+ packages)
Core data manipulation, visualization, statistical analysis, external data APIs, reporting, and quality tools.

### Python Packages (100+ packages)
Data science stack, API clients, testing frameworks, code quality tools, and reporting utilities.

### Stata Packages (60+ packages)
User-written statistical and data management utilities.

### IDEs & Editors
Automated installation helpers for RStudio, VS Code, Spyder, and LaTeX distributions.

## 🚀 Quick Start

### Windows
```powershell
# Clone repository
git clone https://github.com/yourusername/unicef-analytics-setup
cd unicef-analytics-setup

# Run automated setup
.\install-windows.bat

# Or use Make
make setup
```

### macOS/Linux
```bash
# Clone repository
git clone https://github.com/yourusername/unicef-analytics-setup
cd unicef-analytics-setup

# Make installer executable
chmod +x install-unix.sh

# Run automated setup
./install-unix.sh

# Or use Make
make setup
```

## 📋 Manual Installation

If you prefer step-by-step installation or need to customize:

### Step 1: Install Core Software
See [INSTALL.md](INSTALL.md) for platform-specific instructions.

### Step 2: Install R Packages
```r
# In R console
source("install-r-packages.R")
```

### Step 3: Install Python Packages
```bash
pip install -r requirements-python.txt
```

### Step 4: Install Stata Packages (optional)
```stata
# In Stata console
do requirements-stata.do
```

### Step 5: Verify Installation
```bash
make check
```

## 🛠️ Makefile Commands

The repository includes a comprehensive Makefile with 40+ automation commands:

### Setup & Installation
```bash
make setup              # Complete environment setup
make check              # Verify all dependencies
make install-r          # Install R packages only
make install-python     # Install Python packages only
make install-stata      # Install Stata packages only
```

### Environment Management
```bash
make create-venv        # Create Python virtual environment
make activate-venv      # Show activation command
make update-all         # Update all packages
```

### Testing & Validation
```bash
make test               # Run test suite
make test-r             # Test R environment
make test-python        # Test Python environment
make validate           # Validate installation
```

### Documentation
```bash
make help               # Show all commands
make docs               # Open documentation
make info               # Show system information
```

### Maintenance
```bash
make clean              # Clean temporary files
make clean-all          # Deep clean (including venv)
make backup             # Create configuration backup
```

## 📚 Repository Compatibility

This setup enables reproduction of analysis from:

### Education & Learning
- `EduAnalytics-Unicef` - Education data harmonization
- `LearningPoverty-Production` - Learning poverty metrics
- `GLAD-Analytics` - Global Learning Assessment Database
- `benchmark-edu` - Educational benchmarking

### Child Wellbeing & Development
- `ChildWellbeing` - Child life-course index
- `MICS-analytics` - MICS survey analysis
- `health-equity` - Health equity indicators
- `child-life-course-index` - Multi-dimensional child indices

### Data Warehouse & Production
- `DW-Production` - UNICEF data warehouse pipeline
- `PROD-SDG-REP-2025` - SDG reporting production
- `SDGnetAnalysis` - SDG network analysis

### Specialized Analytics
- `ccri` - Climate-related child risk indices
- `fiscal_capacity_package` - Fiscal capacity analysis
- `wb-api-repo` - World Bank API tools
- `oda_baselines_repo` - ODA baseline extraction

## 🔧 Configuration

### User Configuration
Create a user configuration file:

```bash
# Windows
copy _config_template\user_config.yml %USERPROFILE%\.config\user_config.yml

# macOS/Linux
cp _config_template/user_config.yml ~/.config/user_config.yml
```

Edit `~/.config/user_config.yml`:
```yaml
your_username:
  githubFolder: "/path/to/GitHub"
  teamsRoot: "/path/to/Teams"  # If applicable
  workingDir: "/path/to/working"
```

### Environment Variables
The setup automatically configures:
- R library path
- Python virtual environment
- PATH additions for tools
- Git configuration helpers

## 📖 Documentation

- **[INSTALL.md](INSTALL.md)** - Detailed installation guide
- **[REQUIREMENTS.md](REQUIREMENTS.md)** - System requirements
- **[MAKEFILE-GUIDE.md](MAKEFILE-GUIDE.md)** - Makefile command reference
- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Common issues and solutions
- **[PACKAGE-LIST.md](PACKAGE-LIST.md)** - Complete package inventory

## 🆘 Support

### Common Issues

**R packages fail to install:**
```bash
make install-r BINARY=TRUE  # Use binary packages on Windows
```

**Python version conflicts:**
```bash
make create-venv PYTHON=python3.9  # Specify Python version
```

**Stata not in PATH:**
```bash
make check-stata  # Verify Stata installation
```

### Getting Help
1. Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
2. Run `make diagnose` for system diagnostics
3. Review installation logs in `logs/`
4. Open an issue on GitHub

## 🤝 Contributing

Contributions welcome! Please:
1. Test changes on your platform
2. Update documentation
3. Add to CHANGELOG.md
4. Submit pull request

## 📄 License

MIT License - See [LICENSE](LICENSE)

## ✨ Credits

Developed by the UNICEF Data & Analytics Section to support reproducible research and collaborative analytics across the organization.

---

**Last Updated:** October 2025  
**Maintained by:** UNICEF Data & Analytics Section  
**Repository:** [github.com/unicef/analytics-setup](https://github.com/unicef/analytics-setup)
