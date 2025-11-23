%% stats_MP_vs_VFD.m
% --------------------------------------------------------------
% Analyzes the relationship between effective mechanical power 
% and ventilator-free days (VFD) using linear and log models.
%
% Author: Patri
% Repository: MechanicalPower-Analysis-PANDORA
% --------------------------------------------------------------

clear; clc;

%% Load dataset
file_name = 'PANDORA_complete_patients.xlsx';  % Update if necessary
data = readtable(file_name, 'VariableNamingRule', 'preserve');


%% Define mechanical power variables and VFD variable
mp_vars = {'MP_eff_norm_T0', 'MP_eff_norm_T6', ...
           'MP_eff_norm_D0_VTMAX', 'MP_eff_norm_D1_VTMAX', ...
           'MP_eff_norm_D3_VTMAX', 'MP_eff_norm_D7_VTMAX'};

vfd_var = 'DIAS_LIBRES_VM_MODIF';   % Ventilator-Free Days


%% Loop through each MP variable
for i = 1:length(mp_vars)

    mp = mp_vars{i};

    % Extract valid data
    subset = data(:, {mp, vfd_var});
    subset = subset(~isnan(subset.(mp)) & ~isnan(subset.(vfd_var)), :);
    subset = subset(subset.(mp) > 0 & subset.(vfd_var) > 0, :);

    % Remove extreme outliers (top 5% VFD)
    threshold = prctile(subset.(vfd_var), 95);
    subset = subset(subset.(vfd_var) <= threshold, :);

    % Extract vectors
    x = subset.(mp);
    y = subset.(vfd_var);

    %% Create scatter plot
    figure;
    scatter(x, y, 50, 'b', 'filled', 'MarkerFaceAlpha', 0.5);
    hold on;

    %% Linear regression
    mdl_lin = fitlm(x, y);
    x_fit = linspace(min(x), max(x), 200)';
    y_fit_lin = predict(mdl_lin, x_fit);
    R2_lin = mdl_lin.Rsquared.Ordinary;

    plot(x_fit, y_fit_lin, 'k-', 'LineWidth', 2);

    %% Log regression (if x > 0)
    if all(x > 0)
        p_log = polyfit(log(x), y, 1);
        y_fit_log = polyval(p_log, log(x_fit));
        y_pred_log = polyval(p_log, log(x));
        R2_log = 1 - sum((y - y_pred_log).^2) / sum((y - mean(y)).^2);

        plot(x_fit, y_fit_log, 'r-', 'LineWidth', 2);
    else
        R2_log = NaN;
    end

    %% Plot formatting
    set(gca, 'YScale', 'log');
    title(['Relationship between ', mp, ' and VFD']);
    xlabel(['Mechanical Power: ', mp]);
    ylabel('Ventilator-Free Days (VFD)');
    grid on;

    if ~isnan(R2_log)
        legend({'Data', ...
                ['Linear fit (R² = ', num2str(R2_lin, '%.2f'), ')'], ...
                ['Log fit (R² = ', num2str(R2_log, '%.2f'), ')']}, ...
                'Location', 'northeast');
    else
        legend({'Data', ...
                ['Linear fit (R² = ', num2str(R2_lin, '%.2f'), ')']}, ...
                'Location', 'northeast');
    end


    %% Correlations
    [rho_s, p_s] = corr(x, y, 'Type', 'Spearman');
    [rho_p, p_p] = corr(x, y, 'Type', 'Pearson');

    disp(['--- ', mp, ' ---']);
    disp(['Spearman rho: ', num2str(rho_s), ', p = ', num2str(p_s)]);
    disp(['Pearson r:    ', num2str(rho_p), ', p = ', num2str(p_p)]);
    disp(['R² linear: ', num2str(R2_lin, '%.3f')]);

    if ~isnan(R2_log)
        disp(['R² log:    ', num2str(R2_log, '%.3f')]);
    end

    hold off;
end

disp('✓ Analysis completed.');
