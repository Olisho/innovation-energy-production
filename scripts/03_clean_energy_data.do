*============================================================*
* PROJECT: R&D Intensity and Primary Energy Production
* FILE:    03_clean_energy_data.do
* PURPOSE: Clean energy dataset
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
* SECTION 1: Load Raw Data
*------------------------------------------------------------*

* Load from cleaned/ where 02 saved it
use "$ROOT/data/cleaned/energy_imported.dta", clear

describe
summarize

*------------------------------------------------------------*
* SECTION 2: Rename Variables
*------------------------------------------------------------*

rename v2 region
rename regioncountryarea region_code

*------------------------------------------------------------*
* SECTION 3: Filter to Continental Regions Only
*------------------------------------------------------------*

keep if ///
    inlist(region, "Africa", "Asia", "Europe", "Oceania") ///
    | inlist(region, "Northern America", "Latin America & the Caribbean")

tabulate region

*------------------------------------------------------------*
* SECTION 4: Filter to Relevant Years
*------------------------------------------------------------*

keep if inlist(year, 2005, 2010, 2015, 2022)
tab year

*------------------------------------------------------------*
* SECTION 5: Clean and Convert Value Variable
*------------------------------------------------------------*

replace value = subinstr(value, ",", "", .)
destring value, replace

describe value

*------------------------------------------------------------*
* SECTION 6: Keep Only Primary Energy Production
*------------------------------------------------------------*

keep if series == "Primary energy production (petajoules)"
tab series

*------------------------------------------------------------*
* SECTION 7: Check Missing Values
*------------------------------------------------------------*

misstable summarize

*------------------------------------------------------------*
* SECTION 8: Drop Unnecessary Variables
*------------------------------------------------------------*

drop footnotes source series

*------------------------------------------------------------*
* SECTION 9: Rename Value and Finalize
*------------------------------------------------------------*

rename value Primary_Energy_production
label variable Primary_Energy_production "Primary Energy Production (petajoules)"

order region_code region year Primary_Energy_production
sort region_code year

*------------------------------------------------------------*
* SECTION 10: Save Cleaned Dataset
*------------------------------------------------------------*

save "$ROOT/data/cleaned/energy_cleaned.dta", replace

describe
list in 1/10