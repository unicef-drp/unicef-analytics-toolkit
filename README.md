# UNICEF Analytics Toolkit

[![Test Installation](https://github.com/unicef/analytics-toolkit/actions/workflows/test-installation.yml/badge.svg)](https://github.com/unicef/analytics-toolkit/actions/workflows/test-installation.yml)
[![Lint and Quality](https://github.com/unicef/analytics-toolkit/actions/workflows/lint.yml/badge.svg)](https://github.com/unicef/analytics-toolkit/actions/workflows/lint.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**Comprehensive toolkit for UNICEF data analytics: automated environment setup, quality assurance utilities, and reproducible research tools.**

---

**Developed by**: [UNICEF Division of Data, Analytics, Planning and Monitoring (DAPM)](https://data.unicef.org/)  
**Maintained by**: Chief Statistician Office, UNICEF  
**Contact**: [data@unicef.org](mailto:data@unicef.org)

---

## 🎯 Purpose

The UNICEF Analytics Toolkit provides:

1. **Automated Environment Setup** - One-command installation of R, Python, Stata, and dependencies
2. **Quality Assurance Utilities** - Data validation, metadata management, and documentation generation
3. **Reproducible Workflows** - Standard project templates and helper functions
4. **Multi-language Support** - R, Python, and Stata utilities for cross-platform analytics

Enabling UNICEF researchers and analysts to quickly configure their machines and work with standardized, high-quality analytical workflows.

**Inspired by**: World Bank's [EduAnalyticsToolkit](https://github.com/worldbank/EduAnalyticsToolkit) - adapted for UNICEF's multi-language, cross-sectoral analytics ecosystem.

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

## � Testing

### Run All Tests

```bash
# R tests
Rscript -e "testthat::test_dir('tests/testthat')"

# Python tests
pytest tests/python/ -v

# Or use make
make test
```

### Test Coverage

The test suite covers:
- **Installation validation** - Verify all critical packages installed
- **Configuration loading** - Test YAML config parsing
- **Path detection** - Validate project structure
- **Package functionality** - Basic operations work correctly

See `tests/` directory for complete test suite.

## 🔧 Development

### Setting Up Development Environment

```bash
# Clone repository
git clone https://github.com/unicef/analytics-toolkit
cd analytics-toolkit

# Install in development mode
make setup

# Run tests
make test

# Run linting
make lint
```

### Pre-commit Hooks (Optional)

```bash
pip install pre-commit
pre-commit install
```

## �🤝 Contributing

Contributions welcome! Please:

1. Test changes on your platform
2. Update documentation
3. Add to CHANGELOG.md
4. Submit pull request

## 📄 License

MIT License - See [LICENSE](LICENSE)

## ✨ Credits

**Developed by**: [UNICEF Division of Data, Analytics, Planning and Monitoring (DAPM)](https://data.unicef.org/)  
**Maintained by**: Chief Statistician Office, UNICEF  
**Contact**: [data@unicef.org](mailto:data@unicef.org)

### Acknowledgments

- **World Bank EduAnalytics Team** - [EduAnalyticsToolkit](https://github.com/worldbank/EduAnalyticsToolkit) provided inspiration for data quality and metadata management approaches
- **UNICEF Data and Analytics teams** worldwide for requirements, feedback, and testing
- **Open-source community** - Package developers and maintainers whose tools make this possible
- **rOpenSci** - Contribution guidelines and best practices

### Related UNICEF Resources

- [UNICEF Data Portal](https://data.unicef.org/) - Official statistics and data visualization
- [UNICEF Data Warehouse](https://sdmx.data.unicef.org/) - Statistical Data and Metadata eXchange
- [MICS Programme](https://mics.unicef.org/) - Multiple Indicator Cluster Surveys
- [UNICEF GitHub](https://github.com/unicef) - Open-source projects and tools

### Inspiration and Collaboration

This toolkit draws inspiration from similar initiatives:
- [World Bank EduAnalyticsToolkit](https://github.com/worldbank/EduAnalyticsToolkit) - Stata toolkit for education analytics
- [World Bank DIME Analytics](https://github.com/worldbank/dime-analytics) - Impact evaluation tools
- [WHO Analytics Tools](https://www.who.int/data/analytics-tools) - Health data analysis resources

---

**Version**: 2.0  
**Last Updated**: 2025-10-10  
**License**: MIT  
**Repository**: [github.com/unicef/analytics-toolkit](https://github.com/unicef/analytics-toolkit)

---

<div align="center">

**For every child, data-driven insights**

[UNICEF](https://www.unicef.org/) | [Data & Analytics](https://data.unicef.org/) | [GitHub](https://github.com/unicef)

</div>
