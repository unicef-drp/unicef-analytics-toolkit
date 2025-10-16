# Add optional smoke tests for Pandoc/Quarto and config parsing

Labels: tests, quality

## Summary

Extend tests to optionally verify Pandoc/Quarto presence (skip-if-missing) and assert that `_config_template` YAMLs parse in both R and Python.

## Why

Catches broken toolchains/configs early without failing environments that haven't installed optional tools.

## Scope

- R/Python tests: if `pandoc` or `quarto` in PATH, assert `--version` works; else `skip`.
- Add YAML parse tests for `_config_template/*.yml` (R: `yaml::read_yaml`, Python: `yaml.safe_load`).

## Acceptance Criteria

- CI passes with skipped tests when tools are missing.
- Failures occur only if tools exist but fail to respond.
- Coverage includes new tests.
