# Complete Package List - UNICEF Analytics Environment

This document provides a comprehensive inventory of all software, packages, and dependencies included in the UNICEF Analytics Environment Setup.

## Table of Contents

- [System Requirements](#system-requirements)
- [R Packages](#r-packages)
- [Python Packages](#python-packages)
- [Stata Packages](#stata-packages)
- [Repository Compatibility](#repository-compatibility)

---

## System Requirements

### Core Software

| Software | Minimum Version | Purpose | Required |
|----------|----------------|---------|----------|
| **R** | 4.0.0 | Statistical computing | ✅ Yes |
| **Python** | 3.9 | Data science | ⭐ Recommended |
| **Git** | 2.30 | Version control | ⭐ Recommended |
| **Stata** | 15 | Econometric analysis | ⚪ Optional |
| **Pandoc** | 2.11 | Document conversion | ⭐ Recommended |
| **Quarto** | 1.3 | Scientific publishing | ⭐ Recommended |

### Development Tools

| Tool | Purpose | Recommended |
|------|---------|-------------|
| **VS Code** | Code editor | ✅ |
| **RStudio** | R IDE | ⭐ |
| **Jupyter** | Interactive notebooks | ⭐ |
| **radian** | Enhanced R console | ⭐ |

---

## R Packages

### Summary
- **Total Packages**: ~90
- **Installation Time**: 15-30 minutes
- **Storage Required**: ~500 MB

### Core Data Manipulation (10 packages)
```
tidyverse          # Meta-package including dplyr, ggplot2, tidyr, readr, purrr, tibble, stringr, forcats
dplyr              # Data manipulation
tidyr              # Data tidying
data.table         # Fast data operations
purrr              # Functional programming
magrittr           # Pipe operators
rlang              # R language API
```

### Data Import/Export (8 packages)
```
readr              # Fast CSV reading
readxl             # Excel import
openxlsx           # Excel creation
writexl            # Fast Excel writing
haven              # SPSS, Stata, SAS
foreign            # Legacy formats
xlsx               # Java-based Excel
rio                # Universal I/O
```

### Statistical Analysis (6 packages)
```
summarytools       # Summary statistics
srvyr              # Survey analysis
survey             # Complex surveys
weights            # Weighted stats
Hmisc              # Statistical functions
psych              # Psychometric tools
```

### External Data APIs (6 packages)
```
Rilostat           # ILO data
wbstats            # World Bank data
countrycode        # Country codes
WDI                # World Development Indicators
eurostat           # Eurostat data
OECD               # OECD data
```

### Visualization (15 packages)
```
ggplot2            # Grammar of graphics
ggrepel            # Label positioning
cowplot            # Publication plots
patchwork          # Combining plots
scales             # Scale functions
viridis            # Color palettes
wesanderson        # Wes Anderson palettes
RColorBrewer       # ColorBrewer
gridExtra          # Grid extras
ggcorrplot         # Correlation plots
GGally             # ggplot2 extensions
plotly             # Interactive plots
```

### Reporting (11 packages)
```
knitr              # Dynamic reports
rmarkdown          # R Markdown
pandoc             # Pandoc integration
quarto             # Quarto publishing
DT                 # Interactive tables
gt                 # Grammar of Tables
flextable          # Flexible tables
kableExtra         # Enhanced knitr tables
bookdown           # Long documents
pagedown           # Paged HTML
sass               # CSS preprocessor
```

### Spatial Analysis (3 packages)
```
sf                 # Simple Features
raster             # Raster data
sp                 # Spatial classes
```

### Code Quality (7 packages)
```
devtools           # Package development
usethis            # Workflow automation
testthat           # Unit testing
lintr              # Code linting
styler             # Code formatting
roxygen2           # Documentation
pkgdown            # Package websites
```

### Complete List
See [requirements-r.txt](requirements-r.txt) for full list with versions.

---

## Python Packages

### Summary
- **Total Packages**: ~100+
- **Installation Time**: 20-40 minutes
- **Storage Required**: ~2-3 GB

### Core Data Science (8 packages)
```
numpy              # Numerical computing
pandas             # Data manipulation
scipy              # Scientific computing
matplotlib         # Plotting
seaborn            # Statistical visualization
plotly             # Interactive plots
statsmodels        # Statistical models
scikit-learn       # Machine learning
```

### Data Manipulation (7 packages)
```
polars             # Fast DataFrames
dask               # Parallel computing
openpyxl           # Excel handling
xlrd               # Excel reading
xlsxwriter         # Excel writing
pyreadstat         # SAS/SPSS/Stata
pyarrow            # Arrow format
```

### Web & APIs (6 packages)
```
requests           # HTTP library
urllib3            # HTTP client
httpx              # Async HTTP
aiohttp            # Async HTTP
beautifulsoup4     # Web scraping
lxml               # XML processing
```

### Jupyter Ecosystem (9 packages)
```
jupyter            # Jupyter meta-package
jupyterlab         # JupyterLab interface
notebook           # Jupyter Notebook
ipython            # Enhanced Python shell
ipykernel          # Jupyter kernel
ipywidgets         # Interactive widgets
nbconvert          # Notebook conversion
nbformat           # Notebook format
voila              # Dashboard creation
```

### Visualization (9 packages)
```
altair             # Declarative visualization
bokeh              # Interactive visualization
holoviews          # Data exploration
hvplot             # High-level plotting
panel              # Dashboards
dash               # Plotly dashboards
streamlit          # Web apps
plotnine           # ggplot2 for Python
```

### Geospatial (6 packages)
```
geopandas          # Spatial DataFrames
folium             # Interactive maps
shapely            # Geometric operations
rasterio           # Raster data
pyproj             # Cartographic projections
contextily         # Basemaps
```

### Machine Learning (7 packages)
```
xgboost            # Gradient boosting
lightgbm           # Gradient boosting
catboost           # Gradient boosting
tensorflow         # Deep learning
torch              # Deep learning
transformers       # NLP models
openai             # GPT API
```

### Testing & Quality (9 packages)
```
pytest             # Testing framework
pytest-cov         # Coverage plugin
black              # Code formatter
flake8             # Linter
pylint             # Code analysis
mypy               # Type checking
isort              # Import sorting
pre-commit         # Git hooks
bandit             # Security linter
```

### Complete List
See [requirements-python.txt](requirements-python.txt) for full list with versions.

---

## Stata Packages

### Summary
- **Total Packages**: ~60
- **Installation Time**: 10-20 minutes
- **Storage Required**: ~100 MB

### Core Data Management (11 packages)
```
gtools             # Fast Stata commands
ftools             # Fast operations
unique             # Unique observations
distinct           # Distinct values
missings           # Missing value management
labutil            # Label utilities
sencode            # Smart encode
carryforward       # Fill forward
mmerge             # Multiple merge
rangestat          # Rolling statistics
egenmore           # Additional egen
```

### Statistical Analysis (10 packages)
```
reghdfe            # HDFE regression
ivreg2             # IV/2SLS
ranktest           # Rank tests
xtoverid           # Overidentification
ivreghdfe          # IV with HDFE
boottest           # Wild bootstrap
did_multiplegt     # DiD estimator
weakiv             # Weak IV tests
moremata           # Mata extensions
winsor/winsor2     # Winsorization
```

### Tables & Output (6 packages)
```
estout             # Regression tables
outreg2            # Table export
tabout             # Publication tables
coefplot           # Coefficient plots
grc1leg            # Graph combine
```

### Visualization (5 packages)
```
blindschemes       # Color-blind schemes
palettes           # Color palettes
colrspace          # Color utilities
schemepack         # Graph schemes
plottig            # Better axis ticks
```

### Inequality & Poverty (5 packages)
```
inequal7           # Inequality measures
glcurve            # Lorenz curves
ineqdeco           # Decomposition
poverty            # Poverty measures
drdecomp           # Oaxaca-Blinder
```

### Spatial Analysis (5 packages)
```
spmap              # Spatial visualization
shp2dta            # Shapefile conversion
mif2dta            # MapInfo conversion
spwmatrix          # Spatial weights
spatreg            # Spatial regression
```

### Complete List
See [requirements-stata.do](requirements-stata.do) for full list.

---

## Repository Compatibility

This setup enables reproduction of analysis from the following UNICEF repositories:

### Education & Learning Analytics

| Repository | Description | Key Packages |
|------------|-------------|--------------|
| **EduAnalytics-Unicef** | Education data harmonization | R: tidyverse, haven, countrycode |
| **LearningPoverty-Production** | Learning poverty metrics | R: data.table, ggplot2, rmarkdown |
| **GLAD-Analytics** | Global Learning Assessment DB | R: haven, dplyr, knitr |
| **benchmark-edu** | Educational benchmarking | R: COINr, ggplot2, data.table |

### Child Wellbeing & Development

| Repository | Description | Key Packages |
|------------|-------------|--------------|
| **ChildWellbeing** | Child life-course index | R: COINr, tidyverse, plotly |
| **MICS-analytics** | MICS survey analysis | R: survey, srvyr, haven |
| **health-equity** | Health equity indicators | R: data.table, ggplot2 |
| **child-life-course-index** | Multi-dimensional indices | R: COINr, corrplot |

### Data Warehouse & Production

| Repository | Description | Key Packages |
|------------|-------------|--------------|
| **DW-Production** | UNICEF data warehouse pipeline | R: tidyverse, haven, yaml, Stata |
| **PROD-SDG-REP-2025** | SDG reporting production | R: rmarkdown, data.table, ggplot2 |
| **SDGnetAnalysis** | SDG network analysis | R: igraph, ggplot2, scales |

### Specialized Analytics

| Repository | Description | Key Packages |
|------------|-------------|--------------|
| **ccri** | Climate child risk indices | Python: geopandas, rasterio, pandas |
| **fiscal_capacity_package** | Fiscal capacity analysis | R: data.table, ggplot2 |
| **wb-api-repo** | World Bank API tools | Python: requests, pandas, pyyaml |
| **oda_baselines_repo** | ODA baseline extraction | Python: pandas, requests, pytest |
| **benchmark-lit-review** | Literature review tools | Python: pandas, matplotlib |

### API & Data Tools

| Repository | Description | Key Packages |
|------------|-------------|--------------|
| **unicefopendata** | UNICEF open data access | R: httr, jsonlite |
| **wb-api-repo** | World Bank data retrieval | Python: requests, pandas |
| **sowc_downloader** | SOWC data downloader | Python: requests, pandas |

### Geospatial & Climate

| Repository | Description | Key Packages |
|------------|-------------|--------------|
| **mics-geocoding** | MICS geographic coding | R: sf, sp, raster |
| **climate-sensitive** | Climate sensitivity analysis | Python: geopandas, rasterio |
| **maps** | Mapping utilities | R: sf, ggplot2, leaflet |

---

## Installation Size Summary

| Component | Disk Space | RAM Required |
|-----------|------------|--------------|
| **R + Packages** | ~500 MB | 2+ GB |
| **Python + Packages** | ~2-3 GB | 4+ GB |
| **Stata + Packages** | ~100 MB | 2+ GB |
| **Development Tools** | ~500 MB | - |
| **Total** | **~3-4 GB** | **4-8 GB** |

---

## Update Schedule

### Recommended Update Frequency

| Component | Update Frequency | Command |
|-----------|-----------------|---------|
| **R Packages** | Monthly | `update.packages()` or `make update-r` |
| **Python Packages** | Monthly | `pip list --outdated` or `make update-python` |
| **Stata Packages** | Quarterly | `adoupdate, update` |
| **System Software** | As available | Platform-specific |

---

## Support & Resources

### Documentation
- **Installation Guide**: [INSTALL.md](INSTALL.md)
- **System Requirements**: [REQUIREMENTS.md](REQUIREMENTS.md)
- **Troubleshooting**: [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- **Makefile Reference**: [MAKEFILE-GUIDE.md](MAKEFILE-GUIDE.md)

### Package Documentation
- **R Packages**: [CRAN](https://cran.r-project.org/)
- **Python Packages**: [PyPI](https://pypi.org/)
- **Stata Packages**: [SSC](https://ideas.repec.org/s/boc/bocode.html)

### Getting Help
1. Check package documentation
2. Review repository README files
3. Search package-specific forums
4. Contact UNICEF Data & Analytics Section

---

**Last Updated**: October 2025  
**Maintained by**: UNICEF Data & Analytics Section
