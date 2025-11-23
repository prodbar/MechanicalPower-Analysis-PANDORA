%% plot_cumulativeMP_vs_mortality.m
% --------------------------------------------------------------
% Compares cumulative mechanical power (MP) between survivors 
% and non-survivors using boxplots and statistical testing.
%
% Author: Patricia Rodrigo
% Repository: MechanicalPower-Analysis-PANDORA
% --------------------------------------------------------------

clear; clc;

%% Load dataset
file_name = 'PANDORA_complete_patients.xlsx';
data = readtable(file_name, 'VariableNamingRule', 'preserve');

%% Variable names
var_area = 'AREA_ACUMULADA';
var_mort = 'MORTALIDAD';

%% Filter valid rows
valid_rows = ~isnan(data.(var_area)) & ~isnan(data.(var_mort));
data = data(valid_rows, :);

%% Extract groups
area_survived = data.(var_area)(data.(var_mort) == 0);
area_died     = data.(var_area)(data.(var_mort) == 1);

n_survived = length(area_survived);
n_died     = length(area_died);

%% Create boxplot
figure;
boxplot([area_survived; area_died], ...
        [zeros(size(area_survived)); ones(size(area_died))], ...
        'Labels', {['Survived (N = ' num2str(n_survived) ')'], ...
                   ['Died (N = ' num2str(n_died) ')']});

xlabel('Mortality status');
ylabel('Cumulative Mechanical Power');
title('Cumulative Mechanical Power Comparison by Mortality');
grid on;

saveas(gcf, 'boxplot_cumulativeMP_mortality.png');

%% Normality test
[h_norm, p_norm] = kstest(data.(var_area));

%% Select appropriate statistical test
if p_norm < 0.05
    % Non-parametric: Mann-Whitney U test
    p_val = ranksum(area_survived, area_died);
else
    % Parametric: two-sample t-test
    [~, p_val] = ttest2(area_survived, area_died);
end

disp(['[Cumulative MP] p-value: ', num2str(p_val)]);
