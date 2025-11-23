%% stats_MP_variables.m
% --------------------------------------------------------------
% Computes descriptive statistics for all effective mechanical 
% power variables (mean, SD, median, min, max, abnormal values).
%
% Author: Patri
% Repository: MechanicalPower-Analysis-PANDORA
% --------------------------------------------------------------

clear; clc;

%% Load dataset
file_name = 'PANDORA_BD.xlsx';     % Update name if needed
data = readtable(file_name);


%% List of mechanical power variables
mp_vars = { ...
    'MP_eff_norm_T0', 'MP_eff_norm_T6', ...
    'MP_eff_norm_D0_VTMAX', 'MP_eff_norm_D0_VTMIN', ...
    'MP_eff_norm_D1_VTMAX', 'MP_eff_norm_D1_VTMIN', ...
    'MP_eff_norm_D3_VTMAX', 'MP_eff_norm_D3_VTMIN', ...
    'MP_eff_norm_D7_VTMAX', 'MP_eff_norm_D7_VTMIN' ...
};


%% Initialize results table
results = table('Size', [length(mp_vars), 11], ...
    'VariableTypes', {'string','double','double','double','double','double','double','double','string','double','double'}, ...
    'VariableNames', {'Variable','N_Patients','N_Missing','Mean','SD','Median','Min','Max','NormalRange','N_Abnormal','Percent_Abnormal'});


%% Normal range (adjust depending on your criteria)
range_min = 30;
range_max = 50;


%% Process each mechanical power variable
for i = 1:length(mp_vars)
    
    var = mp_vars{i};

    if ismember(var, data.Properties.VariableNames)

        column = data.(var);

        % valid values (exclude NaN)
        valid = column(~isnan(column));

        % stats
        n_patients = length(valid);
        n_missing  = sum(isnan(column));
        mean_v     = mean(valid);
        sd_v       = std(valid);
        med_v      = median(valid);
        min_v      = min(valid);
        max_v      = max(valid);

        % abnormal values
        n_abnormal = sum(valid < range_min | valid > range_max);
        p_abnormal = 100 * n_abnormal / n_patients;

        % store in table
        results.Variable(i)           = var;
        results.N_Patients(i)         = n_patients;
        results.N_Missing(i)          = n_missing;
        results.Mean(i)               = mean_v;
        results.SD(i)                 = sd_v;
        results.Median(i)             = med_v;
        results.Min(i)                = min_v;
        results.Max(i)                = max_v;
        results.NormalRange(i)        = sprintf('%d-%d', range_min, range_max);
        results.N_Abnormal(i)         = n_abnormal;
        results.Percent_Abnormal(i)   = p_abnormal;

    else
        warning('Variable "%s" not found in dataset.', var);
    end
end


%% Export results
output_file = 'MP_DescriptiveStatistics.xlsx';
writetable(results, output_file);

disp(['✓ Statistical summary saved as: ', output_file]);
