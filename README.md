# GM1.0
Green methanol multi-scale modelling workspace built on steady-state Aspen Plus flowsheets orchestrated in MATLAB. Includes TEA and LCA modules plus improved Gaussian-process symbolic-regression surrogates for CO2 and water electrolysers to enable fast system screening and optimisation.

# Supplementary Code and Data Repository

This repository provides supplementary code, models, and datasets supporting the manuscript:

**Comparative Assessment of Advanced Carbon-Neutral Methanol Production Pathways through Multi-scale Techno-Economic-Environmental Modelling**

It is intended to improve transparency, reproducibility, and reusability of the modelling workflow used to compare advanced carbon-neutral methanol production routes under consistent techno-economic and environmental assumptions.

---

## 1. Scope and Content

The repository implements a **steady-state, multi-scale modelling workflow** for green (carbon-neutral) methanol production, integrating:

- **Process-level steady-state simulation** in **Aspen Plus** to resolve mass and energy balances, equipment duties, and stream properties across each pathway.
- **MATLAB orchestration** for case management, parameter sweeps, data handling, and post-processing.
- **Techno-Economic Analysis (TEA)** to quantify cost drivers and report comparable economic metrics across pathways.
- **Life-Cycle Assessment (LCA)** to quantify greenhouse gas emissions and other impact indicators under consistent functional units and system boundaries.
- **Surrogate modelling** using **Gaussian-process-based symbolic regression** to provide data-efficient, physically credible reduced-order models for:
  - **CO2 electrolyser** performance (e.g., Faradaic efficiency, cell voltage, specific electricity use, product rates).
  - **Water electrolyser** performance (e.g., power consumption, hydrogen production, efficiency metrics).

These surrogates reduce the computational burden of repeated simulation and enable rapid sensitivity analysis and scenario screening.

---

## 2. Repository Structure

> Folder names may be adapted to your local setup; the intent of each directory is described below.

- `aspen/`
  - Aspen Plus backup files and/or exported configuration files used to build the steady-state flowsheets.
  - Notes on property methods, unit operation configuration, and convergence settings relevant to reproducibility.

- `matlab/`
  - MATLAB scripts for:
    - Running parametric studies and exporting results.
    - Parsing Aspen outputs and assembling performance datasets.
    - Computing system-level KPIs for TEA and LCA reporting.
    - Generating plots and tables used in the manuscript and supporting information.

- `surrogates/`
  - Training datasets, model definitions, and evaluation scripts for surrogate models.
  - Gaussian-process symbolic regression workflows for CO2 and water electrolysers.

- `tea/`
  - Cost models, assumptions, and calculation scripts.
  - CAPEX/OPEX breakdown templates and economic parameter files.

- `lca/`
  - Inventory assumptions, emission factor datasets, and LCA calculation scripts.
  - Electricity carbon intensity scenarios and impact calculation routines.

- `data/`
  - Input datasets (operating conditions, electricity prices, carbon intensity, scenario parameters).
  - Exported model outputs (as CSV) used for analysis, figures, and surrogate training.

- `figures/`
  - Figure generation scripts and exported images (optional; may be generated locally).

- `docs/`
  - Additional documentation, parameter definitions, and workflow notes.

---

## 3. Modelling Overview

### 3.1 Process Simulation (Aspen Plus)
Aspen Plus flowsheets implement steady-state representations of each pathway. Key outputs include:
- Stream compositions, flowrates, temperatures, and pressures.
- Unit operation duties and power requirements (e.g., compressors, pumps, heaters/coolers).
- Conversion, selectivity, purge losses, recycle ratios, and separation performance.
- Utility consumption to support TEA and LCA calculations.

### 3.2 Unit-Level Surrogate Models
Electrolyser units are represented using GP-based symbolic regression surrogates to capture non-linear performance with limited training data while preserving physical credibility. Typical inputs and outputs include:
- Inputs: current density, temperature, pressure, feed composition, single-pass conversion targets, and operational constraints (as applicable).
- Outputs: Faradaic efficiency, cell voltage, specific electricity consumption, production rates, and auxiliary power (if modelled).

### 3.3 Techno-Economic and Environmental Assessment
The workflow reports pathway-comparable indicators, such as:
- Levelised methanol cost and cost breakdown contributions.
- Electricity and utility requirements per functional unit.
- Life-cycle greenhouse gas emissions (e.g., kg CO2-eq per kg MeOH) under consistent boundaries and electricity carbon intensity assumptions.

---

## 4. Requirements

### 4.1 Software
- Aspen Plus (version used in the study should be documented in `aspen/README.md` if available).
- MATLAB (R2020a or later recommended; earlier versions may work depending on toolboxes).
- Optional: Python (only if included scripts require it; otherwise MATLAB-only).

### 4.2 Typical MATLAB Toolboxes (if used)
- Statistics and Machine Learning Toolbox (for GP-related workflows, if applicable).
- Optimisation Toolbox (for screening/optimisation utilities, if applicable).

---

## 5. How to Run (Typical Workflow)

1. **Open Aspen flowsheets**
   - Load the relevant case files under `aspen/`.
   - Verify property method and convergence settings.
   - Run the base case to ensure convergence.

2. **Run MATLAB orchestration**
   - Configure file paths (Aspen model location, output directories).
   - Execute parameter sweeps / scenario runs.
   - Export results to `data/outputs/` as CSV.

3. **Train / evaluate surrogate models (optional)**
   - Use datasets in `data/` or `surrogates/data/`.
   - Train GP symbolic regression models for electrolysers.
   - Validate against withheld test sets and export fitted models.

4. **Compute TEA and LCA indicators**
   - Run scripts in `tea/` and `lca/` using exported process results.
   - Generate manuscript-ready tables and figures.

---

## 6. Reproducibility Notes

- The results depend on:
  - Electricity price and carbon intensity assumptions.
  - Electrolyser performance maps and operating constraints.
  - Cost year, discount rate, plant capacity, and economic assumptions.
  - System boundary and inventory datasets in the LCA module.

Where possible, all assumptions are parameterised and stored in plain-text or spreadsheet formats under `data/`, `tea/`, and `lca/`.

---

## 7. Citation

If you use this repository, please cite the associated manuscript:

**Comparative Assessment of Advanced Carbon-Neutral Methanol Production Pathways through Multi-scale Techno-Economic-Environmental Modelling**

(Please update this section with journal details, year, and DOI once available.)

---

## 8. Licence and Usage

- This repository is provided as supplementary research material for academic use.
- If a licence file is included (e.g., `LICENSE`), it governs permitted usage and redistribution.
- Third-party datasets and software outputs may be subject to their original licences and terms.

---

## 9. Contact

For questions, clarifications, or collaboration opportunities, please contact the corresponding author as listed in the manuscript.

---

## 10. Changelog (optional)

- v1.0: Initial release of supplementary code and data supporting the manuscript workflow.
