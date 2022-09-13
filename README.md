# RUL-Estimation
Predict the RUL of an engine using run-to-failure dataset
This project shows how to build a complete Remaining Useful Life (RUL) estimation workflow including the steps for preprocessing, selecting trendable features, constructing a health indicator by sensor fusion, training similarity RUL estimators, and validating prognostics performance. The training data was obtained from the PHM2008 challenge dataset (https://ti.arc.nasa.gov/tech/dash/groups/pcoe/prognostic-data-repository/).

The SimilarityRUL is the livescript to obtain the RUL, while the other files are the helperfunctions that are needed in the code. The helperfunctions were obtained from MATLAB's predictive maintainance toolbox and were developed by the Mathworks Inc.
