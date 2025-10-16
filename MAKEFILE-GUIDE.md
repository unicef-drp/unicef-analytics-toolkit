# Makefile Guide

Key targets:

- setup: Full environment setup (checks + install + verify)
- check: Verify R, Python, Stata (optional), and tools
- install-r / install-python / install-stata: Install language-specific packages
- create-venv: Create Python virtual environment in ./venv
- test / test-r / test-python: Run test suites
- diagnose: Collect diagnostics into logs/

Run `make help` to see all commands.
