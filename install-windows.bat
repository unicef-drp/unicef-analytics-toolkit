@echo off
REM ==============================================================================
REM UNICEF Analytics Environment Setup - Windows Installation Script
REM ==============================================================================
REM This script automates the complete installation process for Windows
REM ==============================================================================

echo.
echo ================================================================================
echo   UNICEF Analytics Environment Setup for Windows
echo ================================================================================
echo.

REM ==============================================================================
REM Check for Administrator Rights (optional but recommended)
REM ==============================================================================

net session >nul 2>&1
if %errorLevel% == 0 (
    echo [OK] Running with Administrator privileges
) else (
    echo [WARNING] Not running as Administrator
    echo           Some installations may require elevation
    echo.
)

REM ==============================================================================
REM Check Prerequisites
REM ==============================================================================

echo [STEP 1] Checking prerequisites...
echo.

REM Check R
where Rscript >nul 2>&1
if %errorLevel% == 0 (
    echo [OK] R is installed
    Rscript --version
) else (
    echo [ERROR] R is not installed
    echo         Please install R from: https://cran.r-project.org/
    echo         Minimum version required: 4.0.0
    pause
    exit /b 1
)

echo.

REM Check Python
where python >nul 2>&1
if %errorLevel% == 0 (
    echo [OK] Python is installed
    python --version
) else (
    echo [WARNING] Python is not installed
    echo           Python is recommended for full functionality
    echo           Download from: https://www.python.org/
)

echo.

REM Check Git
where git >nul 2>&1
if %errorLevel% == 0 (
    echo [OK] Git is installed
    git --version
) else (
    echo [WARNING] Git is not installed
    echo           Install from: https://git-scm.com/
)

echo.

REM Check Stata (optional)
where stata >nul 2>&1
if %errorLevel% == 0 (
    echo [OK] Stata is installed
) else (
    echo [INFO] Stata not found (optional)
)

echo.

REM ==============================================================================
REM Create Directories
REM ==============================================================================

echo [STEP 2] Creating directories...
if not exist logs mkdir logs
if not exist backups mkdir backups
echo [OK] Directories created
echo.

REM ==============================================================================
REM Install R Packages
REM ==============================================================================

echo [STEP 3] Installing R packages...
echo.

if exist requirements-r.txt (
    echo Installing R packages from requirements-r.txt...
    Rscript install-r-packages.R
    if %errorLevel% == 0 (
        echo [OK] R packages installed
    ) else (
        echo [WARNING] Some R packages may have failed to install
    )
) else (
    echo [ERROR] requirements-r.txt not found
    exit /b 1
)

echo.

REM ==============================================================================
REM Install Python Packages
REM ==============================================================================

echo [STEP 4] Installing Python packages...
echo.

where python >nul 2>&1
if %errorLevel% == 0 (
    if exist requirements-python.txt (
        REM Ask about virtual environment
        set /p USE_VENV="Create and use Python virtual environment? [y/N]: "
        
        if /i "%USE_VENV%"=="y" (
            echo Creating virtual environment...
            python -m venv venv
            
            echo Activating virtual environment...
            call venv\Scripts\activate.bat
            
            echo Upgrading pip...
            python -m pip install --upgrade pip
            
            echo Installing Python packages...
            python install-python-packages.py
        ) else (
            echo Installing Python packages globally...
            python install-python-packages.py
        )
        
        if %errorLevel% == 0 (
            echo [OK] Python packages installed
        ) else (
            echo [WARNING] Some Python packages may have failed to install
        )
    ) else (
        echo [ERROR] requirements-python.txt not found
    )
) else (
    echo [SKIP] Python not installed, skipping Python packages
)

echo.

REM ==============================================================================
REM Install Stata Packages (Optional)
REM ==============================================================================

echo [STEP 5] Installing Stata packages...
echo.

where stata >nul 2>&1
if %errorLevel% == 0 (
    if exist requirements-stata.do (
        set /p INSTALL_STATA="Install Stata packages? [y/N]: "
        if /i "%INSTALL_STATA%"=="y" (
            echo Installing Stata packages...
            stata-mp /b do requirements-stata.do
            if %errorLevel% == 0 (
                echo [OK] Stata packages installed
            ) else (
                echo [WARNING] Some Stata packages may have failed to install
            )
        ) else (
            echo [SKIP] Stata package installation skipped
        )
    ) else (
        echo [ERROR] requirements-stata.do not found
    )
) else (
    echo [SKIP] Stata not installed, skipping Stata packages
)

echo.

REM ==============================================================================
REM Configuration
REM ==============================================================================

echo [STEP 6] Checking configuration...
echo.

set CONFIG_DIR=%USERPROFILE%\.config
set CONFIG_FILE=%CONFIG_DIR%\user_config.yml

if not exist "%CONFIG_DIR%" (
    echo Creating configuration directory: %CONFIG_DIR%
    mkdir "%CONFIG_DIR%"
)

if not exist "%CONFIG_FILE%" (
    if exist _config_template\user_config.yml (
        echo Copying user configuration template...
        copy _config_template\user_config.yml "%CONFIG_FILE%"
        echo [INFO] Please edit %CONFIG_FILE% with your paths
    ) else (
        echo [WARNING] Configuration template not found
    )
) else (
    echo [OK] Configuration file already exists
)

REM Copy .gitignore template for security-first approach
if not exist ".gitignore" (
    if exist _config_template\.gitignore (
        echo.
        echo [SECURITY] Copying secure .gitignore template...
        copy _config_template\.gitignore .gitignore
        echo [INFO] Whitelist .gitignore installed - protects sensitive data
        echo [INFO] Read GITIGNORE-GUIDANCE.md for usage and customization
    )
)

echo.

REM ==============================================================================
REM Verification
REM ==============================================================================

echo [STEP 7] Verifying installation...
echo.

echo Checking R environment...
Rscript -e "cat('R version:', as.character(getRversion()), '\n'); cat('Installed packages:', length(.packages(all.available = TRUE)), '\n')"

echo.

where python >nul 2>&1
if %errorLevel% == 0 (
    echo Checking Python environment...
    python -c "import sys; print(f'Python version: {sys.version}'); import pip; import subprocess; result = subprocess.run([sys.executable, '-m', 'pip', 'list'], capture_output=True, text=True); print(f'Installed packages: {len(result.stdout.splitlines()) - 2}')"
)

echo.

REM ==============================================================================
REM Installation Summary
REM ==============================================================================

echo ================================================================================
echo   Installation Complete!
echo ================================================================================
echo.
echo Next steps:
echo   1. Edit configuration: %CONFIG_FILE%
echo   2. IMPORTANT: Read GITIGNORE-GUIDANCE.md for data security
echo   3. Verify installation: make check
echo   4. Read documentation: README.md
echo.
echo SECURITY NOTICE:
echo   A whitelist .gitignore has been installed to protect sensitive data.
echo   By default, ONLY code and documentation are tracked in git.
echo   Read GITIGNORE-GUIDANCE.md to understand how to customize safely.
echo.
echo Additional tools to install (optional):
echo   - Pandoc:  https://pandoc.org/installing.html
echo   - Quarto:  https://quarto.org/docs/get-started/
echo   - VS Code: https://code.visualstudio.com/
echo   - RStudio: https://posit.co/download/rstudio-desktop/
echo.
echo For help, see: INSTALL.md or TROUBLESHOOTING.md
echo.

pause
