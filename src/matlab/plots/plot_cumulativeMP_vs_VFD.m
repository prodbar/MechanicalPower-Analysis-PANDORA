%% plot_cumulativeMP_vs_VFD.m
% --------------------------------------------------------------
% Scatter plots and regression models evaluating the relationship
% between cumulative mechanical power (MP) and ventilator-free days (VFD).
%
% Author: Patricia Rodrigo 
% Repository: MechanicalPower-Analysis-PANDORA
% --------------------------------------------------------------

clear; clc;

%% Load dataset
data = readtable('PANDORA_complete_patients.xlsx', 'VariableNamingRule', 'preserve');


%% Extract variables
x_raw = data.AREA_ACUMULADA;         % Cumulative MP
y_raw = data.DIAS_LIBRES_VM_MODIF;   % Ventilator-free days (VFD)


%% Filter valid rows
valid_idx = ~isnan(x_raw) & ~isnan(y_raw) & x_raw > 0 & y_raw > 0;
x = x_raw(valid_idx);
y = y_raw(valid_idx);


%% Create figure
figure;
scatter(x, y, 50, 'b', 'filled', 'MarkerFaceAlpha', 0.6);
hold on;


%% Linear regression (y ~ x)
mdl_lin = fitlm(x, y);
x_fit = linspace(min(x), max(x), 200)';
y_fit_lin = predict(mdl_lin, x_fit);
R2_lin = mdl_lin.Rsquared.Ordinary;
plot(x_fit, y_fit_lin, 'k-', 'LineWidth', 2);


%% Logarithmic regression (y ~ log(x))
log_x = log(x);
mdl_log = fitlm(log_x, y);
y_fit_log = predict(mdl_log, log(x_fit));
R2_log = mdl_log.Rsquared.Ordinary;
plot(x_fit, y_fit_log, 'r-', 'LineWidth', 2);


%% Axes and formatting
set(gca, 'YScale', 'log');
title('Relationship between Cumulative Mechanical Power and VFD');
xlabel('Cumulative Mechanical Power');
ylabel('Ventilator-Free Days (VFD)');
grid on;

legend({'Data', ...
        sprintf('Linear regression (R² = %.3f)', R2_lin), ...
        sprintf('Logarithmic regression (R² = %.3f)', R2_log)}, ...
        'Location', 'northeast');


%% Save figure
saveas(gcf, 'CumulativeMP_vs_VFD.png');

hold off;
