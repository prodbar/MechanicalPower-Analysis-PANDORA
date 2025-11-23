%% stats_distribution_logPMA.m
% --------------------------------------------------------------
% Examines the distribution of log-transformed cumulative mechanical 
% power using histogram, theoretical normal curve, and Shapiro–Wilk test.
%
% Author: Patricia Rodrigo
% Repository: MechanicalPower-Analysis-PANDORA
% --------------------------------------------------------------

clear; clc;

%% Load dataset
data = readtable('PANDORA_complete_patients.xlsx', 'VariableNamingRule', 'preserve');

%% Extract log-transformed cumulative mechanical power
log_PMA = data.log_AREA_ACUMULADA;

%% Remove missing values
log_PMA = log_PMA(~isnan(log_PMA));

%% Report number of valid cases
n_cases = length(log_PMA);
fprintf('\nNumber of valid log-transformed cases: %d\n', n_cases);

%% Shapiro–Wilk test for normality
[h, p_value, W] = swtest(log_PMA, 0.05);

fprintf('\n--- Shapiro–Wilk Test for log(AREA_ACUMULADA) ---\n');
fprintf('W = %.4f, p = %.4f\n', W, p_value);

if h == 1
    disp('Normality rejected: log(PMA) does not follow a normal distribution.');
else
    disp('Normality not rejected: log(PMA) is compatible with a normal distribution.');
end

%% Histogram with theoretical normal curve
mu = mean(log_PMA);
sigma = std(log_PMA);

x_vals = linspace(min(log_PMA), max(log_PMA), 100);
y_vals = normpdf(x_vals, mu, sigma);

figure;
histogram(log_PMA, 'Normalization', 'pdf', 'FaceColor', [0.6 0.8 1]);
hold on;
plot(x_vals, y_vals, 'k--', 'LineWidth', 2);

title('Distribution of log-transformed Cumulative Mechanical Power');
xlabel('log(Cumulative Mechanical Power)');
ylabel('Probability Density');
legend('Histogram (normalized)', 'Theoretical Normal Curve');
grid on;
hold off;
