%% compute_anomalies.m
% --------------------------------------------------------------
% Detects abnormal ventilatory values for each variable based on 
% predefined physiological ranges.
%
% Author: Patricia Rodrigo
% Repository: MechanicalPower-Analysis-PANDORA
% --------------------------------------------------------------

clear; clc;

%% Load dataset
data = readtable('PAND_220124_reduced.xlsx'); 
% IMPORTANT: update filename if necessary


%% List of variables to evaluate
variables = { ...
    'PCI', 'DOPRISMIII', ...
    'T0VTML', 'T0VTML_PCI', 'T0PEEP', 'T0FR', 'T0PPLAT', 'T0PPI', ...
    'T6VTML', 'T6VTML_PCI', 'T6PEEP', 'T6FR', 'T6PPLAT', 'T6PPI', ...
    'D0VTMAX', 'D0VTMAX_PCI', 'D0VTMIN', 'D0VTMIN_PCI', 'D0FRMAX', ...
    'D0PPIMAX', 'D0PPLATMAX', 'D0PEEPMAX', ...
    'D1VTMAX', 'D1VTMAX_PCI', 'D1VTMIN', 'D1VTMIN_PCI', 'D1FRMAX', ...
    'D1PPIMAX', 'D1PPLATMAX', 'D1PEEPMAX', ...
    'D3VTMAX', 'D3VTMAX_PCI', 'D3VTMIN', 'D3VTMIN_PCI', 'D3FRMAX', ...
    'D3PPIMAX', 'D3PPLATMAX', 'D3PEEPMAX', ...
    'D7VTMAX', 'D7VTMAX_PCI', 'D7VTMIN', 'D7VTMIN_PCI', 'D7FRMAX', ...
    'D7PPIMAX', 'D7PPLATMAX', 'D7PEEPMAX' ...
};


%% Normal ranges for each variable
normal_ranges = struct( ...
    'PCI', [6, 10], 'DOPRISMIII', [0, 100], ...
    'T0VTML', [6, 10], 'T0VTML_PCI', [6, 10], 'T0PEEP', [5, 10], 'T0FR', [12, 60], ...
    'T0PPLAT', [20, 30], 'T0PPI', [20, 35], 'T6VTML', [6, 10], 'T6VTML_PCI', [6, 10], ...
    'T6PEEP', [5, 10], 'T6FR', [12, 60], 'T6PPLAT', [20, 30], 'T6PPI', [20, 35], ...
    'D0VTMAX', [6, 10], 'D0VTMAX_PCI', [6, 10], 'D0VTMIN', [6, 10], 'D0VTMIN_PCI', [6, 10], ...
    'D0FRMAX', [12, 60], 'D0PPIMAX', [20, 35], 'D0PPLATMAX', [20, 30], 'D0PEEPMAX', [5, 10], ...
    'D1VTMAX', [6, 10], 'D1VTMAX_PCI', [6, 10], 'D1VTMIN', [6, 10], 'D1VTMIN_PCI', [6, 10], ...
    'D1FRMAX', [12, 60], 'D1PPIMAX', [20, 35], 'D1PPLATMAX', [20, 30], 'D1PEEPMAX', [5, 10], ...
    'D3VTMAX', [6, 10], 'D3VTMAX_PCI', [6, 10], 'D3VTMIN', [6, 10], 'D3VTMIN_PCI', [6, 10], ...
    'D3FRMAX', [12, 60], 'D3PPIMAX', [20, 35], 'D3PPLATMAX', [20, 30], 'D3PEEPMAX', [5, 10], ...
    'D7VTMAX', [6, 10], 'D7VTMAX_PCI', [6, 10], 'D7VTMIN', [6, 10], 'D7VTMIN_PCI', [6, 10], ...
    'D7FRMAX', [12, 60], 'D7PPIMAX', [20, 35], 'D7PPLATMAX', [20, 30], 'D7PEEPMAX', [5, 10]);


%% Initialize results table
results = table('Size', [length(variables), 4], ...
    'VariableTypes', {'string', 'double', 'double', 'double'}, ...
    'VariableNames', {'Variable', 'N_Total', 'N_Abnormal', 'Percent_Abnormal'});


%% Main loop
for i = 1:length(variables)
    var = variables{i};

    if ismember(var, data.Properties.VariableNames)
        column_data = data.(var);

        % clean data: remove NaN + zero values
        column_data = column_data(~isnan(column_data) & column_data ~= 0);

        % get normal range
        limits = normal_ranges.(var);
        lower = limits(1);
        upper = limits(2);

        % abnormal values
        N_total = length(column_data);
        N_abnormal = sum(column_data < lower | column_data > upper);
        P_abnormal = 100 * N_abnormal / N_total;

        % fill table
        results.Variable(i) = var;
        results.N_Total(i) = N_total;
        results.N_Abnormal(i) = N_abnormal;
        results.Percent_Abnormal(i) = P_abnormal;

    else
        results.Variable(i) = var;
        results.N_Total(i) = NaN;
        results.N_Abnormal(i) = NaN;
        results.Percent_Abnormal(i) = NaN;
    end
end


%% Export results
disp(results);
writetable(results, 'AbnormalValuesSummary.xlsx');

disp('✓ Abnormality detection completed.');
