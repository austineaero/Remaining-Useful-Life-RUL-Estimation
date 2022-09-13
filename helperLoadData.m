function degradationData = helperLoadData(filename)
% Load degradation data from text file and convert to cell array of tables.
%
% This function supports the Similarity-based Remaining Useful Life
% Estimation example. It may change in a future release.

% Copyright 2017-2018 The MathWorks, Inc.

% Load the text file as a table
t = readtable(filename);
t(:,end) = []; %Discard last column of loaded data as all are empty ''

% Add variable names to the table
VarNames = {...
    'id', 'time', 'op_setting_1', 'op_setting_2', 'op_setting_3', ...
    'sensor_1', 'sensor_2', 'sensor_3', 'sensor_4', 'sensor_5', ...
    'sensor_6', 'sensor_7', 'sensor_8', 'sensor_9', 'sensor_10', ...
    'sensor_11', 'sensor_12', 'sensor_13', 'sensor_14', 'sensor_15', ...
    'sensor_16', 'sensor_17', 'sensor_18', 'sensor_19', 'sensor_20', ...
    'sensor_21'};
t.Properties.VariableNames = VarNames;

% Split the signals from each machine ID into individual tables 
% and collect the tables in a cell array.
IDs = t{:,1};
nID = unique(IDs);
degradationData = cell(numel(nID),1);
for ct=1:numel(nID)
    idx = IDs == nID(ct);
    degradationData{ct} = t(idx,:);
end
end