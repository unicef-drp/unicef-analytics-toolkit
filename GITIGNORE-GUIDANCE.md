# UNICEF Analytics Projects - .gitignore Guidance

**Security-First Approach for Child Protection Data**

---

## Table of Contents

1. [Philosophy: Why Whitelist?](#philosophy-why-whitelist)
2. [UNICEF-Specific Security Concerns](#unicef-specific-security-concerns)
3. [Quick Start](#quick-start)
4. [How the Whitelist Works](#how-the-whitelist-works)
5. [Customization Examples](#customization-examples)
6. [Common Scenarios](#common-scenarios)
7. [Verification & Testing](#verification--testing)
8. [Security Checklist](#security-checklist)
9. [Troubleshooting](#troubleshooting)
10. [Resources](#resources)

---

## Philosophy: Why Whitelist?

### Traditional Approach (Blacklist) ❌

```gitignore
# Ignore data files
*.csv
*.dta
*.xlsx

# But allow examples
!examples/*.csv
```

**Problem**: Everything is tracked by default UNLESS you remember to exclude it.

**Risk**: New file type? Automatically committed. Forgot one pattern? Data leak.

### Whitelist Approach ✅

```gitignore
# Ignore everything
*

# Only allow code
!*.R
!*.py
!*.do
```

**Benefit**: Nothing is tracked UNLESS explicitly allowed.

**Safety**: New file type? Automatically ignored. Even if you forget, data is protected.

---

## UNICEF-Specific Security Concerns

### Why This Matters for UNICEF

UNICEF analytics projects involve highly sensitive data:

1. **Child Protection Data**
   - Individual-level child welfare records
   - Vulnerable population statistics
   - Intervention outcomes
   - **Risk**: Any data leak could endanger children

2. **Personally Identifiable Information (PII)**
   - Names, ages, locations
   - Family structures
   - Health records
   - **Risk**: Privacy violations, legal liability

3. **Multi-Country Operations**
   - Different data protection laws (GDPR, local regulations)
   - Varying consent requirements
   - Cross-border data transfer restrictions
   - **Risk**: Legal compliance violations

4. **External Collaborations**
   - Universities with student researchers
   - NGO partners with varied security practices
   - Government counterparts
   - **Risk**: Weakest link in security chain

5. **Git History is Permanent**
   - Once committed, data lives forever in git history
   - Extremely difficult to fully remove
   - Can propagate to clones/forks
   - **Risk**: "Deleting" file doesn't remove from history

### Real-World Scenario

```
❌ TRADITIONAL APPROACH:
Day 1: Analyst creates new dataset format: *.feather
Day 2: Commits code, git auto-tracks *.feather file
Day 3: Pushes to GitHub
Day 4: Data protection violation discovered
Day 5: Impossible to fully remove from git history
Result: Data leak, potential harm to children

✅ WHITELIST APPROACH:
Day 1: Analyst creates new dataset format: *.feather
Day 2: File is automatically ignored (not in allowlist)
Day 3: Commits only code, data stays local
Day 4: No violation, children protected
Result: Safe by default
```

---

## Quick Start

### Step 1: Copy Template to Your Project

```powershell
# Windows
Copy-Item C:\GitHub\mytasks\unicef-analytics-toolkit\_config_template\.gitignore .\.gitignore

# Unix/Mac
cp ~/unicef-analytics-toolkit/_config_template/.gitignore ./.gitignore
```

### Step 2: Initialize Git (if new project)

```bash
git init
git add .
git status
```

**Expected**: You should see ONLY code and documentation files, NO data files.

### Step 3: Test Before First Commit

```bash
# Check what will be committed
git status

# Verify no data files listed
git status | grep -E "\.(csv|dta|xlsx|sav|parquet)$"

# Should return nothing. If data files appear, FIX BEFORE COMMITTING.
```

### Step 4: Commit Safely

```bash
git add .
git commit -m "Initial commit - code and documentation only"
```

---

## How the Whitelist Works

### 12-Step Process

The `_config_template/.gitignore` uses a layered approach:

```gitignore
# STEP 1: Ignore everything
*

# STEP 2-6: Explicitly allow safe files
!*.R
!*.py
!*.md
# ... etc

# STEP 7-12: Override exceptions (never commit these)
**/*_SENSITIVE.*
*.dta
.env
# ... etc
```

### Layer Hierarchy

```
Priority 1 (Highest):  OVERRIDE - Sensitive files
Priority 2:            OVERRIDE - Large data files  
Priority 3:            OVERRIDE - Generated/temp files
Priority 4:            ALLOW - Small test/reference data
Priority 5:            ALLOW - Configuration files
Priority 6:            ALLOW - Documentation
Priority 7:            ALLOW - Code files
Priority 8 (Lowest):   IGNORE - Everything else
```

**Example**:
- `analysis.R` → Allowed (code file)
- `test_data.csv` in `tests/` → Allowed (test data in approved location)
- `real_data.csv` in root → Blocked (not in approved location)
- `survey_SENSITIVE.dta` → Blocked (override, even if in tests/)

---

## Customization Examples

### Example 1: Allow Specific Output PDF

**Scenario**: Your annual report PDF needs to be version controlled.

```gitignore
# Add AFTER the "ALLOW - DOCUMENTATION" section
!reports/annual_report_2024.pdf
```

**Better approach**: Generate report from code, don't commit output.

### Example 2: Allow Small Lookup Table

**Scenario**: You have a small country codes CSV that's reference data.

```gitignore
# Add AFTER the "ALLOW - SMALL REFERENCE DATA" section
!data/lookup_tables/*.csv
```

**Verify**: File is < 100KB, contains no PII, is truly reference data.

### Example 3: Allow Documentation Images

**Scenario**: Methodology diagrams need to be version controlled.

```gitignore
# Add AFTER the "ALLOW - DOCUMENTATION" section
!documentation/methodology/*.png
!documentation/methodology/*.jpg
```

### Example 4: Block Custom Sensitive File Type

**Scenario**: Your project uses `.census` files that must never be committed.

```gitignore
# Add in the "OVERRIDE - SENSITIVE FILES" section
*.census
**/*.census
```

### Example 5: Allow Specific Jupyter Notebook Output

**Scenario**: One specific notebook with documented outputs for review.

```gitignore
# Add AFTER the "ALLOW - CODE FILES" section
!notebooks/data_quality_report.ipynb

# But still block all other notebooks' outputs
**/.ipynb_checkpoints/
```

---

## Common Scenarios

### Scenario: "Git won't track my code file!"

**Problem**: Created new code file, `git status` doesn't show it.

**Solution**: Check file extension is in allowlist:

```bash
# Check current allowlist
grep "^!" .gitignore | grep -E "\*\.(R|py|do|sh)$"

# If missing, add to .gitignore:
!*.yourextension
```

### Scenario: "Git is tracking a data file!"

**Problem**: `git status` shows `data/survey.csv`.

**Solution**: 

```bash
# 1. Verify file shouldn't be tracked
#    - Is it >100KB? 
#    - Does it contain PII?
#    - Is it in root/data/ directory?

# 2. If it shouldn't be tracked, add override:
echo "data/*.csv" >> .gitignore

# 3. Remove from git (keep local copy):
git rm --cached data/survey.csv

# 4. Verify:
git status  # Should not show survey.csv
```

### Scenario: "I need to track small test dataset"

**Problem**: Have 5KB test CSV for unit tests.

**Solution**:

```bash
# 1. Put in approved location:
mkdir -p tests/data
mv test.csv tests/data/

# 2. Verify .gitignore allows tests/**/*.csv
grep "!tests/\*\*/\*\.csv" .gitignore

# 3. Add and verify:
git add tests/data/test.csv
git status  # Should show the file
```

### Scenario: "Collaborator committed data file"

**Problem**: Team member pushed sensitive data to repository.

**Solution**:

```bash
# 1. IMMEDIATE: Remove file from latest commit
git rm --cached path/to/sensitive/file.csv
git commit --amend -m "Remove sensitive data file"
git push --force  # CAUTION: Rewrites history

# 2. THOROUGH: Remove from entire history (complex)
# Use BFG Repo-Cleaner or git filter-branch
# See: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository

# 3. PREVENT: Update .gitignore to block that file type
echo "*.problematic_extension" >> .gitignore

# 4. REVIEW: Check with Data Protection Officer
```

---

## Verification & Testing

### Pre-Commit Checklist

```bash
# 1. What will be committed?
git status

# 2. Any data files? (should be NONE)
git status | grep -E "\.(csv|dta|xlsx|sav|parquet|feather|rds|RData)$"

# 3. Any sensitive files? (should be NONE)
git status | grep -i "sensitive\|confidential\|pii\|credential\|secret\|password"

# 4. Check file sizes (should be < 1MB typically)
git ls-files --stage | awk '{print $4}' | xargs ls -lh

# 5. Review actual content of staged files
git diff --cached
```

### Post-Commit Verification

```bash
# 1. What's in the repository?
git ls-files

# 2. Any data files made it through? (manual review)
git ls-files | grep -E "\.(csv|dta|xlsx)$"

# 3. Check repository size (should be small for code-only)
git count-objects -vH

# 4. If large, investigate:
git ls-files | xargs ls -lh | sort -k5 -h | tail -20
```

### Automated Pre-Commit Hook

Create `.git/hooks/pre-commit`:

```bash
#!/bin/bash
# UNICEF Data Protection Pre-Commit Hook

echo "🛡️  Running UNICEF data protection checks..."

# Check for data files
DATA_FILES=$(git diff --cached --name-only | grep -E "\.(csv|dta|xlsx|sav|parquet|feather|rds|RData)$")

if [ ! -z "$DATA_FILES" ]; then
    echo "❌ ERROR: Data files detected in commit:"
    echo "$DATA_FILES"
    echo ""
    echo "Data files should NOT be committed to git."
    echo "Store data in: OneDrive, SharePoint, or dedicated data storage."
    exit 1
fi

# Check for sensitive keywords in filenames
SENSITIVE=$(git diff --cached --name-only | grep -iE "sensitive|confidential|pii|credential|secret|password")

if [ ! -z "$SENSITIVE" ]; then
    echo "⚠️  WARNING: Sensitive keywords in filenames:"
    echo "$SENSITIVE"
    echo ""
    read -p "Are you SURE these should be committed? (yes/no): " CONFIRM
    if [ "$CONFIRM" != "yes" ]; then
        exit 1
    fi
fi

echo "✅ Pre-commit checks passed"
exit 0
```

Make executable:
```bash
chmod +x .git/hooks/pre-commit
```

---

## Security Checklist

### Before First Commit

- [ ] Copied `_config_template/.gitignore` to project root
- [ ] Read this guidance document
- [ ] Tested `git status` shows only code/docs
- [ ] Verified no data files in `git status`
- [ ] Set up pre-commit hook (optional but recommended)

### Before Every Commit

- [ ] Ran `git status` to review what will be committed
- [ ] Checked for data file extensions
- [ ] Checked for sensitive keywords in filenames
- [ ] Reviewed file sizes (> 1MB is suspicious)
- [ ] Used `git diff --cached` to review actual content

### Before Pushing to Remote

- [ ] Ran `git log --stat` to review what will be pushed
- [ ] Verified repository size is reasonable (< 10MB typically)
- [ ] Checked `git ls-files` for unexpected files
- [ ] Confirmed no sensitive data in commit messages

### Monthly Audit

- [ ] Review `.gitignore` for needed updates
- [ ] Check `git ls-files` for any data files
- [ ] Review repository size: `git count-objects -vH`
- [ ] Discuss data protection with team

### After Sensitive Data Incident

- [ ] **IMMEDIATELY**: Contact UNICEF Data Protection Officer
- [ ] Remove file from latest commit (if just committed)
- [ ] Consider removing from entire history (complex)
- [ ] Update `.gitignore` to prevent recurrence
- [ ] Review incident with team
- [ ] Update security procedures

---

## Troubleshooting

### "Why isn't my code file being tracked?"

**Diagnosis**:
```bash
# Check if file matches allowlist
git check-ignore -v yourfile.R

# If output shows it's ignored, check .gitignore
grep -n "yourfile.R" .gitignore
```

**Solutions**:
1. Ensure file extension is in allowlist (e.g., `!*.R`)
2. Check for override rules blocking it
3. Verify file isn't in ignored directory

### "Git is tracking too many files"

**Diagnosis**:
```bash
# See what's tracked
git ls-files

# See what's staged
git status
```

**Solution**:
Your `.gitignore` may not have `*` at the top. Verify:
```bash
head -n 30 .gitignore | grep "^*$"
```

### "I already committed sensitive data"

**Immediate action**:
```bash
# 1. Remove from staging/latest commit
git rm --cached sensitive_file.csv
git commit --amend -m "Remove sensitive data"

# 2. If already pushed, force push (DANGER)
git push --force-with-lease

# 3. Contact Data Protection Officer
# 4. See: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository
```

### "Whitelist is too restrictive"

**Philosophy**: That's intentional. Security by default.

**Approach**: Don't weaken the whitelist. Instead:

1. Ask: "Does this file NEED to be in git?"
   - Data: NO → Use OneDrive/SharePoint
   - Generated output: NO → Regenerate from code
   - Code/config: YES → Add specific exception

2. If truly needed, add targeted exception:
   ```gitignore
   !specific/file.txt
   ```

3. Never add broad exceptions like `!*.csv` in root

---

## Resources

### UNICEF Policies

- **Data Protection Policy**: [Internal UNICEF Link]
- **Information Security Guidelines**: [Internal UNICEF Link]
- **Child Safeguarding**: [Internal UNICEF Link]

### Git Security

- [GitHub: Removing Sensitive Data](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository)
- [BFG Repo-Cleaner](https://rtyley.github.io/bfg-repo-cleaner/)
- [git-filter-branch](https://git-scm.com/docs/git-filter-branch)

### Best Practices

- [OWASP: Secrets in Code](https://owasp.org/www-community/vulnerabilities/Use_of_hard-coded_password)
- [Git Best Practices](https://git-scm.com/book/en/v2)
- [.gitignore Documentation](https://git-scm.com/docs/gitignore)

### UNICEF Toolkit

- **Installation Guide**: `README.md`
- **Configuration Template**: `_config_template/`
- **Testing Guide**: `TESTING.md`
- **Support**: Create issue in toolkit repository

---

## Questions?

### Security Questions
Contact: UNICEF Data Protection Officer

### Technical Questions  
Contact: Analytics Toolkit Maintainers (see `README.md`)

### Urgent Data Leak
1. **STOP**: Don't push to remote
2. **CONTACT**: Data Protection Officer immediately
3. **PRESERVE**: Don't delete files until advised
4. **DOCUMENT**: Note what happened, when, who has access

---

## Summary

### Key Principles

1. **Whitelist by default**: Nothing tracked unless explicitly allowed
2. **Code, not data**: Version control code, store data elsewhere
3. **Security first**: When in doubt, keep it out
4. **Test before commit**: Verify what you're committing
5. **Audit regularly**: Monthly reviews catch mistakes

### File Categories

| Category | Action | Storage |
|----------|--------|---------|
| Code (`.R`, `.py`, `.do`) | ✅ Commit | Git |
| Documentation (`.md`, `.txt`) | ✅ Commit | Git |
| Configuration (`.yml`, `.json`) | ✅ Commit | Git |
| Small test data (< 100KB) | ⚠️ Commit (carefully) | Git |
| Real data (any size) | ❌ Never commit | OneDrive/SharePoint |
| Sensitive data | ❌ Never commit | Secure storage |
| Generated outputs | ❌ Don't commit | Regenerate from code |

### Remember

**The whitelist `.gitignore` protects children by protecting their data. Use it correctly.**

---

*Last Updated: 2025-10-12*  
*Version: 2.0.0*  
*Part of UNICEF Analytics Toolkit*
