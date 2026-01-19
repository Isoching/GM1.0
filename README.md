# Supplementary Code and Data Repository

This repository provides supplementary code, models, and datasets supporting the manuscript:

**Comparative Assessment of Advanced Carbon-Neutral Methanol Production Pathways through Multi-scale Techno-Economic-Environmental Modelling**

It is intended to improve transparency, reproducibility, and reusability of the modelling workflow used to compare carbon-neutral methanol production routes under consistent techno-economic and energy assumptions.

---

## 1. Scope and Content

The repository implements a **steady-state, multi-scale modelling workflow** for green methanol production, integrating:

- **Process-level steady-state simulation** in **Aspen Plus** to resolve mass and energy balances, equipment duties, and stream properties across the system.
- **MATLAB orchestration** for case management, parameter sweeps, data handling, and post-processing.
- **Techno-Economic Analysis (TEA)** to quantify cost drivers and report comparable economic metrics across pathways.
- **Energy analysis** to quantify system electricity and utility requirements under consistent boundaries and operating assumptions.
- **Data-driven surrogate modelling** based on an updated symbolic regression workflow:
  - **GMGPTIPS2F**, an updated evolution of the MATLAB toolbox originally developed by **Dr. Dominic Searson (GPTIPS2F)**.

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
    - Computing system-level KPIs for TEA and energy reporting.
    - Generating plots and tables used in the manuscript and supporting information.

- `surrogates/`
  - Training datasets, model definitions, and evaluation scripts for surrogate models.
  - Symbolic regression workflows using GMGPTIPS2F for CO2 and water electrolysers.

- `tea/`
  - Cost models, assumptions, and calculation scripts.
  - CAPEX/OPEX breakdown templates and economic parameter files.

- `data/`
  - Input datasets (operating conditions, scenario parameters).
  - Exported model outputs (as CSV) used for analysis and surrogate training.

- `figures/`
  - Figure generation scripts and exported images (optional; may be generated locally).

- `docs/`
  - Additional documentation, parameter definitions, and workflow notes.

---

## 3. Modelling Overview

### 3.1 Baseline Framework and Adaptation
This data-driven model for green methanol was developed by adapting and modestly modifying a baseline modelling framework to suit the present case study. Two tasks were completed:

1. **Electrolyser surrogate modelling:** surrogate models were constructed for the carbon dioxide electrolyser and the water electrolyser to quantify relationships between operating variables and observed responses.
2. **System-scale assessment:** at the overall system scale, **techno-economic and energy analyses** were performed for the methanol production system.

### 3.2 Process Simulation (Aspen Plus)
Aspen Plus flowsheets implement steady-state representations of the methanol production system. Key outputs include:
- Stream compositions, flowrates, temperatures, and pressures.
- Unit operation duties and power requirements (e.g., compressors, pumps, heaters/coolers).
- Conversion, selectivity, purge losses, recycle ratios, and separation performance.
- Utility and electricity consumption to support TEA and energy calculations.

### 3.3 Unit-Level Surrogate Models (GMGPTIPS2F)
Electrolyser units are represented using symbolic-regression surrogates built with **GMGPTIPS2F**, which is the updated evolution of the MATLAB toolbox originally developed by **Dr. Dominic Searson (GPTIPS2F)**. Typical inputs and outputs include:
- Inputs: current density, temperature, pressure, feed composition, and operating constraints (as applicable).
- Outputs: Faradaic efficiency, cell voltage, specific electricity consumption, production rates, and auxiliary power (if modelled).

---

## 4. Requirements

### 4.1 Software
- Aspen Plus (version used in the study should be documented in `aspen/README.md` if available).
- MATLAB (R2020a or later recommended; earlier versions may work depending on toolboxes).

### 4.2 Typical MATLAB Toolboxes (if used)
- Statistics and Machine Learning Toolbox (if required by specific scripts).
- Optimisation Toolbox (if required by screening/optimisation utilities).

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

3. **Train / evaluate surrogate models**
   - Use datasets in `data/` or `surrogates/data/`.
   - Train GMGPTIPS2F symbolic regression models for the CO2 and water electrolysers.
   - Validate against withheld test sets and export fitted models.

4. **Compute TEA and energy indicators**
   - Run scripts in `tea/` (and any energy modules under `matlab/`).
   - Generate manuscript-ready tables and figures.

---

## 6. Reproducibility Notes

The reported results depend on:
- Electrolyser performance maps, surrogate training data, and operating constraints.
- Electricity price assumptions and any energy boundary definitions.
- Cost year, discount rate, plant capacity, and economic assumptions.

Where possible, assumptions are parameterised and stored in plain-text or spreadsheet formats under `data/` and `tea/`.

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
