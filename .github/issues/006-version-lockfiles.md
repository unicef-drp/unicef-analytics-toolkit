# [P2] Add Version Lockfiles for Reproducibility

## Priority
**P2 - Medium**

## Status
🔴 Open

## Description
Current requirements files use loose version constraints, which can lead to breaking changes and non-reproducible installations.

## Problem Statement
- `requirements-python.txt` uses `>=` without upper bounds
- No exact version lockfiles for reproducibility
- Different users may get different package versions
- Cannot guarantee environment reproducibility

## Proposed Solution

### 1. Python Lockfiles
Create `requirements-lock.txt` with exact versions:
```txt
numpy==1.24.3
pandas==2.0.2
scipy==1.10.1
# ... exact versions
```

Generate with: `pip freeze > requirements-lock.txt`

### 2. R Lockfiles
Use `renv` for R dependency management:
- Initialize `renv` in project
- Generate `renv.lock` with exact versions
- Provide instructions for restoration

### 3. Version Constraint Strategy
Update `requirements-*.txt` with sensible ranges:
```txt
numpy>=1.24.0,<2.0.0
pandas>=2.0.0,<3.0.0
```

## Acceptance Criteria
- [ ] `requirements-lock.txt` created for Python
- [ ] `renv.lock` created for R
- [ ] Documentation on using lockfiles
- [ ] CI/CD tests both loose and locked versions
- [ ] Update instructions in README

## Estimated Effort
Low (2-4 hours)

## Labels
`P2`, `dependencies`, `reproducibility`, `versioning`
