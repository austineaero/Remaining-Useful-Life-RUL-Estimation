# RUL Estimation (Turbofan Engine)

**Author:** Augustine Osaigbevo  

---

## Table of Contents

* [Project Description](#project-description)  
* [Repository Structure](#repository-structure)  
* [Instructions (How to Run)](#instructions-how-to-run)  
* [Technical Approach](#technical-approach)  
* [Results & Performance](#results--performance)  
* [Challenges & Mitigations](#challenges--mitigations)  
* [Next Steps](#next-steps)  
* [Credits](#credits)

---

## Project Description

This project implements a **similarity-based Remaining Useful Life (RUL)** estimation workflow for turbofan jet engines.  

By analysing **run-to-failure trajectories** from historical engines, the method estimates how much useful life a current engine has left, along with confidence bounds.  

### Why it matters

- **Safety:** Early and reliable failure prediction prevents in-flight shutdowns and unscheduled removals, ensuring higher operational safety.  
- **Cost savings:** Predictive maintenance avoids unnecessary preventive part replacements, while also minimising costly unplanned downtime (aircraft-on-ground events).  
- **Operational efficiency:** Condition-based maintenance allows airlines and MROs to schedule interventions just-in-time, improving fleet utilisation.  

In short: **predictive maintenance = safer flights, lower costs, smarter scheduling.**

---

## Repository Structure

```
Similarity_RUL.mlx               # Main MATLAB Live Script: end-to-end workflow
helperLoadData.m                 # Load/convert NASA turbofan data into timetables
helperPlotEnsemble.m             # Visualize run-to-failure ensemble
helperPlotClusters.m             # Visualize operating-regime clusters
helperPlotRULDistribution.m      # Plot RUL PDF, estimate, and confidence bands
README.md
```


> The dataset (NASA C-MAPSS / PHM08) is automatically downloaded and preprocessed by the live script.

---

## Instructions (How to Run)

### 1) Requirements
- MATLAB (R2022b or later recommended)  
- Predictive Maintenance Toolbox  

### 2) Clone the repo
```bash
git clone https://github.com/austineaero/Remaining-Useful-Life-RUL-Estimation.git
cd Remaining-Useful-Life-RUL-Estimation
```

### 3) Open and run
- Open Similarity_RUL.mlx in MATLAB.
- Run all sections sequentially:
  1. Load and preprocess data
  2. Normalise across operating regimes
  3. Construct health indicators
  4. Train residual-similarity RUL model
  5. Evaluate predictions at different observation horizons

---

## Technical Approach

### 1. Data Preparation
- Use NASA turbofan run-to-failure dataset.
- Split into training and validation engine sets.
### 2. Handling Operating Regimes
- Cluster trajectories by operating condition (e.g., throttle/altitude).
- Apply regime-specific normalisation to remove biases.
### 3. Feature Screening
- Compute trendability, monotonicity, and prognosability scores.
- Retain only features that evolve consistently with degradation.
### 4. Health Indicator (HI) Fusion
- Fuse selected sensor features into a single HI.
- Apply offsetting and smoothing so engines align at time zero.
### 5. Residual-Similarity RUL Estimation
- Fit a polynomial model to each training HI.
- For a test engine, compute residuals against each trained model.
- Use L1 distance to find K most similar histories.
- Estimate RUL distribution from the selected neighbors → provides both point estimate and confidence intervals.
### 6. Performance Evaluation
- Compare RUL estimates when 50%, 70%, 90% of trajectory observed.
- Assess accuracy, bias, and spread of prediction intervals.

---

## Results & Performance

### Key Observations
- Early in life: RUL distributions are wide (greater uncertainty).
- Closer to failure: estimates tighten significantly, giving high confidence.
- Method balances accuracy with uncertainty quantification, providing safer decision-making for maintenance.

1. Ensemble of run-to-failure trajectories (health indicator over time)
<div align="center">
  <img width="48%" alt="training_data" src="https://github.com/user-attachments/assets/24e2846d-d15f-4854-a745-d8e20ec2d80a" style="display: inline-block;">
  <img width="48%" alt="validation_data" src="https://github.com/user-attachments/assets/b9c149bd-9757-4693-bb07-b5fe83c63fde" style="display: inline-block;">
</div>

2. Clustered operating regimes visualisation
<div align="center">
  <img width="48%" alt="clustering_1" src="https://github.com/user-attachments/assets/83ec1eea-afaa-4572-b3c4-692c31dc0616" style="display: inline-block;">
  <img width="48%" alt="clustering_2" src="https://github.com/user-attachments/assets/49c8d9d5-a8d1-48e3-8d3b-8a241a1f027e" style="display: inline-block;">
</div>

3. Trendability/monotonicity/prognosability scores for feature selection
<div align="center">
  <img width="48%" alt="trendability" src="https://github.com/user-attachments/assets/34b3564e-139d-445f-a919-aca06aebee4b" style="display: inline-block;">
  <img width="48%" alt="health_condition" src="https://github.com/user-attachments/assets/bbbcf907-40ed-4c8b-bf93-79fafc028901" style="display: inline-block;">
</div>

4. KNN vs. RUL (by % life observed)

| % Observed | KNN (nearest neighbours in HI space) | RUL PDF (mean + 90% CI) |
|:--:|:--:|:--:|
| 50% life | ![knn_50](https://github.com/user-attachments/assets/594dce04-028e-417f-aa27-7cebb126888c) | ![rul_50](https://github.com/user-attachments/assets/6e978190-7ca3-42cd-88cc-8c6e4eff8350) |
| 70% life | ![knn_70](https://github.com/user-attachments/assets/81b2d503-8336-407f-9c99-c37e8240d797) | ![rul_70](https://github.com/user-attachments/assets/392d6a3f-edf9-4f07-a3ef-01d7c521ca35) |
| 90% life | ![knn_90](https://github.com/user-attachments/assets/8546982f-3244-44eb-8b8b-2ba89436badd) | ![rul_90](https://github.com/user-attachments/assets/1cdf5553-c3f2-4ea8-9fa2-226cf22b7515) |


| Observation | Mean Absolute Error (MAE) | 90% CI Coverage |
|:--:|:--:|:--:|
| 50% life    | Higher error, wide CI      | ~95%            |
| 70% life    | Improved accuracy          | ~92%            |
| 90% life    | High accuracy, narrow CI   | ~90%            |

--

## Challenges & Mitigations

| Challenge | Mitigation |
|-----------|------------|
| Engines operate under multiple regimes → sensor drift | Cluster regimes and normalise within each cluster |
| Noisy or inconsistent sensor channels | Feature scoring → select only robust indicators |
| Misaligned degradation progression | Offset and smooth health indicators |
| Mid-life predictions have wide uncertainty | Provide RUL PDFs with confidence bands, update as new data arrives |

---

## Next Steps

- Experiment with alternative distance metrics (Dynamic Time Warping, Mahalanobis).  
- Explore deep learning-based HI extraction (autoencoders, LSTMs).  
- Calibrate confidence intervals via conformal prediction.  
- Extend to Python implementation (PyTorch/tslearn) for open-source portability.  
- Package workflow as a deployable web service for maintenance engineers.  

---

## Credits

- MathWorks Predictive Maintenance Toolbox 

- NASA Ames PCoE Datasets (C-MAPSS / PHM08 turbofan engine run-to-failure data):  
  https://www.nasa.gov/intelligent-systems-division/discovery-and-systems-health/pcoe/pcoe-data-set-repository/  

