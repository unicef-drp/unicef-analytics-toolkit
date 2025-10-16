# Troubleshooting

If R packages fail on Windows, ensure Rtools is installed and on PATH.
Use binary packages on Windows: run `make install-r` or in R set `type="binary"`.
For Python build errors, install build tools (Windows: Visual C++ Build Tools).
If Stata commands are not found, add Stata to PATH or run from Stata GUI.
For Pandoc/Quarto issues, install from official installers and verify with `pandoc --version` / `quarto --version`.

## Collect diagnostics

Run `make diagnose` to save system info and package lists under logs/.
