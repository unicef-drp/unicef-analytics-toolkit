#!/usr/bin/env python3
"""
UNICEF Analytics Environment - Python Package Installation
===========================================================
Usage: python install-python-packages.py
"""

import sys
import subprocess
import os
from datetime import datetime
from pathlib import Path

# ==============================================================================
# Configuration
# ==============================================================================

REQUIREMENTS_FILE = "requirements-python.txt"
LOGS_DIR = Path("logs")
MIN_PYTHON_VERSION = (3, 9)

# ANSI color codes for terminal output
class Colors:
    BLUE = '\033[0;36m'
    GREEN = '\033[0;32m'
    YELLOW = '\033[0;33m'
    RED = '\033[0;31m'
    NC = '\033[0m'  # No Color

def print_header(text):
    """Print formatted header"""
    print(f"\n{Colors.BLUE}{'=' * 70}{Colors.NC}")
    print(f"{Colors.BLUE}  {text}{Colors.NC}")
    print(f"{Colors.BLUE}{'=' * 70}{Colors.NC}\n")

def print_success(text):
    """Print success message"""
    print(f"{Colors.GREEN}✓ {text}{Colors.NC}")

def print_warning(text):
    """Print warning message"""
    print(f"{Colors.YELLOW}⚠ {text}{Colors.NC}")

def print_error(text):
    """Print error message"""
    print(f"{Colors.RED}✗ {text}{Colors.NC}")

# ==============================================================================
# Python Version Check
# ==============================================================================

def check_python_version():
    """Check if Python version meets minimum requirements"""
    print_header("UNICEF Analytics Environment - Python Package Installation")
    
    current_version = sys.version_info[:2]
    version_string = f"{current_version[0]}.{current_version[1]}"
    
    print(f"Python version: {sys.version}")
    
    if current_version < MIN_PYTHON_VERSION:
        print_error(f"Python {MIN_PYTHON_VERSION[0]}.{MIN_PYTHON_VERSION[1]} "
                   f"or higher is required")
        print_error(f"Current version: {version_string}")
        sys.exit(1)
    
    print_success(f"Python version: {version_string}")
    return True

# ==============================================================================
# Virtual Environment Check
# ==============================================================================

def check_virtual_env():
    """Check if running in a virtual environment"""
    in_venv = hasattr(sys, 'real_prefix') or (
        hasattr(sys, 'base_prefix') and sys.base_prefix != sys.prefix
    )
    
    if in_venv:
        print_success("Running in virtual environment")
        print(f"  Location: {sys.prefix}")
    else:
        print_warning("Not running in a virtual environment")
        print("  Consider creating one with: python -m venv venv")
        print("  Activate it before installing packages")
        
        response = input("\nContinue anyway? [y/N]: ").strip().lower()
        if response != 'y':
            print("Installation cancelled.")
            sys.exit(0)
    
    return in_venv

# ==============================================================================
# Package Installation
# ==============================================================================

def read_requirements():
    """Read and parse requirements file"""
    if not os.path.exists(REQUIREMENTS_FILE):
        print_error(f"{REQUIREMENTS_FILE} not found")
        sys.exit(1)
    
    with open(REQUIREMENTS_FILE, 'r') as f:
        lines = f.readlines()
    
    # Filter out comments and empty lines
    packages = []
    for line in lines:
        line = line.strip()
        # Skip empty lines, comments, and section headers
        if line and not line.startswith('#') and not line.startswith('='):
            # Remove inline comments
            package = line.split('#')[0].strip()
            if package:
                packages.append(package)
    
    return packages

def upgrade_pip():
    """Upgrade pip to latest version"""
    print_header("Upgrading pip")
    try:
        subprocess.check_call([
            sys.executable, "-m", "pip", "install", "--upgrade", "pip"
        ])
        print_success("pip upgraded successfully")
        return True
    except subprocess.CalledProcessError as e:
        print_warning(f"Could not upgrade pip: {e}")
        return False

def install_packages(packages):
    """Install packages from list"""
    print_header(f"Installing {len(packages)} Packages")
    
    success_count = 0
    fail_count = 0
    failed_packages = []
    
    for i, package in enumerate(packages, 1):
        print(f"[{i}/{len(packages)}] Installing: {package:50} ... ", end='', flush=True)
        
        try:
            # Install package silently
            result = subprocess.run(
                [sys.executable, "-m", "pip", "install", package],
                capture_output=True,
                text=True,
                timeout=300  # 5 minute timeout per package
            )
            
            if result.returncode == 0:
                print(f"{Colors.GREEN}✓{Colors.NC}")
                success_count += 1
            else:
                print(f"{Colors.RED}✗{Colors.NC}")
                fail_count += 1
                failed_packages.append(package)
        except subprocess.TimeoutExpired:
            print(f"{Colors.RED}✗ (timeout){Colors.NC}")
            fail_count += 1
            failed_packages.append(package)
        except Exception as e:
            print(f"{Colors.RED}✗ ({str(e)}){Colors.NC}")
            fail_count += 1
            failed_packages.append(package)
    
    return success_count, fail_count, failed_packages

# ==============================================================================
# Verification
# ==============================================================================

def verify_critical_packages():
    """Verify that critical packages are available"""
    print_header("Verifying Critical Packages")
    
    critical_packages = [
        "numpy", "pandas", "matplotlib", "seaborn",
        "jupyter", "requests", "pyyaml"
    ]
    
    all_ok = True
    for package in critical_packages:
        try:
            __import__(package)
            print(f"  {Colors.GREEN}✓{Colors.NC} {package}")
        except ImportError:
            print(f"  {Colors.RED}✗{Colors.NC} {package} - FAILED TO LOAD")
            all_ok = False
    
    return all_ok

def list_installed_packages():
    """List all installed packages"""
    try:
        result = subprocess.run(
            [sys.executable, "-m", "pip", "list"],
            capture_output=True,
            text=True
        )
        return result.stdout
    except:
        return "Could not list packages"

# ==============================================================================
# Logging
# ==============================================================================

def save_installation_log(success_count, fail_count, failed_packages):
    """Save installation log to file"""
    LOGS_DIR.mkdir(exist_ok=True)
    
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    log_file = LOGS_DIR / f"python-install-{timestamp}.log"
    
    with open(log_file, 'w') as f:
        f.write("Python Package Installation Log\n")
        f.write("=" * 70 + "\n\n")
        f.write(f"Date: {datetime.now()}\n")
        f.write(f"Python Version: {sys.version}\n\n")
        f.write(f"Installation Summary:\n")
        f.write(f"  Successful: {success_count}\n")
        f.write(f"  Failed: {fail_count}\n\n")
        
        if failed_packages:
            f.write("Failed Packages:\n")
            for pkg in failed_packages:
                f.write(f"  - {pkg}\n")
            f.write("\n")
        
        f.write("Installed Packages:\n")
        f.write("=" * 70 + "\n")
        f.write(list_installed_packages())
    
    return log_file

# ==============================================================================
# Main Execution
# ==============================================================================

def main():
    """Main installation process"""
    try:
        # Check Python version
        check_python_version()
        
        # Check virtual environment
        check_virtual_env()
        
        # Upgrade pip
        upgrade_pip()
        
        # Read requirements
        print_header("Reading Requirements")
        packages = read_requirements()
        print_success(f"Found {len(packages)} packages to install")
        
        # Install packages
        success_count, fail_count, failed_packages = install_packages(packages)
        
        # Print summary
        print_header("Installation Summary")
        print(f"  Successful: {Colors.GREEN}{success_count}{Colors.NC} packages")
        print(f"  Failed:     {Colors.RED}{fail_count}{Colors.NC} packages")
        
        if failed_packages:
            print(f"\n{Colors.YELLOW}Failed packages:{Colors.NC}")
            for pkg in failed_packages:
                print(f"  - {pkg}")
        
        # Verify critical packages
        critical_ok = verify_critical_packages()
        
        # Save log
        log_file = save_installation_log(success_count, fail_count, failed_packages)
        print(f"\n📝 Installation log saved to: {log_file}")
        
        # Final status
        print_header("Installation Complete")
        
        if critical_ok and fail_count == 0:
            print_success("All packages installed successfully!")
            print("\nNext steps:")
            print("  1. Install R packages: Rscript install-r-packages.R")
            print("  2. Install Stata packages: do requirements-stata.do")
            print("  3. Run: make check")
        else:
            print_warning("Installation completed with warnings")
            print("Some packages may need manual attention.")
            print("Check the log file for details.")
        
        return 0 if (critical_ok and fail_count == 0) else 1
        
    except KeyboardInterrupt:
        print("\n\nInstallation cancelled by user.")
        return 130
    except Exception as e:
        print_error(f"Unexpected error: {e}")
        return 1

if __name__ == "__main__":
    sys.exit(main())
