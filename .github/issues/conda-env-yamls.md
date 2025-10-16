# Add conda environment YAMLs for base and geospatial extras

Labels: enhancement, windows, dx

## Summary

Provide `environment-base.yml` and `environment-geo.yml` to simplify installs, especially on Windows where GDAL/GEOS and compiled deps make pip installs brittle.

## Why

Conda/mamba provides prebuilt binaries that avoid common toolchain issues.

## Scope

- Add `environment-base.yml` with core DS stack and notebooks.
- Add `environment-geo.yml` extending base with geospatial libs (geopandas, rasterio, shapely, pyproj, contextily).
- Document usage in README/INSTALL with `mamba env create -f ...` examples.

## Acceptance Criteria

- Base env creation succeeds on Windows, Ubuntu, and macOS.
- Geo env creation succeeds and `python -c "import geopandas"` works.
- README has a concise “Conda option” section.
