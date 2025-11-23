%% stats_distribution_cumulativeMP.m
% --------------------------------------------------------------
% Examines the distribution of cumulative mechanical power (PMA)
% using a normalized histogram, fitted normal distribution curve,
% and the Shapiro–Wilk test for normality.
%
% Author: Patricia Rodrigo
% Repository: MechanicalPower-Analysis-PANDORA
% --------------------------------------------------------------

clear; clc;

%% Load dataset
data = readtable('PANDORA_complete_patients.xlsx', 'VariableNamingRule', 'preserve');

%% Extract cumulative mechanical power variable
PMA = data.AREA_ACUMULADA;

%% Histogram (normalized)
figure;
histogram(PMA, 'Normalization', 'pdf', 'FaceColor', [0.5 0.7 1]);
hold on;

%% Theoretical normal curve
mu = mean(PMA, 'omitnan');
sigma = std(PMA, 'omitnan');

x_norm = linspace(min(PMA), max(PMA), 100);
y_norm = normpdf(x_norm, mu, sigma);

plot(x_norm, y_norm, 'k--', 'LineWidth', 2);

%% Formatting
title('Distribution of Cumulative Mechanical Power (AREA\_ACUMULADA)');
xlabel('Cumulative Mechanical Power (J)');
ylabel('Probability Density');
legend('Histogram', 'Normal distribution');
grid on;

%% Shapiro–Wilk normality test
% Requires swtest.m (Statistics Toolbox or user function)
[h, p_value, W] = swtest(PMA, 0.05);

if h == 1
    disp('Normality rejected (PMA does not follow a normal distribution).');
else
    disp('Normality not rejected (PMA is compatible with a normal distribution).');
end

fprintf('W = %.4f, p = %.4f\n', W, p_value);

hold off;
