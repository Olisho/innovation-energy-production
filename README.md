# Innovation and Energy Production: R&D Intensity and Primary Energy Production Across Continents

![Stata](https://img.shields.io/badge/Stata-16%2B-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

**License:** MIT  
**Author:** Norbert Otieno  
**Email:** omondinorbert@gmail.com  
**Degree:** MSc Energy Policy, University of Sussex  
**Date:** May 2026

---

## Overview

This repository contains Stata do-files and data for analyzing the relationship between R&D intensity (researchers per million inhabitants) and primary energy production across six continental regions from 2005 to 2022.

**Key Finding:** A 1-unit increase in researchers per million is associated with a 25.49 petajoule increase in primary energy production within continents over time (Fixed Effects model, p &lt; 0.001).

---

## Data Sources

| Dataset | Source | Years | Observations |
|---------|--------|-------|--------------|
| Energy Production | UN Statistical Yearbook (SYB68_263) | 1995–2022 | 8,700 |
| R&D Expenditure & Staff | UN Statistical Yearbook (SYB68_285) | 2005–2022 | 1,039 |
| **Final Panel** | — | 2005, 2010, 2015, 2022 | **24** (6 regions × 4 years) |

---

## How to Run

1. **Clone this repository** to your local machine.
2. **Open Stata** and set the working directory to the project root folder.
3. **Run the master file:**

   ```stata
   do scripts/00_master.do
