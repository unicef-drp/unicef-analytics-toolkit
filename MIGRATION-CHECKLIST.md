# Quick Migration Checklist

## Renaming: UNICEF Analytics Setup → UNICEF Analytics Toolkit

---

## ✅ Completed (2025-10-10)

- [x] README.md - Title and all references updated
- [x] WORLDBANK-INTEGRATION.md - Contact section and project name updated
- [x] ENHANCEMENT-SUMMARY.md - Title and changelog updated
- [x] RENAME-DECISION.md - Created (rationale documented)
- [x] MIGRATION-CHECKLIST.md - Created (this file)

---

## 📋 To Do: Documentation

- [ ] INSTALL.md - Update repository URLs
- [ ] CONFIG-SIMPLE.md - Update project references
- [ ] PROFILE-RUN-GUIDE.md - Update examples with new name
- [ ] GITIGNORE-GUIDE.md - Update examples with new name
- [ ] CONFIG-GUIDE.md - Update project references
- [ ] Any other .md files in `_config_template/`

---

## 📋 To Do: Scripts

- [ ] install-windows.bat - Update messages/comments
- [ ] install-unix.sh - Update messages/comments
- [ ] install-r-packages.R - Update header/comments
- [ ] install-python-packages.py - Update header/comments
- [ ] requirements-stata.do - Update header/comments
- [ ] Makefile - Update help messages and comments
- [ ] profile_SIMPLE.R - Update header/comments
- [ ] Any script in `_config_template/`

---

## 📋 To Do: Configuration Files

- [ ] _config_template/user_config_UNIVERSAL.yml - Update comments
- [ ] _config_template/project_config_OPTIONAL.yml - Update comments
- [ ] package.json (if exists) - Update name, repository
- [ ] Any other config files

---

## 📋 To Do: Directory Structure

```powershell
# Windows: Rename local directory
cd C:\GitHub\mytasks
Rename-Item unicef-analytics-setup unicef-analytics-toolkit
```

```bash
# macOS/Linux: Rename local directory
cd ~/GitHub/mytasks
mv unicef-analytics-setup unicef-analytics-toolkit
```

Optional: Create new organized structure
```
unicef-analytics-toolkit/
├── setup/              # Move installation scripts here
├── toolkit/            # Create for utilities (future)
├── templates/          # Move _config_template/ here
└── docs/              # Move documentation here
```

---

## 📋 To Do: Git/GitHub

If you control the repository:

- [ ] GitHub: Rename repository in Settings
  - Go to Settings → General → Repository name
  - Change to: `analytics-toolkit`

- [ ] Update local git remote:
  ```bash
  git remote set-url origin https://github.com/unicef/analytics-toolkit.git
  ```

- [ ] Update any submodules or dependencies

- [ ] Create redirect from old URL (if applicable)

---

## 📋 To Do: Package Metadata

If creating R package:
- [ ] DESCRIPTION file - Update Package name
- [ ] R package documentation - Update references
- [ ] Vignettes - Update examples

If creating Python package:
- [ ] setup.py - Update name, url
- [ ] pyproject.toml - Update project name
- [ ] __init__.py - Update package docstring

---

## 📋 To Do: Communication

- [ ] Announce rename to UNICEF analytics community
- [ ] Update any internal wikis or documentation
- [ ] Update any training materials
- [ ] Notify active collaborators

---

## 🔍 Search & Replace Guide

Use these patterns to find remaining references:

**Search for**:
- `unicef-analytics-setup`
- `analytics-setup`
- `Analytics Setup`
- `analytics setup`
- `Setup` (in titles/headers)

**Replace with**:
- `unicef-analytics-toolkit`
- `analytics-toolkit`
- `Analytics Toolkit`
- `analytics toolkit`
- `Toolkit`

**Tools**:
```powershell
# Windows: Search all files
Get-ChildItem -Recurse -Include *.md,*.R,*.py,*.sh,*.bat | Select-String "analytics-setup"

# Find and replace (PowerShell)
Get-ChildItem -Recurse -Include *.md | ForEach-Object {
    (Get-Content $_.FullName) -replace 'analytics-setup', 'analytics-toolkit' | Set-Content $_.FullName
}
```

```bash
# macOS/Linux: Search all files
grep -r "analytics-setup" --include="*.md" --include="*.R" --include="*.py"

# Find and replace (Unix)
find . -type f \( -name "*.md" -o -name "*.R" -o -name "*.py" \) -exec sed -i 's/analytics-setup/analytics-toolkit/g' {} +
```

---

## ✅ Verification

After completing migrations:

- [ ] All URLs resolve correctly
- [ ] All scripts run without errors
- [ ] Documentation builds correctly
- [ ] No broken links
- [ ] Git remote works
- [ ] README displays correctly

---

## 📅 Timeline

**Week 1** (2025-10-10 to 2025-10-17):
- Update all documentation files
- Update all script headers
- Rename local directory

**Week 2** (2025-10-17 to 2025-10-24):
- Update GitHub repository (if applicable)
- Announce to community
- Update external references

**Week 3** (2025-10-24 onwards):
- Monitor for issues
- Update any missed references
- Finalize new structure

---

## 🆘 Rollback Plan

If issues arise:

```bash
# Revert git commits
git revert <commit-hash>

# Rename back
mv unicef-analytics-toolkit unicef-analytics-setup

# Restore old remote
git remote set-url origin <old-url>
```

Keep backup of original files in `_backup_2025-10-10/`

---

**Started**: 2025-10-10  
**Target Completion**: 2025-10-24  
**Status**: In Progress
