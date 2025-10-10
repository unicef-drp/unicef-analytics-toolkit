#!/bin/bash
# ============================================================================
# IDE and Editor Installation Script for macOS/Linux
# ============================================================================
# This script automates the installation of development environments
# ============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;36m'
NC='\033[0m' # No Color

# ============================================================================
# Helper Functions
# ============================================================================

print_header() {
    echo -e "\n${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  $1${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# ============================================================================
# Check What's Installed
# ============================================================================

check_installed_ides() {
    print_header "Checking installed IDEs..."
    
    echo -n "  VS Code:  "
    if command -v code &> /dev/null; then
        print_success "Installed ($(code --version | head -n 1))"
    else
        print_warning "Not found"
    fi
    
    echo -n "  RStudio:  "
    if command -v rstudio &> /dev/null || [ -d "/Applications/RStudio.app" ]; then
        print_success "Installed"
    else
        print_warning "Not found"
    fi
    
    echo -n "  Spyder:   "
    if command -v spyder &> /dev/null || python3 -c "import spyder" 2>/dev/null; then
        print_success "Installed"
    else
        print_warning "Not found"
    fi
    
    echo -n "  LaTeX:    "
    if command -v pdflatex &> /dev/null; then
        print_success "Installed ($(pdflatex --version | head -n 1))"
    else
        print_warning "Not found"
    fi
    
    echo ""
}

# ============================================================================
# Installation Functions
# ============================================================================

install_vscode() {
    print_info "Installing VS Code..."
    
    if command -v code &> /dev/null; then
        print_warning "VS Code is already installed"
        return 0
    fi
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            brew install --cask visual-studio-code
            print_success "VS Code installed via Homebrew"
        else
            print_warning "Homebrew not found. Download from: https://code.visualstudio.com/"
            return 1
        fi
    elif [[ -f /etc/debian_version ]]; then
        # Ubuntu/Debian
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
        sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
        sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
        rm -f packages.microsoft.gpg
        sudo apt update
        sudo apt install code -y
        print_success "VS Code installed via apt"
    elif [[ -f /etc/redhat-release ]]; then
        # CentOS/RHEL/Fedora
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
        sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
        sudo dnf check-update
        sudo dnf install code -y
        print_success "VS Code installed via dnf"
    fi
    
    # Install extensions
    print_info "Installing VS Code extensions..."
    code --install-extension REditorSupport.r
    code --install-extension ms-python.python
    code --install-extension ms-toolsai.jupyter
    code --install-extension kylebarron.stata-enhanced
    code --install-extension yzhang.markdown-all-in-one
    code --install-extension redhat.vscode-yaml
    print_success "Extensions installed"
}

install_rstudio() {
    print_info "Installing RStudio..."
    
    if command -v rstudio &> /dev/null || [ -d "/Applications/RStudio.app" ]; then
        print_warning "RStudio is already installed"
        return 0
    fi
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            brew install --cask rstudio
            print_success "RStudio installed via Homebrew"
        else
            print_warning "Homebrew not found. Download from: https://posit.co/download/rstudio-desktop/"
            return 1
        fi
    elif [[ -f /etc/debian_version ]]; then
        # Ubuntu/Debian
        print_info "Downloading RStudio..."
        wget https://download1.rstudio.org/electron/jammy/amd64/rstudio-latest-amd64.deb
        sudo dpkg -i rstudio-*-amd64.deb
        sudo apt-get install -f -y
        rm rstudio-*-amd64.deb
        print_success "RStudio installed"
    elif [[ -f /etc/redhat-release ]]; then
        # CentOS/RHEL/Fedora
        print_info "Downloading RStudio..."
        wget https://download1.rstudio.org/electron/centos8/x86_64/rstudio-latest-x86_64.rpm
        sudo yum install rstudio-*-x86_64.rpm -y
        rm rstudio-*-x86_64.rpm
        print_success "RStudio installed"
    fi
}

install_spyder() {
    print_info "Installing Spyder..."
    
    if command -v spyder &> /dev/null; then
        print_warning "Spyder is already installed"
        return 0
    fi
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            brew install --cask spyder
            print_success "Spyder installed via Homebrew"
        else
            python3 -m pip install spyder
            print_success "Spyder installed via pip"
        fi
    elif [[ -f /etc/debian_version ]]; then
        # Ubuntu/Debian
        if ! sudo apt install spyder -y 2>/dev/null; then
            python3 -m pip install spyder
            print_success "Spyder installed via pip"
        else
            print_success "Spyder installed via apt"
        fi
    else
        python3 -m pip install spyder
        print_success "Spyder installed via pip"
    fi
}

install_latex() {
    print_info "Installing LaTeX..."
    
    if command -v pdflatex &> /dev/null; then
        print_warning "LaTeX is already installed"
        return 0
    fi
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            brew install --cask basictex
            
            # Update PATH
            echo 'export PATH="/Library/TeX/texbin:$PATH"' >> ~/.zshrc
            export PATH="/Library/TeX/texbin:$PATH"
            
            # Update tlmgr
            sudo tlmgr update --self
            sudo tlmgr install latexmk collection-fontsrecommended
            
            print_success "BasicTeX installed via Homebrew"
        else
            print_warning "Homebrew not found. Download from: https://tug.org/mactex/"
            return 1
        fi
    elif [[ -f /etc/debian_version ]]; then
        # Ubuntu/Debian
        sudo apt update
        sudo apt install texlive-latex-recommended texlive-latex-extra -y
        sudo apt install latexmk -y
        print_success "TeX Live installed via apt"
    elif [[ -f /etc/redhat-release ]]; then
        # CentOS/RHEL/Fedora
        sudo dnf install texlive texlive-latex -y
        print_success "TeX Live installed via dnf"
    fi
}

# ============================================================================
# Main Execution
# ============================================================================

print_header "UNICEF Analytics - IDE Installation"

# Parse arguments
INSTALL_ALL=true
INSTALL_VSCODE=false
INSTALL_RSTUDIO=false
INSTALL_SPYDER=false
INSTALL_LATEX=false
CHECK_ONLY=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --vscode)
            INSTALL_VSCODE=true
            INSTALL_ALL=false
            shift
            ;;
        --rstudio)
            INSTALL_RSTUDIO=true
            INSTALL_ALL=false
            shift
            ;;
        --spyder)
            INSTALL_SPYDER=true
            INSTALL_ALL=false
            shift
            ;;
        --latex)
            INSTALL_LATEX=true
            INSTALL_ALL=false
            shift
            ;;
        --check)
            CHECK_ONLY=true
            shift
            ;;
        --all)
            INSTALL_ALL=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--vscode] [--rstudio] [--spyder] [--latex] [--all] [--check]"
            exit 1
            ;;
    esac
done

# Check-only mode
if [ "$CHECK_ONLY" = true ]; then
    check_installed_ides
    exit 0
fi

# Perform installations
if [ "$INSTALL_ALL" = true ] || [ "$INSTALL_VSCODE" = true ]; then
    install_vscode
fi

if [ "$INSTALL_ALL" = true ] || [ "$INSTALL_RSTUDIO" = true ]; then
    install_rstudio
fi

if [ "$INSTALL_ALL" = true ] || [ "$INSTALL_SPYDER" = true ]; then
    install_spyder
fi

if [ "$INSTALL_ALL" = true ] || [ "$INSTALL_LATEX" = true ]; then
    install_latex
fi

# Final check
print_header "Installation Complete!"
check_installed_ides

echo "Next steps:"
echo "  1. Restart your terminal to update PATH"
echo "  2. Configure each IDE (see install-ides.md)"
echo "  3. Run: make check-ides"
echo ""
