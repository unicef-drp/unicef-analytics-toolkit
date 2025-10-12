# [P2] Fix R Namespace Issues in Templates

## Priority
**P2 - Medium**

## Status
🔴 Open

## Description
`profile_TEMPLATE.R` has R code quality issues including namespace problems and global variable binding errors.

## Problem Statement
144 R linting errors found, including:
- Uses `%>%` without declaring namespace
- `summarise`, `across`, `everything()` called without proper imports
- Global variable binding issues
- Missing roxygen documentation

## Specific Issues

### profile_TEMPLATE.R (Lines 325-329)
```r
missing_summary <- data %>%
  summarise(across(everything(), ~sum(is.na(.)) / n())) %>%
  pivot_longer(everything(), names_to = "variable", values_to = "missing_pct") %>%
  filter(missing_pct > 0) %>%
  arrange(desc(missing_pct))
```

**Errors:**
- No visible global function definition for `%>%`
- No visible binding for global variable `missing_pct`

## Proposed Solution

### 1. Explicit Namespace Usage
```r
missing_summary <- data %>%
  dplyr::summarise(dplyr::across(dplyr::everything(), ~sum(is.na(.)) / dplyr::n())) %>%
  tidyr::pivot_longer(dplyr::everything(), names_to = "variable", values_to = "missing_pct") %>%
  dplyr::filter(.data$missing_pct > 0) %>%
  dplyr::arrange(dplyr::desc(.data$missing_pct))
```

### 2. Add Package Checks
Ensure required packages are loaded before use

### 3. Use .data Pronoun
Fix global variable binding with `.data$variable`

## Acceptance Criteria
- [ ] All namespace issues resolved
- [ ] Global variable binding errors fixed
- [ ] Code passes `lintr` checks
- [ ] Functions have roxygen documentation
- [ ] Template tested and validated

## Estimated Effort
Low (2-4 hours)

## Labels
`P2`, `code-quality`, `R`, `templates`
