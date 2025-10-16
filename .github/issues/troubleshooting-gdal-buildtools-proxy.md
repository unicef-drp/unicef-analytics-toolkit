# Enhance TROUBLESHOOTING for GDAL/GEOS, Windows build tools, and proxies

Labels: docs, reliability

## Summary

Expand TROUBLESHOOTING.md to include GDAL/GEOS guidance (Windows/macOS), Windows Visual C++ Build Tools and macOS Xcode CLT notes, and corporate proxy configuration for pip/R/conda.

## Why

Common blockers for new users are native library and proxy issues.

## Scope

- Add GDAL/GEOS install/verify instructions and links to official docs and known-good wheel sources.
- Document Visual C++ Build Tools (Windows) and Xcode Command Line Tools (macOS) with links.
- Add proxy setup examples for pip/conda/R and link to system proxy settings.

## Acceptance Criteria

- TROUBLESHOOTING.md includes clear steps and links for GDAL/GEOS installation and verification.
- Build tools installation is documented for Windows/macOS.
- Proxy configuration examples verified on at least one Windows and one Linux host.
