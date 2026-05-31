*============================================================*
* PROJECT: The relationship between research and development (R&D)
*          intensity and primary energy production across continents
* FILE:    00_master.do
* PURPOSE: Full pipeline orchestrator (runs all scripts)
* AUTHOR:  Norbert Otieno
* DATE:    30 May 2026
*============================================================*

*------------------------------------------------------------*
* SECTION 0: Setup
*------------------------------------------------------------*

clear all
set more off

* Project root (portable for GitHub / recruiters)
global ROOT "`c(pwd)'"

* Ensure folder structure exists (safe for fresh clones)
capture mkdir "$ROOT/data/raw"
capture mkdir "$ROOT/data/cleaned"
capture mkdir "$ROOT/output"
capture mkdir "$ROOT/output/graphs"
capture mkdir "$ROOT/output/tables"
capture mkdir "$ROOT/logs"

* Verify we're in the right place
capture confirm file "$ROOT/scripts/00_master.do"
if _rc != 0 {
    display as error "ERROR: Run this do-file from the project root folder."
    display as error "Current directory: $ROOT"
    exit 198
}

* Start log
log using "$ROOT/logs/master_log.txt", text replace

*------------------------------------------------------------*
* SECTION 1: IMPORT RAW DATA
*------------------------------------------------------------*
di _n "=== Section 1: Import ==="

do "$ROOT/scripts/01_import_Research_development_data.do"
do "$ROOT/scripts/02_import_primary_energy_production_data.do"

*------------------------------------------------------------*
* SECTION 2: CLEAN DATA
*------------------------------------------------------------*
di _n "=== Section 2: Clean ==="

do "$ROOT/scripts/03_clean_energy_data.do"
do "$ROOT/scripts/04_clean_research_development_data.do"

*------------------------------------------------------------*
* SECTION 3: MERGE PANEL DATA
*------------------------------------------------------------*
di _n "=== Section 3: Merge ==="

do "$ROOT/scripts/05_merge_panel.do"

*------------------------------------------------------------*
* SECTION 4: ANALYSIS
*------------------------------------------------------------*
di _n "=== Section 4: Analysis ==="

do "$ROOT/scripts/06_regression_analysis.do"

*------------------------------------------------------------*
* END OF PIPELINE
*------------------------------------------------------------*
log close

di as result _n "Pipeline completed successfully."