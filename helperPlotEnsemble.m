function helperPlotEnsemble(ensemble, TimeVariable, DataVariables, nsample, varargin)
% HELPERPLOTENSEMBLE Helper function to plot ensemble data
%
% This function supports the Similarity-based Remaining Useful Life
% Estimation example. It may change in a future release.

% Copyright 2017-2018 The MathWorks, Inc.

% Ensemble is a cell array of matrices/timetables/tables
randIdx = randperm(length(ensemble));
ensembleSample = ensemble(randIdx(1:nsample));
numData = length(DataVariables);
for i = 1:numData
    data2plot = DataVariables(i);
    subplot(numData, 1, i)
    hold on
    for j = 1:length(ensembleSample)
        ensembleMember = ensembleSample{j};
        if isa(ensembleMember, 'double')
            % TimeVariable and DataVariables are doubles
            if isempty(TimeVariable)
                plot(ensembleMember(:, DataVariables), varargin{:})
            else
                plot(ensembleMember(:, TimeVariable), ensembleMember(:, DataVariables), varargin{:})
            end
            xlblstr = "time";
            ylblstr = "Var " + data2plot;
        else
            % ensembleMember is a table
            plot(ensembleMember.(char(TimeVariable)), ensembleMember.(char(data2plot)), varargin{:})
            xlblstr = TimeVariable;
            ylblstr = data2plot;
        end
    end
    hold off
    ylabel(ylblstr, 'Interpreter', 'none')
end
xlabel(xlblstr)
end