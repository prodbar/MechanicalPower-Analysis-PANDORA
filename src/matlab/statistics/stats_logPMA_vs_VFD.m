%% stats_logPMA_vs_VFD.m
% --------------------------------------------------------------
% Computes Spearman correlation between log-transformed cumulative
% mechanical power (log-PMA) and ventilator-free days (VFD).
%
% Author: Patricia Rodrigo
% Repository: MechanicalPower-Analysis-PANDORA
% --------------------------------------------------------------

clear; clc;

%% Load dataset
file_name = 'PANDORA_complete_patients.xlsx';
data = readtable(file_name, 'VariableNamingRule', 'preserve');

%% Extract variables
log_PMA = data.log_AREA_ACUMULADA;
VFD = data.DIAS_LIBRES_VM_MODIF;

%% Filter valid rows
valid_idx = ~isnan(log_PMA) & ~isnan(VFD);
log_PMA = log_PMA(valid_idx);
VFD = VFD(valid_idx);

%% Spearman correlation
[rho, p_value] = corr(log_PMA, VFD, 'Type', 'Spearman');

%% Display results
fprintf('\n--- Spearman Correlation: log(PMA) vs VFD ---\n');
fprintf('rho = %.4f, p = %.4f\n', rho, p_value);

if p_value < 0.05
    disp('Significant correlation.');
else
    disp('No significant correlation.');
end
