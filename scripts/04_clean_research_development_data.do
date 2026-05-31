*============================================================*
* PROJECT: R&D Intensity and Primary Energy Production
* FILE:    04_clean_research_development_data.do
* PURPOSE: Clean R&D dataset
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
* SECTION 1: Load Imported Data
*------------------------------------------------------------*

use "$ROOT/data/cleaned/rd_imported.dta", clear

describe
summarize

*------------------------------------------------------------*
* SECTION 2: Rename Variables
*------------------------------------------------------------*

rename v2 region
rename regioncountryarea region_code

*------------------------------------------------------------*
* SECTION 3: Keep Only Researchers Indicator
*------------------------------------------------------------*

keep if series == "Researchers per million inhabitants (FTE)"
tabulate series

*------------------------------------------------------------*
* SECTION 4: Filter to Sub-Regions (Drop Individual Countries)
*------------------------------------------------------------*

keep if ///
    inlist(region, ///
        "Australia and New Zealand", ///
        "Central Asia", ///
        "Eastern Asia", ///
        "Europe", ///
        "Latin America & the Caribbean", ///
        "Northern Africa", ///
        "Northern America", ///
        "Oceania", ///
        "South-central Asia") ///
    | inlist(region, ///
        "South-eastern Asia", ///
        "Southern Asia", ///
        "Sub-Saharan Africa", ///
        "Western Asia")

tabulate region

*------------------------------------------------------------*
* SECTION 5: Clean Value Variable
*------------------------------------------------------------*

replace value = subinstr(value, ",", "", .)
destring value, replace

*------------------------------------------------------------*
* SECTION 6: Harmonize Regions to Match Energy Data
*------------------------------------------------------------*

replace region = "Africa" if ///
    region == "Northern Africa" | ///
    region == "Sub-Saharan Africa"

replace region = "Asia" if ///
    region == "Central Asia" | ///
    region == "Eastern Asia" | ///
    region == "South-central Asia" | ///
    region == "South-eastern Asia" | ///
    region == "Southern Asia" | ///
    region == "Western Asia"

replace region = "Oceania" if ///
    region == "Australia and New Zealand"

tabulate region

*------------------------------------------------------------*
* SECTION 7: Collapse Sub-Regions to Continents
*------------------------------------------------------------*

collapse (sum) value, by(region year series)

*------------------------------------------------------------*
* SECTION 8: Recreate Region Codes
*------------------------------------------------------------*

gen region_code = .
replace region_code = 2   if region == "Africa"
replace region_code = 142 if region == "Asia"
replace region_code = 150 if region == "Europe"
replace region_code = 21  if region == "Northern America"
replace region_code = 419 if region == "Latin America & the Caribbean"
replace region_code = 9   if region == "Oceania"

*------------------------------------------------------------*
* SECTION 9: Finalize and Save
*------------------------------------------------------------*

rename value number_of_researchers
label variable number_of_researchers "Researchers per Million Inhabitants (FTE)"

drop series

order region_code region year number_of_researchers
sort region_code year

misstable summarize

label data "R&D Researchers per Million - Continental Panel (2005-2022)"

save "$ROOT/data/cleaned/rd_cleaned.dta", replace

describe
list in 1/10