*============================================================*
* PROJECT: R&D Intensity and Primary Energy Production
* FILE:    02_import_primary_energy_production_data.do
* PURPOSE: Import Energy dataset from CSV
* AUTHOR:  Norbert Otieno
* DATE:    28 May 2026
*============================================================*

*------------------------------------------------------------*
* NOTE: Designed to run from 00_master.do
*       If standalone, run: do "00_master.do" first
*------------------------------------------------------------*

clear           // Preserves globals from 00_master.do
set more off

*------------------------------------------------------------*
* SECTION 1: Import Energy Data
*------------------------------------------------------------*

import delimited ///
    "$ROOT/data/raw/SYB68_263_202511_Production, Trade and Supply of Energy.csv", ///
    varnames(2) clear

*------------------------------------------------------------*
* SECTION 2: Inspect Structure
*------------------------------------------------------------*

describe
summarize
list in 1/10
tab v2
tab value
tab regioncountryarea

*------------------------------------------------------------*
* SECTION 3: Save Imported Dataset
*------------------------------------------------------------*

* Save to cleaned/ (keep raw/ untouched)
save "$ROOT/data/cleaned/energy_imported.dta", replace