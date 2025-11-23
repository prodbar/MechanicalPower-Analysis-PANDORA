# Mechanical Power Analysis – PANDORA Dataset

This repository contains the MATLAB code developed for the analysis of **effective mechanical power (PME)** in mechanically ventilated pediatric patients included in the multicentre **PANDORA** database.  
The project evaluates mechanical power at multiple time points, builds cumulative and normalized metrics, derives dynamic indicators, and studies their association with clinically relevant outcomes.

All data used in the analysis remain private and are not included in this repository. The code is provided to enable methodological transparency and reproducibility.

---

## Overview

The analysis focuses on:

### 1. Computation of Effective Mechanical Power (PME)

Using the pediatric formula:

**PME = 0.098 · FR · (VT / IBW) · [ PIP − 0.5 · (Pplat + PEEP) ]**

PME is computed for six time points: **T0, T6, D0, D1, D3, and D7**.

### 2. Mechanical Power Metrics

- Instantaneous effective mechanical power (`MP_eff_norm_*`)
- Cumulative mechanical power (`AREA_ACUMULADA`)
- Dynamic indicators derived from the cumulative curve:
  - `Area_Total`
  - `MP_Mean`
  - `Max_Slope`
  - `T50` (time to reach 50% of total cumulative energy)
  - `Ratio24h` (fraction of energy delivered within the first 24 hours)
  - `Var_Increments` (variance of successive increments)

These indicators quantify both the magnitude and the temporal pattern of mechanical energy delivery.

### 3. Statistical Analysis

The repository includes scripts to perform:

- Descriptive statistics of mechanical power variables
- Distribution analysis of `AREA_ACUMULADA` and `log(AREA_ACUMULADA)`
- Association with clinical outcomes:
  - Ventilator-Free Days (VFD) (`DIAS_LIBRES_VM_MODIF`)
  - Mortality (`MORTALIDAD`)
- Correlation analyses (Spearman, Pearson)
- Group comparisons (independent two-sample t-test, Mann–Whitney U)

### 4. Visualisation

The plotting scripts generate:

- Individual patient mechanical power curves
- Individual cumulative mechanical power curves
- Scatterplots with linear and logarithmic regression fits
- Boxplots comparing survivors vs non-survivors
- Histograms with theoretical normal distribution overlays

---

## Repository Structure

```text
src/matlab/
  preprocessing/
    compute_MP_columns.m              % Computes MP_eff_norm_* columns from raw ventilatory data
    compute_anomalies.m               % Range checks and abnormal values for ventilatory variables

  statistics/
    stats_MP_variables.m              % Descriptive statistics for mechanical power variables
    stats_MP_vs_VFD.m                 % Mechanical power vs VFD (regressions and correlations)
    stats_MP_vs_mortality.m           % Mechanical power vs mortality (group comparison)
    stats_distribution_cumulativeMP.m % Distribution and normality of AREA_ACUMULADA
    stats_distribution_logPMA.m       % Distribution and normality of log(AREA_ACUMULADA)
    stats_dynamic_indicators.m        % Dynamic indicators derived from cumulative mechanical power
    stats_logPMA_vs_VFD.m             % log(AREA_ACUMULADA) vs VFD (Spearman correlation)
    stats_logPMA_vs_mortality.m       % log(AREA_ACUMULADA) vs mortality (t-test)

  plots/
    plot_patient_MP_curves.m          % Individual mechanical power curves per patient
    plot_cumulative_MP_curves.m       % Individual cumulative mechanical power curves
    plot_cumulativeMP_vs_VFD.m        % Cumulative mechanical power vs VFD (scatter + fits)
    plot_cumulativeMP_vs_mortality.m  % Cumulative mechanical power vs mortality (boxplots)
```

---

## Workflow summary
### 1. Preprocessing

- compute_MP_columns
- compute_anomalies

### 2. Distribution & Descriptive Analysis
- stats_MP_variables
- stats_distribution_cumulativeMP
- stats_distribution_logPMA

### 3. Dynamic Indicators
- stats_dynamic_indicators

### 4. Clinical Associations
- stats_MP_vs_VFD
- stats_MP_vs_mortality
- stats_logPMA_vs_VFD
- stats_logPMA_vs_mortality

### 5. Visualisation
- plot_patient_MP_curves
- plot_cumulative_MP_curves
- plot_cumulativeMP_vs_VFD
- plot_cumulativeMP_vs_mortality

---

## Contact

For any questions, feedback, or collaboration requests regarding this repository or the associated research work, please contact:

**Patricia Rodrigo Barrio**  
Email: **patriciarodrigobarrio@gmail.com**  

---
