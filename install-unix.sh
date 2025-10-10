#!/bin/bash
# ==============================================================================
# UNICEF Analytics Environment Setup - Unix/Linux/macOS Installation Script
# ==============================================================================
# This script automates the complete installation process
# ==============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;36m'
NC='\033[0m' # No Color

# ==============================================================================
# Helper Functions
# ==============================================================================

print_header() {
    echo -e "\n${BLUE}========================================================================${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}========================================================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# ==============================================================================
# Main Installation
# ==============================================================================

print_header "UNICEF Analytics Environment Setup"

# ==============================================================================
# Check Prerequisites
# ==============================================================================

print_header "STEP 1: Checking prerequisites"

# Check Operating System
OS_TYPE=$(uname -s)
print_info "Operating System: $OS_TYPE"

# Check R
if command -v Rscript &> /dev/null; then
    R_VERSION=$(Rscript --version 2>&1 | head -n 1)
    print_success "R is installed: $R_VERSION"
else
    print_error "R is not installed"
    echo "Please install R from: https://cran.r-project.org/"
    echo "Minimum version required: 4.0.0"
    exit 1
fi

# Check Python
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    print_success "Python is installed: $PYTHON_VERSION"
    PYTHON_CMD="python3"
elif command -v python &> /dev/null; then
    PYTHON_VERSION=$(python --version)
    print_success "Python is installed: $PYTHON_VERSION"
    PYTHON_CMD="python"
else
    print_warning "Python is not installed"
    echo "Python is recommended for full functionality"
    echo "Download from: https://www.python.org/"
    PYTHON_CMD=""
fi

# Check pip
if command -v pip3 &> /dev/null; then
    print_success "pip is installed: $(pip3 --version)"
    PIP_CMD="pip3"
elif command -v pip &> /dev/null; then
    print_success "pip is installed: $(pip --version)"
    PIP_CMD="pip"
else
    if [ -n "$PYTHON_CMD" ]; then
        print_warning "pip not found, will use python -m pip"
        PIP_CMD="$PYTHON_CMD -m pip"
    fi
fi

# Check Git
if command -v git &> /dev/null; then
    print_success "Git is installed: $(git --version)"
else
    print_warning "Git is not installed"
    echo "Install from: https://git-scm.com/"
fi

# Check Stata (optional)
if command -v stata &> /dev/null || command -v stata-mp &> /dev/null; then
    print_success "Stata is installed"
else
    print_info "Stata not found (optional)"
fi

# Check Make
if command -v make &> /dev/null; then
    print_success "Make is installed"
else
    print_warning "Make is not installed"
    echo "Install make for easier automation:"
    if [ "$OS_TYPE" = "Darwin" ]; then
        echo "  xcode-select --install"
    else
        echo "  sudo apt-get install build-essential  # Ubuntu/Debian"
        echo "  sudo yum install make                  # CentOS/RHEL"
    fi
fi

echo ""

# ==============================================================================
# Create Directories
# ==============================================================================

print_header "STEP 2: Creating directories"

mkdir -p logs
mkdir -p backups
print_success "Directories created"

echo ""

# ==============================================================================
# Install R Packages
# ==============================================================================

print_header "STEP 3: Installing R packages"

if [ -f "requirements-r.txt" ]; then
    echo "Installing R packages from requirements-r.txt..."
    if Rscript install-r-packages.R; then
        print_success "R packages installed"
    else
        print_warning "Some R packages may have failed to install"
    fi
else
    print_error "requirements-r.txt not found"
    exit 1
fi

echo ""

# ==============================================================================
# Install Python Packages
# ==============================================================================

print_header "STEP 4: Installing Python packages"

if [ -n "$PYTHON_CMD" ]; then
    if [ -f "requirements-python.txt" ]; then
        # Ask about virtual environment
        read -p "Create and use Python virtual environment? [y/N]: " USE_VENV
        
        if [ "$USE_VENV" = "y" ] || [ "$USE_VENV" = "Y" ]; then
            echo "Creating virtual environment..."
            $PYTHON_CMD -m venv venv
            
            echo "Activating virtual environment..."
            source venv/bin/activate
            
            echo "Upgrading pip..."
            $PIP_CMD install --upgrade pip
            
            echo "Installing Python packages..."
            $PYTHON_CMD install-python-packages.py
        else
            echo "Installing Python packages globally..."
            $PYTHON_CMD install-python-packages.py
        fi
        
        if [ $? -eq 0 ]; then
            print_success "Python packages installed"
        else
            print_warning "Some Python packages may have failed to install"
        fi
    else
        print_error "requirements-python.txt not found"
    fi
else
    print_info "Python not installed, skipping Python packages"
fi

echo ""

# ==============================================================================
# Install Stata Packages (Optional)
# ==============================================================================

print_header "STEP 5: Installing Stata packages"

if command -v stata &> /dev/null || command -v stata-mp &> /dev/null; then
    if [ -f "requirements-stata.do" ]; then
        read -p "Install Stata packages? [y/N]: " INSTALL_STATA
        
        if [ "$INSTALL_STATA" = "y" ] || [ "$INSTALL_STATA" = "Y" ]; then
            echo "Installing Stata packages..."
            if command -v stata-mp &> /dev/null; then
                stata-mp -b do requirements-stata.do
            else
                stata -b do requirements-stata.do
            fi
            
            if [ $? -eq 0 ]; then
                print_success "Stata packages installed"
            else
                print_warning "Some Stata packages may have failed to install"
            fi
        else
            print_info "Stata package installation skipped"
        fi
    else
        print_error "requirements-stata.do not found"
    fi
else
    print_info "Stata not installed, skipping Stata packages"
fi

echo ""

# ==============================================================================
# Configuration
# ==============================================================================

print_header "STEP 6: Checking configuration"

CONFIG_DIR="$HOME/.config"
CONFIG_FILE="$CONFIG_DIR/user_config.yml"

if [ ! -d "$CONFIG_DIR" ]; then
    echo "Creating configuration directory: $CONFIG_DIR"
    mkdir -p "$CONFIG_DIR"
fi

if [ ! -f "$CONFIG_FILE" ]; then
    if [ -f "_config_template/user_config.yml" ]; then
        echo "Copying user configuration template..."
        cp _config_template/user_config.yml "$CONFIG_FILE"
        print_info "Please edit $CONFIG_FILE with your paths"
    else
        print_warning "Configuration template not found"
    fi
else
    print_success "Configuration file already exists"
fi

echo ""

# ==============================================================================
# Verification
# ==============================================================================

print_header "STEP 7: Verifying installation"

echo "Checking R environment..."
Rscript -e "cat('R version:', as.character(getRversion()), '\n'); cat('Installed packages:', length(.packages(all.available = TRUE)), '\n')"

echo ""

if [ -n "$PYTHON_CMD" ]; then
    echo "Checking Python environment..."
    $PYTHON_CMD -c "import sys; print(f'Python version: {sys.version}'); import subprocess; result = subprocess.run([sys.executable, '-m', 'pip', 'list'], capture_output=True, text=True); print(f'Installed packages: {len(result.stdout.splitlines()) - 2}')"
fi

echo ""

# ==============================================================================
# Installation Summary
# ==============================================================================

print_header "Installation Complete!"

echo "Next steps:"
echo "  1. Edit configuration: $CONFIG_FILE"
echo "  2. Verify installation: make check"
echo "  3. Read documentation: README.md"
echo ""
echo "Additional tools to install (optional):"
echo "  - Pandoc:  https://pandoc.org/installing.html"
echo "  - Quarto:  https://quarto.org/docs/get-started/"
echo "  - VS Code: https://code.visualstudio.com/"
echo "  - RStudio: https://posit.co/download/rstudio-desktop/"
echo ""

if [ "$OS_TYPE" = "Darwin" ]; then
    echo "macOS-specific tools:"
    echo "  - Homebrew: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    echo "  - XQuartz:  https://www.xquartz.org/"
    echo ""
fi

echo "For help, see: INSTALL.md or TROUBLESHOOTING.md"
echo ""

print_success "Setup script completed successfully!"
