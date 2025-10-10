* ==============================================================================
* Stata Package Requirements - UNICEF Analytics Environment
* ==============================================================================
* Installation: do requirements-stata.do
* ==============================================================================

* Stata version requirement
version 15

* Display header
display as text ""
display as result "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
display as result "  UNICEF Analytics - Stata Package Installation"
display as result "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
display as text ""

* ============================================================================
* CORE DATA MANAGEMENT
* ============================================================================

* Data cleaning and manipulation
local packages ///
    gtools ///          /* Fast Stata commands */ ///
    ftools ///          /* Fast reshaping and variable generation */ ///
    unique ///          /* Check for unique observations */ ///
    distinct ///        /* Count distinct values */ ///
    missings ///        /* Manage missing values */ ///
    labutil ///         /* Label utilities */ ///
    sencode ///         /* Smart encode */ ///
    carryforward ///    /* Carry forward values */ ///
    mmerge ///          /* Multiple merge */ ///
    rangestat ///       /* Summary statistics over rolling windows */ ///
    egenmore            /* Additional egen functions */

* Install core data management packages
foreach pkg of local packages {
    capture which `pkg'
    if _rc != 0 {
        display as text "Installing: `pkg'"
        ssc install `pkg', replace
    }
    else {
        display as result "✓ `pkg' already installed"
    }
}

* ============================================================================
* STATISTICAL ANALYSIS
* ============================================================================

local stat_packages ///
    reghdfe ///         /* High-dimensional fixed effects regression */ ///
    ivreg2 ///          /* IV/2SLS regression */ ///
    ranktest ///        /* Rank test (required by ivreg2) */ ///
    xtoverid ///        /* Tests of overidentifying restrictions */ ///
    ivreghdfe ///       /* IV regression with HDFE */ ///
    boottest ///        /* Wild bootstrap */ ///
    did_multiplegt ///  /* Difference-in-differences */ ///
    weakiv ///          /* Weak instrument tests */ ///
    moremata ///        /* Mata library extensions */ ///
    winsor ///          /* Winsorize variables */ ///
    winsor2             /* Enhanced winsorization */

foreach pkg of local stat_packages {
    capture which `pkg'
    if _rc != 0 {
        display as text "Installing: `pkg'"
        ssc install `pkg', replace
    }
    else {
        display as result "✓ `pkg' already installed"
    }
}

* ============================================================================
* SURVEY ANALYSIS
* ============================================================================

local survey_packages ///
    svyset ///          /* Survey settings - built-in */ ///
    surveybias ///      /* Survey bias assessment */ ///
    svylorenz           /* Lorenz curves with survey data */

foreach pkg of local survey_packages {
    capture which `pkg'
    if _rc != 0 {
        display as text "Installing: `pkg'"
        cap ssc install `pkg', replace
        if _rc != 0 {
            display as error "  Could not install `pkg' - may be built-in or unavailable"
        }
    }
    else {
        display as result "✓ `pkg' already installed"
    }
}

* ============================================================================
* VISUALIZATION & TABLES
* ============================================================================

local viz_packages ///
    estout ///          /* Regression tables */ ///
    outreg2 ///         /* Alternative regression output */ ///
    tabout ///          /* Publication-quality tables */ ///
    coefplot ///        /* Coefficient plots */ ///
    grc1leg ///         /* Combine graphs with single legend */ ///
    blindschemes ///    /* Color-blind friendly graph schemes */ ///
    palettes ///        /* Color palettes */ ///
    colrspace ///       /* Color space utilities */ ///
    schemepack ///      /* Additional graph schemes */ ///
    plottig             /* Better axis ticks */

foreach pkg of local viz_packages {
    capture which `pkg'
    if _rc != 0 {
        display as text "Installing: `pkg'"
        ssc install `pkg', replace
    }
    else {
        display as result "✓ `pkg' already installed"
    }
}

* ============================================================================
* DATA IMPORT/EXPORT
* ============================================================================

local io_packages ///
    readstat ///        /* Read/write SAS, SPSS, Stata files */ ///
    import_excel ///    /* Enhanced Excel import - built-in */ ///
    export_excel ///    /* Enhanced Excel export - built-in */ ///
    usespss ///         /* Import SPSS files */ ///
    savespss            /* Export to SPSS */

foreach pkg of local io_packages {
    capture which `pkg'
    if _rc != 0 {
        display as text "Installing: `pkg'"
        cap ssc install `pkg', replace
        if _rc != 0 {
            display as error "  Could not install `pkg' - may be built-in or unavailable"
        }
    }
    else {
        display as result "✓ `pkg' already installed"
    }
}

* ============================================================================
* INEQUALITY & POVERTY MEASUREMENT
* ============================================================================

local poverty_packages ///
    inequal7 ///        /* Inequality measures */ ///
    glcurve ///         /* Generalized Lorenz curves */ ///
    ineqdeco ///        /* Inequality decomposition */ ///
    poverty ///         /* Poverty measures */ ///
    drdecomp            /* Oaxaca-Blinder decomposition */

foreach pkg of local poverty_packages {
    capture which `pkg'
    if _rc != 0 {
        display as text "Installing: `pkg'"
        cap ssc install `pkg', replace
        if _rc != 0 {
            display as error "  Could not install `pkg' - package may be unavailable"
        }
    }
    else {
        display as result "✓ `pkg' already installed"
    }
}

* ============================================================================
* SPATIAL ANALYSIS
* ============================================================================

local spatial_packages ///
    spmap ///           /* Spatial visualization */ ///
    shp2dta ///         /* Shapefile conversion */ ///
    mif2dta ///         /* MapInfo conversion */ ///
    spwmatrix ///       /* Spatial weights matrices */ ///
    spatreg             /* Spatial regression */

foreach pkg of local spatial_packages {
    capture which `pkg'
    if _rc != 0 {
        display as text "Installing: `pkg'"
        cap ssc install `pkg', replace
        if _rc != 0 {
            display as error "  Could not install `pkg' - package may be unavailable"
        }
    }
    else {
        display as result "✓ `pkg' already installed"
    }
}

* ============================================================================
* TIME SERIES
* ============================================================================

local ts_packages ///
    xtabond2 ///        /* Dynamic panel data */ ///
    xtserial ///        /* Serial correlation test */ ///
    xtcdf               /* Cross-sectional dependence */

foreach pkg of local ts_packages {
    capture which `pkg'
    if _rc != 0 {
        display as text "Installing: `pkg'"
        cap ssc install `pkg', replace
        if _rc != 0 {
            display as error "  Could not install `pkg' - package may be unavailable"
        }
    }
    else {
        display as result "✓ `pkg' already installed"
    }
}

* ============================================================================
* UTILITIES & PROGRAMMING
* ============================================================================

local util_packages ///
    dataex ///          /* Post data examples */ ///
    reclink ///         /* Record linkage */ ///
    matchit ///         /* Matching algorithms */ ///
    moss ///            /* String matching */ ///
    strgroup ///        /* Fuzzy string matching */ ///
    fuzzydid ///        /* Fuzzy difference-in-differences */ ///
    parallel ///        /* Parallel processing */ ///
    grstyle             /* Graph style customization */

foreach pkg of local util_packages {
    capture which `pkg'
    if _rc != 0 {
        display as text "Installing: `pkg'"
        cap ssc install `pkg', replace
        if _rc != 0 {
            display as error "  Could not install `pkg' - package may be unavailable"
        }
    }
    else {
        display as result "✓ `pkg' already installed"
    }
}

* ============================================================================
* WORLD BANK & INTERNATIONAL DATA
* ============================================================================

* World Bank data access
capture which wbopendata
if _rc != 0 {
    display as text "Installing: wbopendata"
    ssc install wbopendata, replace
}
else {
    display as result "✓ wbopendata already installed"
}

* ============================================================================
* GITHUB PACKAGES (Optional)
* ============================================================================

* Example for future GitHub packages:
* net install package_name, from("https://raw.githubusercontent.com/user/repo/main/") replace

* ============================================================================
* COMPLETION
* ============================================================================

display as text ""
display as result "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
display as result "  ✓ Stata package installation complete!"
display as result "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
display as text ""
display as text "Note: Some packages may have failed to install if they are:"
display as text "  - Built-in Stata commands"
display as text "  - No longer available on SSC"
display as text "  - Require manual installation from other sources"
display as text ""
display as text "To verify installation, type: which <package_name>"
display as text ""

* ==============================================================================
* END OF STATA REQUIREMENTS
* ==============================================================================
