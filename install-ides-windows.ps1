# ============================================================================
# IDE and Editor Installation Script for Windows
# ============================================================================
# This script automates the installation of development environments
# Requires: Chocolatey package manager
# ============================================================================

param(
    [switch]$All,
    [switch]$Rtools,
    [switch]$VSCode,
    [switch]$RStudio,
    [switch]$Spyder,
    [switch]$LaTeX,
    [switch]$RDevTools,
    [switch]$CheckOnly
)

# Colors
$ESC = [char]27
$BLUE = "$ESC[36m"
$GREEN = "$ESC[32m"
$YELLOW = "$ESC[33m"
$RED = "$ESC[31m"
$NC = "$ESC[0m"

# ============================================================================
# Helper Functions
# ============================================================================

function Write-ColorOutput {
    param([string]$Color, [string]$Message)
    Write-Host "$Color$Message$NC"
}

function Test-CommandExists {
    param([string]$Command)
    $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

function Test-ChocoInstalled {
    if (-not (Test-CommandExists "choco")) {
        Write-ColorOutput $RED "[ERROR] Chocolatey is not installed"
        Write-Host "Install from: https://chocolatey.org/install"
        Write-Host "Or run: Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
        return $false
    }
    return $true
}

# ============================================================================
# Check Installed IDEs
# ============================================================================

function Check-InstalledIDEs {
    Write-ColorOutput $BLUE "`n🔍 Checking installed IDEs...`n"
    
    Write-Host "  Rtools:   " -NoNewline
    try {
        $rtoolsCheck = & Rscript -e "cat(ifelse(pkgbuild::has_build_tools(debug = FALSE), 'TRUE', 'FALSE'))" 2>$null
        if ($rtoolsCheck -eq 'TRUE') {
            Write-ColorOutput $GREEN "✓ Installed"
        } else {
            Write-ColorOutput $YELLOW "✗ Not found"
        }
    } catch {
        Write-ColorOutput $YELLOW "✗ Not found"
    }
    
    Write-Host "  VS Code:  " -NoNewline
    if (Test-CommandExists "code") {
        Write-ColorOutput $GREEN "✓ Installed"
        code --version | Select-Object -First 1
    } else {
        Write-ColorOutput $YELLOW "✗ Not found"
    }
    
    Write-Host "  RStudio:  " -NoNewline
    if (Test-Path "C:\Program Files\RStudio\rstudio.exe") {
        Write-ColorOutput $GREEN "✓ Installed"
    } else {
        Write-ColorOutput $YELLOW "✗ Not found"
    }
    
    Write-Host "  Spyder:   " -NoNewline
    if (Test-CommandExists "spyder") {
        Write-ColorOutput $GREEN "✓ Installed"
    } else {
        Write-ColorOutput $YELLOW "✗ Not found"
    }
    
    Write-Host "  MiKTeX:   " -NoNewline
    if (Test-CommandExists "pdflatex") {
        Write-ColorOutput $GREEN "✓ Installed"
        pdflatex --version | Select-Object -First 1
    } else {
        Write-ColorOutput $YELLOW "✗ Not found"
    }
    
    Write-ColorOutput $BLUE "`n🛠️  R Development Tools:`n"
    
    Write-Host "  radian:   " -NoNewline
    if (Test-CommandExists "radian") {
        Write-ColorOutput $GREEN "✓ Installed"
    } else {
        Write-ColorOutput $YELLOW "✗ Not found"
    }
    
    Write-Host "  languageserver: " -NoNewline
    try {
        $lsCheck = & Rscript -e "cat(ifelse(requireNamespace('languageserver', quietly = TRUE), 'TRUE', 'FALSE'))" 2>$null
        if ($lsCheck -eq 'TRUE') {
            Write-ColorOutput $GREEN "✓ Installed"
        } else {
            Write-ColorOutput $YELLOW "✗ Not found"
        }
    } catch {
        Write-ColorOutput $YELLOW "✗ Not found"
    }
    
    Write-Host ""
}

# ============================================================================
# Installation Functions
# ============================================================================

function Install-Rtools {
    Write-ColorOutput $BLUE "`n🔧 Installing Rtools..."
    
    try {
        $rtoolsCheck = & Rscript -e "cat(ifelse(pkgbuild::has_build_tools(debug = FALSE), 'TRUE', 'FALSE'))" 2>$null
        if ($rtoolsCheck -eq 'TRUE') {
            Write-ColorOutput $YELLOW "Rtools is already installed"
            return
        }
    } catch {
        # Continue with installation
    }
    
    choco install rtools -y
    
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput $GREEN "✓ Rtools installed successfully"
        
        # Verify installation
        Write-ColorOutput $BLUE "Verifying Rtools..."
        try {
            & Rscript -e "pkgbuild::check_build_tools(debug = TRUE)"
            Write-ColorOutput $GREEN "✓ Rtools verified"
        } catch {
            Write-ColorOutput $YELLOW "⚠ Please restart your terminal and verify with: Rscript -e 'pkgbuild::check_build_tools()'"
        }
    } else {
        Write-ColorOutput $RED "✗ Failed to install Rtools"
        Write-Host "Download manually from: https://cran.r-project.org/bin/windows/Rtools/"
    }
}

function Install-RDevTools {
    Write-ColorOutput $BLUE "`n🛠️ Installing R Development Tools..."
    
    # Install radian
    Write-ColorOutput $BLUE "Installing radian (enhanced R console)..."
    python -m pip install radian
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput $GREEN "✓ radian installed"
    } else {
        Write-ColorOutput $YELLOW "⚠ radian installation failed"
    }
    
    # Install languageserver
    Write-ColorOutput $BLUE "Installing R languageserver..."
    & Rscript -e "if (!requireNamespace('languageserver', quietly = TRUE)) install.packages('languageserver', repos = 'https://cloud.r-project.org/')"
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput $GREEN "✓ languageserver installed"
    } else {
        Write-ColorOutput $YELLOW "⚠ languageserver installation failed"
    }
    
    # Install httpgd
    Write-ColorOutput $BLUE "Installing httpgd (graphics device)..."
    & Rscript -e "if (!requireNamespace('httpgd', quietly = TRUE)) install.packages('httpgd', repos = 'https://cloud.r-project.org/')"
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput $GREEN "✓ httpgd installed"
    } else {
        Write-ColorOutput $YELLOW "⚠ httpgd installation failed"
    }
    
    Write-ColorOutput $GREEN "`n✓ R development tools installation complete"
    Write-Host "Try: radian  # for enhanced R console"
}

function Install-VSCode {
    Write-ColorOutput $BLUE "`n📝 Installing VS Code..."
    
    if (Test-CommandExists "code") {
        Write-ColorOutput $YELLOW "VS Code is already installed"
        return
    }
    
    choco install vscode -y
    
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput $GREEN "✓ VS Code installed successfully"
        
        # Install extensions
        Write-ColorOutput $BLUE "Installing VS Code extensions..."
        code --install-extension REditorSupport.r
        code --install-extension ms-python.python
        code --install-extension ms-toolsai.jupyter
        code --install-extension kylebarron.stata-enhanced
        code --install-extension yzhang.markdown-all-in-one
        code --install-extension redhat.vscode-yaml
        Write-ColorOutput $GREEN "✓ Extensions installed"
    } else {
        Write-ColorOutput $RED "✗ Failed to install VS Code"
    }
}

function Install-RStudio {
    Write-ColorOutput $BLUE "`n📊 Installing RStudio..."
    
    if (Test-Path "C:\Program Files\RStudio\rstudio.exe") {
        Write-ColorOutput $YELLOW "RStudio is already installed"
        return
    }
    
    choco install r.studio -y
    
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput $GREEN "✓ RStudio installed successfully"
    } else {
        Write-ColorOutput $RED "✗ Failed to install RStudio"
    }
}

function Install-Spyder {
    Write-ColorOutput $BLUE "`n🕷️ Installing Spyder..."
    
    if (Test-CommandExists "spyder") {
        Write-ColorOutput $YELLOW "Spyder is already installed"
        return
    }
    
    # Try Chocolatey first, fall back to pip
    choco install spyder -y
    
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput $GREEN "✓ Spyder installed successfully via Chocolatey"
    } else {
        Write-ColorOutput $YELLOW "Chocolatey install failed, trying pip..."
        python -m pip install spyder
        if ($LASTEXITCODE -eq 0) {
            Write-ColorOutput $GREEN "✓ Spyder installed successfully via pip"
        } else {
            Write-ColorOutput $RED "✗ Failed to install Spyder"
        }
    }
}

function Install-LaTeX {
    Write-ColorOutput $BLUE "`n📄 Installing MiKTeX..."
    
    if (Test-CommandExists "pdflatex") {
        Write-ColorOutput $YELLOW "MiKTeX is already installed"
        return
    }
    
    choco install miktex -y
    
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput $GREEN "✓ MiKTeX installed successfully"
        
        # Initialize MiKTeX
        Write-ColorOutput $BLUE "Initializing MiKTeX..."
        initexmf --set-config-value "[MPM]AutoInstall=1"
        
        Write-ColorOutput $GREEN "✓ MiKTeX configured"
    } else {
        Write-ColorOutput $RED "✗ Failed to install MiKTeX"
    }
}

# ============================================================================
# Main Execution
# ============================================================================

Write-ColorOutput $BLUE "╔════════════════════════════════════════════════════════════╗"
Write-ColorOutput $BLUE "║  UNICEF Analytics - IDE Installation (Windows)            ║"
Write-ColorOutput $BLUE "╚════════════════════════════════════════════════════════════╝"

# Check-only mode
if ($CheckOnly) {
    Check-InstalledIDEs
    exit 0
}

# Check for Chocolatey
if (-not (Test-ChocoInstalled)) {
    exit 1
}

# Determine what to install
$installAll = $All -or (-not ($Rtools -or $VSCode -or $RStudio -or $Spyder -or $LaTeX -or $RDevTools))

if ($installAll -or $Rtools) { Install-Rtools }
if ($installAll -or $VSCode) { Install-VSCode }
if ($installAll -or $RStudio) { Install-RStudio }
if ($installAll -or $Spyder) { Install-Spyder }
if ($installAll -or $LaTeX) { Install-LaTeX }
if ($installAll -or $RDevTools) { Install-RDevTools }

# Final check
Write-ColorOutput $BLUE "`n════════════════════════════════════════════════════════════"
Write-ColorOutput $GREEN "  Installation Complete!"
Write-ColorOutput $BLUE "════════════════════════════════════════════════════════════`n"

Check-InstalledIDEs

Write-Host "Next steps:"
Write-Host "  1. Restart your terminal to update PATH"
Write-Host "  2. Configure each IDE (see install-ides.md)"
Write-Host "  3. Run: make check-ides"
Write-Host "  4. Try: radian  # enhanced R console"
Write-Host ""

# ============================================================================
# Usage Examples
# ============================================================================
<#
.SYNOPSIS
    Install development environments for UNICEF analytics

.DESCRIPTION
    Installs VS Code, RStudio, Spyder, and MiKTeX using Chocolatey

.PARAMETER All
    Install all IDEs (default if no specific IDE is selected)

.PARAMETER VSCode
    Install only VS Code

.PARAMETER RStudio
    Install only RStudio

.PARAMETER Spyder
    Install only Spyder

.PARAMETER LaTeX
    Install only MiKTeX

.PARAMETER CheckOnly
    Only check what's installed, don't install anything

.EXAMPLE
    .\install-ides-windows.ps1
    Install all IDEs

.EXAMPLE
    .\install-ides-windows.ps1 -VSCode -RStudio
    Install only VS Code and RStudio

.EXAMPLE
    .\install-ides-windows.ps1 -CheckOnly
    Check what's currently installed
#>
