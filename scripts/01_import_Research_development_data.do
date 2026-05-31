*============================================================*
* PROJECT: R&D Intensity and Primary Energy Production
* FILE: 01_import_Research_development_data.do
* PURPOSE: Import R&D dataset from CSV
* AUTHOR:  Norbert Otieno
* DATE:    28 May 2026
*============================================================*

*------------------------------------------------------------*
* NOTE: This file is designed to run from 00_master.do
*       If running standalone, first run: do "00_master.do"
*------------------------------------------------------------*

clear           // Preserves globals set by 00_master.do
set more off

*------------------------------------------------------------*
* SECTION 1: Import R&D Data
*------------------------------------------------------------*

import delimited ///
    "$ROOT/data/raw/SYB68_285_202511_Research and Development Expenditure and Staff.csv", ///
    varnames(2) clear

*------------------------------------------------------------*
* SECTION 2: Inspect Structure
*------------------------------------------------------------*

describe
summarize
list in 1/10
tab v2
tab regioncountryarea

*------------------------------------------------------------*
* SECTION 3: Save Imported Dataset
*------------------------------------------------------------*

* Save to cleaned/ (preserve raw/ as untouched original)
save "$ROOT/data/cleaned/rd_imported.dta", replace