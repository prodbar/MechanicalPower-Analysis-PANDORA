%% stats_logPMA_vs_mortality.m
% --------------------------------------------------------------
% Compares log-transformed cumulative mechanical power (log-PMA)
% between survivors and non-survivors using an independent
% two-sample t-test.
%
% Author: Patricia Rodrigo
% Repository: MechanicalPower-Analysis-PANDORA
% --------------------------------------------------------------

clear; clc;

%% Load dataset
file_name = 'PANDORA_complete_patients.xlsx';
data = readtable(file_name, 'VariableNamingRule', 'preserve');

%% Check required columns
if ~ismember('log_AREA_ACUMULADA', data.Properties.VariableNames)
    error('Column "log_AREA_ACUMULADA" is not present in the dataset.');
end

if ~ismember('MORTALIDAD', data.Properties.VariableNames)
    error('Column "MORTALIDAD" is not present in the dataset.');
end

%% Variables
log_PMA    = data.log_AREA_ACUMULADA;
mortality  = data.MORTALIDAD;   % 0 = survived, 1 = died

%% Filter valid values
log_PMA_alive  = log_PMA(mortality == 0 & ~isnan(log_PMA));
log_PMA_dead   = log_PMA(mortality == 1 & ~isnan(log_PMA));

%% Independent two-sample t-test
[h, p] = ttest2(log_PMA_alive, log_PMA_dead);

%% Display results
fprintf('\n--- Comparison of log(PMA) by mortality status (two-sample t-test) ---\n');
fprintf('p = %.4f\n', p);

if h == 1
    disp('Significant difference between survivors and non-survivors (H0 rejected).');
else
    disp('No significant difference between survivors and non-survivors (H0 not rejected).');
end
