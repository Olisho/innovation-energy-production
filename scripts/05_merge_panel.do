*============================================================*
* PROJECT: R&D Intensity and Primary Energy Production
* FILE:    05_merge_panel.do
* PURPOSE: Merge R&D and Energy datasets, declare panel structure,
*          and save final panel dataset
* AUTHOR:  Norbert Otieno
* DATE:    30 May 2026
*============================================================*

*------------------------------------------------------------*
* NOTE: Designed to run from 00_master.do
*       If standalone, run: do "00_master.do" first
*------------------------------------------------------------*

clear           // Preserves globals from 00_master.do
set more off

*------------------------------------------------------------*
* SECTION 1: Load R&D Dataset
*------------------------------------------------------------*

use "$ROOT/data/cleaned/rd_cleaned.dta", clear

*------------------------------------------------------------*
* SECTION 2: Merge with Energy Dataset
*------------------------------------------------------------*

merge 1:1 region_code year using "$ROOT/data/cleaned/energy_cleaned.dta"

* Check merge results
tab _merge

*------------------------------------------------------------*
* SECTION 3: Inspect Merged Data
*------------------------------------------------------------*

browse

*------------------------------------------------------------*
* SECTION 4: Clean Merged Dataset
*------------------------------------------------------------*

drop _merge

*------------------------------------------------------------*
* SECTION 5: Declare Panel Structure
*------------------------------------------------------------*

xtset region_code year

xtdescribe

*------------------------------------------------------------*
* SECTION 6: Save Final Panel Dataset
*------------------------------------------------------------*

save "$ROOT/data/cleaned/panel_final.dta", replace

describe
list in 1/10, sepby(region)