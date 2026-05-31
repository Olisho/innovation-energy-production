*============================================================*
* PROJECT: R&D Intensity and Primary Energy Production
* FILE:    06_regression_analysis.do
* PURPOSE: Run panel regressions and diagnostics
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
* SECTION 1: Load Panel Data
*------------------------------------------------------------*

use "$ROOT/data/cleaned/panel_final.dta", clear
xtset region_code year

*------------------------------------------------------------*
* SECTION 2: Visualize Data
*------------------------------------------------------------*

xtline number_of_researchers, overlay title("R&D Researchers Over Time")
graph export "$ROOT/output/graphs/rd_researchers_over_time.png", replace width(1200)

xtline Primary_Energy_production, overlay title("Energy Production Over Time")
graph export "$ROOT/output/graphs/energy_production_over_time.png", replace width(1200)

twoway (scatter Primary_Energy_production number_of_researchers) ///
       (lfit Primary_Energy_production number_of_researchers), ///
       title("Energy Production vs R&D Intensity") ///
       xtitle("Researchers per Million") ///
       ytitle("Primary Energy Production (petajoules)")

graph export "$ROOT/output/graphs/scatter_energy_vs_rd.png", replace width(1200)

*------------------------------------------------------------*
* SECTION 3: Pooled OLS (Baseline)
*------------------------------------------------------------*

reg Primary_Energy_production number_of_researchers
estimates store ols

*------------------------------------------------------------*
* SECTION 4: Fixed Effects Model
*------------------------------------------------------------*

xtreg Primary_Energy_production number_of_researchers, fe
estimates store fe

xtreg Primary_Energy_production number_of_researchers i.year, fe
estimates store fe_time

*------------------------------------------------------------*
* SECTION 5: Random Effects Model
*------------------------------------------------------------*

xtreg Primary_Energy_production number_of_researchers, re
estimates store re

*------------------------------------------------------------*
* SECTION 6: Model Selection
*------------------------------------------------------------*

hausman fe re

*------------------------------------------------------------*
* SECTION 7: Robustness Checks (Log Specification)
*------------------------------------------------------------*

* Avoid log(0) issues
gen ln_energy = ln(Primary_Energy_production + 1)
gen ln_rd = ln(number_of_researchers + 1)

xtreg ln_energy ln_rd, fe
estimates store fe_log

*------------------------------------------------------------*
* SECTION 8: Export Results
*------------------------------------------------------------*

* Export table to output/tables/
esttab ols fe fe_time re fe_log using "$ROOT/output/tables/regression_results.rtf", ///
    se r2 ar2 star(* 0.1 ** 0.05 *** 0.01) ///
    title("Panel Regression Results: Energy Production on R&D Intensity") ///
    mtitles("OLS" "FE" "FE+Time" "RE" "FE-Log") ///
    replace

* Also export as LaTeX for academic papers
esttab ols fe fe_time re fe_log using "$ROOT/output/tables/regression_results.tex", ///
    se r2 ar2 star(* 0.1 ** 0.05 *** 0.01) ///
    title("Panel Regression Results: Energy Production on R&D Intensity") ///
    mtitles("OLS" "FE" "FE+Time" "RE" "FE-Log") ///
    replace booktabs

* Also export as CSV for easy sharing
esttab ols fe fe_time re fe_log using "$ROOT/output/tables/regression_results.csv", ///
    se r2 ar2 star(* 0.1 ** 0.05 *** 0.01) ///
    mtitles("OLS" "FE" "FE+Time" "RE" "FE-Log") ///
    replace plain