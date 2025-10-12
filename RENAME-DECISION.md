# Project Rename: Setup → Toolkit

## Date: 2025-10-10

### Decision

Renamed project from **"UNICEF Analytics Setup"** to **"UNICEF Analytics Toolkit"**

---

## Rationale

### 1. **Accurate Representation**

**Content Analysis**:
- ✅ Installation scripts: ~20%
- ✅ Quality assurance utilities: ~30%
- ✅ Helper functions: ~25%
- ✅ Templates & workflows: ~15%
- ✅ Documentation system: ~10%

**Conclusion**: 80% toolkit utilities vs 20% setup → "Toolkit" is more accurate

### 2. **Industry Alignment**

**Peer Organizations**:
- World Bank: **EduAnalytics Toolkit**
- WHO: Analytics **Toolkit**
- R Ecosystem: dev**tools**, data.table **toolkit**

**Standard**: Analytics utilities = "Toolkit"

### 3. **User Expectations**

| Term | User Perception |
|------|----------------|
| **Setup** | "One-time installation helper" |
| **Toolkit** | "Professional tools I use regularly" |

### 4. **Future Scope**

**Planned Components**:
- `unicefanalytics` R package (toolkit)
- `unicef_analytics` Python package (toolkit)
- Quality assurance framework (toolkit)
- Metadata management (toolkit)
- Data comparison utilities (toolkit)

All are **toolkit** deliverables, not setup.

---

## Changes Made

### Files Updated

1. **README.md**
   - Title: "UNICEF Analytics Toolkit"
   - Purpose statement updated
   - Repository URLs updated
   - Four key components highlighted

2. **WORLDBANK-INTEGRATION.md**
   - Contact section updated
   - Repository URL updated
   - Project name updated throughout

3. **ENHANCEMENT-SUMMARY.md**
   - Title updated
   - Rename rationale added to changelog
   - Version 2.0 designation

4. **RENAME-DECISION.md** (NEW)
   - This document explaining the decision

### Repository Structure (Recommended)

**Before**:
```
unicef-analytics-setup/
├── install-*.sh
├── requirements-*.txt
├── profile_SIMPLE.R
└── docs/
```

**After** (Proposed):
```
unicef-analytics-toolkit/
├── setup/              # Installation & configuration
├── toolkit/            # Core utilities (NEW!)
│   ├── R/
│   ├── Python/
│   └── Stata/
├── templates/          # Project templates
└── docs/              # Documentation
```

---

## Migration Guide

### For Users

**No action required** if using current version. Future updates will:

1. Use new repository name
2. Organized structure with `toolkit/` folder
3. Installable packages: `install.packages("unicefanalytics")`

### For Contributors

**Update local repository**:

```powershell
# Windows
cd C:\GitHub\mytasks
Rename-Item unicef-analytics-setup unicef-analytics-toolkit
cd unicef-analytics-toolkit

# Update remote (if you control the repo)
git remote set-url origin https://github.com/unicef/analytics-toolkit.git
```

**Update documentation references**:
- Replace "setup" with "toolkit" in docs
- Update URLs to new repository name
- Update package references

---

## Benefits

### ✅ **Clarity**
Users immediately understand this is an **ongoing toolkit**, not just installation help

### ✅ **Discoverability**
"UNICEF analytics toolkit" searches will find this project

### ✅ **Professional Positioning**
Aligns with World Bank, WHO, and other professional analytics organizations

### ✅ **Accurate Branding**
Name matches content (utilities + setup, not just setup)

### ✅ **Future-Proof**
Name accommodates planned R/Python packages and utilities

---

## Timeline

**Completed** (2025-10-10):
- ✅ Decision made
- ✅ Core documentation updated (README, WORLDBANK-INTEGRATION, ENHANCEMENT-SUMMARY)
- ✅ Rationale documented

**Next Steps** (Week of 2025-10-14):
- [ ] Rename local directory
- [ ] Update all installation scripts
- [ ] Create `toolkit/` subfolder structure
- [ ] Update all internal documentation references

**Future** (Next 2 months):
- [ ] Publish to GitHub under new name
- [ ] Announce rename to UNICEF analytics community
- [ ] Redirect old URLs (if applicable)

---

## Communication

### Internal Announcement Template

```
Subject: UNICEF Analytics Setup → UNICEF Analytics Toolkit

Dear Colleagues,

We've renamed our project from "UNICEF Analytics Setup" to "UNICEF Analytics Toolkit" 
to better reflect its scope and align with industry standards.

What this means:
- More than just installation - it's a comprehensive toolkit
- Growing library of quality assurance and data utilities
- Aligns with World Bank EduAnalyticsToolkit approach

Repository: https://github.com/unicef/analytics-toolkit
Documentation: [link]

Questions? Contact: data@unicef.org

Best regards,
UNICEF Chief Statistician Office
```

---

## Approval

**Recommended by**: Analytics Development Team  
**Approved by**: Chief Statistician Office  
**Date**: 2025-10-10  
**Status**: ✅ Approved and Implemented

---

## References

- World Bank EduAnalyticsToolkit: https://github.com/worldbank/EduAnalyticsToolkit
- WORLDBANK-INTEGRATION.md - Integration plan
- ENHANCEMENT-SUMMARY.md - Complete enhancement summary
- README.md - Updated project overview
