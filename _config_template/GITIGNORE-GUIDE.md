# .gitignore Guide for UNICEF Analytics Projects

## Overview

This guide explains how to properly use `.gitignore` files in UNICEF data analytics projects to ensure sensitive data protection, efficient collaboration, and clean version control.

---

## Table of Contents

- [What is .gitignore?](#what-is-gitignore)
- [Why It Matters](#why-it-matters)
- [Quick Start](#quick-start)
- [What to Ignore](#what-to-ignore)
- [What to Track](#what-to-track)
- [Detailed Categories](#detailed-categories)
- [Team Collaboration](#team-collaboration)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)
- [Examples](#examples)

---

## What is .gitignore?

A `.gitignore` file tells Git which files or directories to **ignore** and never track in version control.

**Key Points**:
- Plain text file named `.gitignore` (note the leading dot)
- Located in project root directory
- Uses pattern matching to specify files to ignore
- Critical for protecting sensitive data and keeping repository clean

---

## Why It Matters

### 1. **Data Protection**
```
❌ NEVER commit to Git:
- Personally Identifiable Information (PII)
- API keys and credentials
- Database connection strings
- Raw survey data
- Confidential reports
```

### 2. **Repository Efficiency**
```
✓ Ignore large files:
- Raw data files (often 100MB+)
- Compiled outputs
- Cache directories
- Temporary files
```

### 3. **Team Collaboration**
```
✓ Ignore personal files:
- User-specific configurations
- IDE settings
- Local environment variables
- Personal notes
```

### 4. **Security Compliance**
```
✓ UNICEF data governance requires:
- No raw data in public repositories
- No credentials in version control
- Audit trail of code, not data
- Clear separation of code and data
```

---

## Quick Start

### 1. Copy Template

```powershell
# Navigate to your project
cd C:\path\to\your\project

# Copy the UNICEF analytics .gitignore template
cp C:\GitHub\mytasks\unicef-analytics-setup\_config_template\.gitignore .gitignore
```

### 2. Review Current Status

```bash
# Check what would be committed
git status

# If sensitive files appear, STOP and update .gitignore
```

### 3. Apply .gitignore

```bash
# Add .gitignore to version control
git add .gitignore
git commit -m "Add .gitignore for analytics project"

# Remove already-tracked files that should be ignored
git rm --cached filename
git rm --cached -r foldername/

# Commit removal
git commit -m "Remove files that should be ignored"
```

### 4. Verify

```bash
# Check status again
git status

# Should NOT see:
# - Data files
# - Credential files
# - Personal config files
```

---

## What to Ignore

### 🔒 **CRITICAL: Always Ignore**

#### Credentials and Secrets
```gitignore
.env
.env.local
credentials.yml
secrets.yml
api_keys.txt
*_credentials.*
*.key
*.pem
```

**Why**: Prevents accidental exposure of passwords, API keys, tokens

**Example Risk**: Committed AWS keys can be exploited in minutes

#### Personal Configuration
```gitignore
user_config.yml
.Renviron
.Rprofile
```

**Why**: Contains user-specific paths and preferences

#### Raw Data
```gitignore
01_data_prep/011_raw_data/**
*.dta
*.sav
*.csv
```

**Why**: 
- Often contains PII
- Files too large for Git
- Should use data management system instead

### 📊 **Situational: Usually Ignore**

#### Processed Data
```gitignore
01_data_prep/013_processed_data/**
*.parquet
*.feather
```

**When to track**: Small reference datasets, lookup tables
**When to ignore**: All large processed files

#### Generated Outputs
```gitignore
03_outputs/031_reports/*.pdf
03_outputs/032_figures/*.png
```

**When to track**: Final publication-ready outputs
**When to ignore**: Intermediate or draft outputs

#### Cache and Temporary Files
```gitignore
cache/
temp/
*.tmp
*.log
```

**Why**: Regenerated on each run, no need to track

---

## What to Track

### ✅ **Always Track**

#### Source Code
```
✓ *.R
✓ *.py
✓ *.do (Stata)
✓ *.Rmd
✓ *.qmd
```

**Why**: Core analytical work, essential for reproducibility

#### Configuration Templates
```
✓ project_config.yml
✓ user_config_TEMPLATE.yml
✓ .env.example
```

**Why**: Shared settings and setup instructions

#### Documentation
```
✓ README.md
✓ *.md
✓ LICENSE
✓ CITATION.cff
```

**Why**: Project information and guidance

#### Project Structure
```
✓ Makefile
✓ .gitignore
✓ profile_*.R
✓ run_*.R
```

**Why**: Project automation and reproducibility

### 📌 **Exceptions: Selective Tracking**

#### Small Reference Data
```gitignore
# Ignore all CSV files
*.csv

# EXCEPT small reference files
!**/reference/**/*.csv
!**/examples/**/*.csv
```

**Use case**: Country codes, indicator definitions, lookup tables

#### Final Outputs
```gitignore
# Ignore all PDFs
*.pdf

# EXCEPT final reports
!03_outputs/031_reports/FINAL_*.pdf
```

**Use case**: Published reports, final deliverables

---

## Detailed Categories

### R-Specific

```gitignore
# Session files
.Rhistory
.RData
.Rproj.user/

# Package development
*.tar.gz
.Rbuildignore

# Environment management
renv/library/
renv/local/
```

**What this protects**:
- Personal R session history
- Temporary workspace data
- Package installation files

### Python-Specific

```gitignore
# Compiled files
__pycache__/
*.py[cod]

# Virtual environments
venv/
.venv/
env/

# Jupyter notebooks
.ipynb_checkpoints/

# Testing
.pytest_cache/
.coverage
```

**What this protects**:
- Compiled Python bytecode
- Personal virtual environments
- Notebook checkpoint data

### Stata-Specific

```gitignore
# Stata outputs
*.smcl
*.log
*.gph

# Temporary files
*.dta.tmp
```

**What this protects**:
- Session logs
- Graph files
- Temporary data files

### IDE and Editor Files

```gitignore
# VS Code
.vscode/
*.code-workspace

# RStudio
.Rproj.user/
*.Rproj

# Jupyter
.ipynb_checkpoints/
```

**Exceptions**: Keep shared IDE settings
```gitignore
.vscode/
!.vscode/settings.json    # Share team settings
!.vscode/tasks.json       # Share build tasks
```

### Operating System Files

```gitignore
# Windows
Thumbs.db
Desktop.ini
$RECYCLE.BIN/

# macOS
.DS_Store
.AppleDouble

# Linux
*~
.directory
```

**Why**: OS-generated files not relevant to project

---

## Team Collaboration

### Setup for New Team Members

**Team Lead** (one-time setup):
```bash
# 1. Create .gitignore in repository
cp template/.gitignore .

# 2. Create template for personal config
cp user_config.yml user_config_TEMPLATE.yml

# 3. Add templates to .gitignore
echo "user_config.yml" >> .gitignore
echo "!user_config_TEMPLATE.yml" >> .gitignore

# 4. Commit
git add .gitignore user_config_TEMPLATE.yml
git commit -m "Add .gitignore and config templates"
git push
```

**New Team Member**:
```bash
# 1. Clone repository
git clone https://github.com/unicef/project.git

# 2. Create personal config from template
cp user_config_TEMPLATE.yml user_config.yml

# 3. Edit with your paths
# (user_config.yml is ignored, won't be committed)

# 4. Create .env file if needed
cp .env.example .env
# Add your API keys (also ignored)
```

### Handling Accidentally Committed Files

**If sensitive file was committed**:

```bash
# 1. IMMEDIATELY remove from Git tracking
git rm --cached sensitive_file.txt

# 2. Add to .gitignore
echo "sensitive_file.txt" >> .gitignore

# 3. Commit removal
git add .gitignore
git commit -m "Remove sensitive file from tracking"

# 4. CRITICAL: Rewrite history to remove file completely
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch sensitive_file.txt" \
  --prune-empty --tag-name-filter cat -- --all

# 5. Force push (coordinate with team!)
git push origin --force --all

# 6. Rotate any exposed credentials immediately
```

**Prevention**: Use pre-commit hooks
```bash
# Install pre-commit
pip install pre-commit

# Create .pre-commit-config.yaml
cat > .pre-commit-config.yaml << EOF
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.4.0
    hooks:
      - id: check-added-large-files
        args: ['--maxkb=500']
      - id: detect-private-key
      - id: check-yaml
EOF

# Install hooks
pre-commit install
```

---

## Best Practices

### 1. **Principle of Least Privilege**

**Rule**: Only commit what's absolutely necessary for reproducibility

```gitignore
# Default: Ignore all data
01_data_prep/011_raw_data/**
01_data_prep/013_processed_data/**

# Exception: Small lookup tables only
!01_data_prep/011_raw_data/reference/country_codes.csv
```

### 2. **Use Comments**

```gitignore
# ==============================================================================
# SENSITIVE DATA - NEVER COMMIT
# ==============================================================================
.env
credentials.yml

# ==============================================================================
# DATA FILES - TOO LARGE FOR GIT
# ==============================================================================
*.csv
*.dta
```

**Why**: Makes .gitignore self-documenting

### 3. **Be Specific with Exceptions**

```gitignore
# ❌ Too broad
!*.csv  # Allows ALL csv files

# ✅ Specific
!reference/country_codes.csv  # Only this one file
!**/examples/**/*.csv         # Only example files
```

### 4. **Test Before Committing**

```bash
# Always check what would be committed
git status

# If in doubt, do a dry-run
git add --dry-run .

# Check for large files
git ls-files | xargs du -sh | sort -rh | head -20
```

### 5. **Document Exceptions**

```gitignore
# Track final report (approved for public release)
# Approved by: John Doe
# Date: 2025-01-09
# Ticket: PROJ-123
!03_outputs/FINAL_REPORT_2025.pdf
```

### 6. **Regular Audits**

```bash
# List all tracked files
git ls-files

# Check for accidentally tracked data files
git ls-files | grep -E "\.(csv|dta|sav|xlsx)$"

# Check file sizes
git ls-files | xargs du -sh | awk '$1 ~ /M|G/ {print}'
```

---

## Troubleshooting

### Problem 1: File still tracked despite being in .gitignore

**Cause**: File was added to Git before .gitignore was created

**Solution**:
```bash
# Remove from Git tracking (keeps local file)
git rm --cached filename

# Commit the removal
git commit -m "Stop tracking filename"
```

### Problem 2: Entire directory ignored when you want to track structure

**Cause**: Directory pattern too broad

**Solution**:
```gitignore
# ❌ Problem: Ignores everything
data/

# ✅ Solution: Track structure, ignore contents
data/**
!data/.gitkeep
!data/README.md
```

Create `.gitkeep` files:
```bash
# Create .gitkeep in empty directories
find . -type d -empty -exec touch {}/.gitkeep \;
```

### Problem 3: .gitignore not working

**Cause**: .gitignore syntax error or file encoding issue

**Solution**:
```bash
# Check file encoding (should be UTF-8)
file .gitignore

# Validate syntax
git check-ignore -v filename

# Test pattern matching
git check-ignore -v **/*.csv
```

### Problem 4: Need to track file that matches ignore pattern

**Solution**: Use exception (!) syntax
```gitignore
# Ignore all CSVs
*.csv

# EXCEPT this one
!important_file.csv

# Or EXCEPT files in specific directory
!reference/*.csv
```

---

## Examples

### Example 1: Education Analysis Project

```gitignore
# ==============================================================================
# Education Analysis Project - .gitignore
# ==============================================================================

# SENSITIVE
.env
credentials.yml

# DATA
01_data_prep/011_raw_data/MICS/**
01_data_prep/011_raw_data/DHS/**
*.dta
*.csv

# EXCEPTIONS: Small reference files
!01_data_prep/011_raw_data/reference/school_codes.csv
!01_data_prep/011_raw_data/reference/country_iso.csv

# OUTPUTS: Ignore drafts, keep finals
03_outputs/figures/*.png
!03_outputs/figures/FINAL_*.png

# R FILES
.Rhistory
.RData
.Rproj.user/

# OS FILES
.DS_Store
Thumbs.db
```

### Example 2: Health Dashboard Project

```gitignore
# ==============================================================================
# Health Dashboard - .gitignore
# ==============================================================================

# CREDENTIALS
.env
api_keys.json

# DATA
data/raw/**
data/processed/**
!data/raw/reference/
!data/processed/.gitkeep

# DASHBOARD CACHE
dashboard/cache/**
*.rds

# OUTPUTS
outputs/dashboard_*.html
!outputs/dashboard_LATEST.html

# PYTHON
__pycache__/
venv/
.ipynb_checkpoints/

# R
.Rhistory
.RData
```

### Example 3: Multi-Language Analytics Project

```gitignore
# ==============================================================================
# Multi-Language Analytics - .gitignore
# ==============================================================================

# UNIVERSAL
.env
credentials.yml
user_config.yml

# DATA
data/**
!data/examples/
!data/reference/
!data/README.md

# R
.Rhistory
.RData
.Rproj.user/
renv/library/

# PYTHON
__pycache__/
venv/
.pytest_cache/

# STATA
*.smcl
*.log
*.gph

# OUTPUTS
outputs/**
!outputs/FINAL_*.pdf
!outputs/FINAL_*.xlsx

# IDE
.vscode/
!.vscode/settings.json
.idea/

# OS
.DS_Store
Thumbs.db
```

---

## Checklist for New Projects

Before first commit:

- [ ] Copy `.gitignore` template to project root
- [ ] Review and customize for project needs
- [ ] Create `user_config_TEMPLATE.yml` for team
- [ ] Add `user_config.yml` to `.gitignore`
- [ ] Create `.env.example` (empty template)
- [ ] Add `.env` to `.gitignore`
- [ ] Test with `git status` - no sensitive files should appear
- [ ] Test with `git add --dry-run .` - verify what would be added
- [ ] Commit `.gitignore` FIRST before adding any data
- [ ] Document any exceptions in project README

---

## Additional Resources

### Tools

**Git Check Ignore**:
```bash
# Check if file would be ignored
git check-ignore -v filename

# Check all files in directory
git check-ignore -v directory/*
```

**GitHub's gitignore templates**:
- https://github.com/github/gitignore

**Pre-commit hooks**:
- https://pre-commit.com/

### Related Documentation
- [PROFILE and RUN Files Guide](PROFILE-RUN-GUIDE.md)
- [Configuration Guide](CONFIG-GUIDE.md)
- [Project Structure](PROJECT-STRUCTURE.md)

### UNICEF Policies
- Data Protection Policy
- Information Security Guidelines
- Code Repositories Standards

---

## Questions?

**Common Questions**:

**Q: Should I commit processed data?**  
A: Usually no. Use data management system. Exception: Small lookup tables.

**Q: What if I already committed sensitive data?**  
A: See "Handling Accidentally Committed Files" section. Act immediately!

**Q: Can I have multiple .gitignore files?**  
A: Yes, in subdirectories. But prefer one root .gitignore for clarity.

**Q: Should I commit .RData files?**  
A: No. These are session-specific and can be large.

**Q: What about final reports?**  
A: Use exceptions to track approved final deliverables only.

---

**Last Updated**: 2025-01-09  
**Version**: 1.0  
**Maintainer**: UNICEF Analytics Team

---

## Emergency Contacts

**If you've accidentally committed sensitive data**:
1. DO NOT PANIC
2. DO NOT continue committing
3. Contact team lead immediately
4. Follow removal procedures above
5. Rotate any exposed credentials
6. Document incident for security review
