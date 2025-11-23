%% stats_MP_vs_mortality.m
% --------------------------------------------------------------
% Compares effective mechanical power values between survivors 
% and non-survivors using boxplots and data validation.
%
% Author: Patricia Rodrigo 
% Repository: MechanicalPower-Analysis-PANDORA
% --------------------------------------------------------------

clear; clc;

%% Load dataset
file_name = 'PANDORA_complete_patients.xlsx';  
data = readtable(file_name, 'VariableNamingRule', 'preserve');


%% Define variables
mp_vars = {'MP_eff_norm_T0', 'MP_eff_norm_T6', ...
           'MP_eff_norm_D0_VTMAX', 'MP_eff_norm_D1_VTMAX', ...
           'MP_eff_norm_D3_VTMAX', 'MP_eff_norm_D7_VTMAX'};

mortality_var = 'MORTALIDAD';   % Binary variable: 0 = survived, 1 = died


%% Ensure mortality is numeric
data.(mortality_var) = str2double(string(data.(mortality_var)));

% Remove entries with missing mortality values
data = data(~isnan(data.(mortality_var)), :);

% Validate mortality values
unique_vals = unique(data.(mortality_var));
disp('Unique values in mortality variable:');
disp(unique_vals);

if ~all(ismember(unique_vals, [0, 1]))
    error('Mortality variable contains values other than 0 and 1.');
end


%% Create figure
figure;
tiledlayout(2, 3);


%% Loop through each mechanical power variable
for i = 1:length(mp_vars)

    mp = mp_vars{i};

    % Filter valid data
    subset = data(:, {mp, mortality_var});
    subset = subset(~isnan(subset.(mp)), :);
    subset = subset(subset.(mp) > 0, :);

    % Extract vectors
    x = subset.(mp);
    y = subset.(mortality_var);

    % Count per group
    n_survived = sum(y == 0);
    n_died = sum(y == 1);

    % Plot
    nexttile;
    boxplot(x, y, ...
        'Labels', {['Survived (N=' num2str(n_survived) ')'], ...
                   ['Died (N=' num2str(n_died) ')']});

    title(['Mechanical Power: ', strrep(mp, '_', ' ')], 'FontSize', 10);
    xlabel('Mortality status');
    ylabel('Mechanical Power');
    grid on;

end


%% Figure title
sgtitle('Mechanical Power Comparison by Mortality Status', 'FontSize', 14);
