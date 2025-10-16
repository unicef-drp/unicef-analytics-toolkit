# Add Make targets that proxy to tasks.ps1 on Windows

Labels: enhancement, windows, dx

## Summary

Add Make targets (`win-setup`, `win-install`, `win-test`) that invoke `tasks.ps1` so Windows users with Make can use a consistent entry point.

## Why

Bridges GNU Make workflows to native PowerShell without requiring Git Bash usage.

## Scope

- Add Make targets that detect Windows and run:
  - `powershell -ExecutionPolicy Bypass -File .\\tasks.ps1 setup`
  - `powershell -ExecutionPolicy Bypass -File .\\tasks.ps1 install-python -Extras "$(EXTRAS)"`
  - `powershell -ExecutionPolicy Bypass -File .\\tasks.ps1 test`
- Print guidance or skip gracefully on non-Windows OS.

## Acceptance Criteria

- Targets function on Windows and call the appropriate PowerShell tasks.
- README mentions the Make-to-PowerShell bridge for Windows.
