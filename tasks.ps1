<#
UNICEF Analytics Toolkit - Windows Tasks
Usage examples (PowerShell):

  # Create venv and install base
  .\tasks.ps1 setup

  # Install base + geo + viz extras
  .\tasks.ps1 install-python -Extras geo,viz

  # Run checks and tests
  .\tasks.ps1 check
  .\tasks.ps1 test
#>

param(
  [Parameter(Position=0)] [string]$Task = "help",
  [string]$Extras = "",
  [string]$Python = "python",
  [string]$VenvPath = "$PSScriptRoot/venv",
  [string]$Constraints = "$PSScriptRoot/constraints.txt"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Ensure-Dir {
  param([string]$Path)
  if (-not (Test-Path $Path)) { New-Item -ItemType Directory -Force -Path $Path | Out-Null }
}

function Get-Pip {
  param([string]$VenvPath)
  # Prefer running pip as a module via python to avoid execution policy or ACL issues
  $pythonExe = Join-Path $VenvPath 'Scripts/python.exe'
  if (Test-Path $pythonExe) { return "$pythonExe -m pip" } else { return 'python -m pip' }
}

function Get-PythonExe {
  param([string]$VenvPath)
  $exe = Join-Path $VenvPath 'Scripts/python.exe'
  if (Test-Path $exe) { return $exe } else { return $Python }
}

function Create-Venv {
  if (-not (Test-Path $VenvPath)) {
    Write-Host "Creating virtual environment at $VenvPath" -ForegroundColor Cyan
    & $Python -m venv $VenvPath
  } else {
    Write-Host "Venv already exists at $VenvPath" -ForegroundColor Yellow
  }
}

function Install-PythonPackages {
  param([string]$ExtrasList)
  Ensure-Dir "$PSScriptRoot/logs"
  $pip = Get-Pip -VenvPath $VenvPath
  $log = Join-Path "$PSScriptRoot/logs" 'python-install.log'

  Write-Host "Using pip: $pip" -ForegroundColor Cyan

  $base = Join-Path $PSScriptRoot 'requirements-python.base.txt'
  if (Test-Path $base) {
    if ((Test-Path $Constraints) -and ((Get-Item $Constraints).Length -gt 0)) {
  & $pip install -r $base -c $Constraints 2>&1 | Tee-Object -FilePath $log
    } else {
  & $pip install -r $base 2>&1 | Tee-Object -FilePath $log
    }
  }

  if ($ExtrasList) {
    $extras = $ExtrasList -split ',' | ForEach-Object { $_.Trim().ToLower() } | Where-Object { $_ -ne '' }
    foreach ($e in $extras) {
      $file = Join-Path $PSScriptRoot ("requirements-python.$e.txt")
      if (Test-Path $file) {
        Write-Host "Installing extra: $e" -ForegroundColor Cyan
        if ((Test-Path $Constraints) -and ((Get-Item $Constraints).Length -gt 0)) {
          & $pip install -r $file -c $Constraints 2>&1 | Tee-Object -FilePath $log -Append
        } else {
          & $pip install -r $file 2>&1 | Tee-Object -FilePath $log -Append
        }
      } else {
        Write-Host "Extra not found: $file" -ForegroundColor Yellow
      }
    }
  }

  $legacy = Join-Path $PSScriptRoot 'requirements-python.txt'
  if (Test-Path $legacy) {
    Write-Host "Installing legacy requirements-python.txt" -ForegroundColor Cyan
    if ((Test-Path $Constraints) -and ((Get-Item $Constraints).Length -gt 0)) {
  & $pip install -r $legacy -c $Constraints 2>&1 | Tee-Object -FilePath $log -Append
    } else {
  & $pip install -r $legacy 2>&1 | Tee-Object -FilePath $log -Append
    }
  }
}

switch ($Task.ToLower()) {
  'help' {
    Write-Host "UNICEF Analytics Toolkit - Windows Tasks" -ForegroundColor Cyan
    Write-Host "Tasks:" -ForegroundColor Cyan
    Write-Host "  setup                Create venv and install base packages"
    Write-Host "  install-python       Install base + extras (use -Extras geo,viz,ml,...)"
    Write-Host "  check                Run environment checks"
    Write-Host "  test                 Run R and Python tests"
    Write-Host "Examples:" -ForegroundColor Cyan
    Write-Host "  .\tasks.ps1 setup"
    Write-Host "  .\tasks.ps1 install-python -Extras geo,viz"
    break
  }
  'setup' {
    Create-Venv
    Install-PythonPackages -ExtrasList $null
    break
  }
  'install-python' {
    Create-Venv
    Install-PythonPackages -ExtrasList $Extras
    break
  }
  'check' {
    Write-Host "R version:" -ForegroundColor Cyan
    & Rscript --version
    Write-Host "Python version:" -ForegroundColor Cyan
    & (Get-PythonExe -VenvPath $VenvPath) --version
    break
  }
  'test' {
    Write-Host "Running R tests..." -ForegroundColor Cyan
    & Rscript -e "testthat::test_dir('tests/testthat')"
    Write-Host "Running Python tests..." -ForegroundColor Cyan
    & (Get-PythonExe -VenvPath $VenvPath) -m pytest tests/python/ -v
    break
  }
  default {
    Write-Host "Unknown task: $Task" -ForegroundColor Red
    exit 1
  }
}
