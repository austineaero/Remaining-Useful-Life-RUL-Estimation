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

4. Nearest-neighbor selection in HI space


5. RUL probability distributions (with 90% CI) for Examples A, B, C

| 50% | <img width="560" height="337" alt="knn_50p" src="https://github.com/user-attachments/assets/550e505e-db49-4138-8a9b-b30b095f257d" />
 | <img width="560" height="337" alt="rul_50p" src="https://github.com/user-attachments/assets/e7b1c846-cb39-4b2d-b9d4-00c54e3dc165" />
 |
| :---: | :---: | :---: |
| 70% |  |  |
| :---: | :---: | :---: |
| 90% |  |  |

![KNN — Example A](https://uk.mathworks.com/help/examples/predmaint/win64/SimilarityBasedRULExample_09.png)
![KNN — Example B](https://uk.mathworks.com/help/examples/predmaint/win64/SimilarityBasedRULExample_11.png)
![KNN — Example C](https://uk.mathworks.com/help/examples/predmaint/win64/SimilarityBasedRULExample_13.png)

Example Output Table
Observation	Mean Absolute Error (MAE)	90% CI Coverage
50% life	Higher error, wide CI	~95%
70% life	Improved accuracy	~92%
90% life	High accuracy, narrow CI	~90%
