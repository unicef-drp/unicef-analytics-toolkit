# Populate constraints.txt for CI stability across OS/Python

Labels: enhancement, ci, reliability

## Summary

Populate and adopt `constraints.txt` to stabilize installs across Windows/macOS/Linux and Python 3.9–3.12. Focus on heavy/geo/ML packages that commonly break.

## Why

Reduce build variance and dependency churn causing CI failures or slow debugging cycles.

## Scope

- Populate `constraints.txt` with tested versions for: numpy, pandas, shapely, pyproj, rasterio, prophet, torch, tensorflow (and other problematic deps as needed).
- Update CI workflows to install with `-c constraints.txt`.
- Add a brief README/TROUBLESHOOTING note on when/how to use constraints.

## Acceptance Criteria

- CI green across all matrix jobs, using constraints.
- README shows `pip install ... -c constraints.txt` example(s).
- Constraints only pin known-problematic libs; reviewed quarterly.

## Tasks

- [ ] Identify minimal pin set from recent CI runs and local tests.
- [ ] Update `constraints.txt` and document rationale inline.
- [ ] Update GitHub Actions to pass the constraints flag.
- [ ] Add README/TROUBLESHOOTING guidance.
- [ ] Run matrix CI and verify green.
