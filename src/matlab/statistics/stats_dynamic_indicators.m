%% stats_dynamic_indicators.m
% --------------------------------------------------------------
% Computes dynamic indicators derived from cumulative mechanical 
% power (MP) curves: total area, mean MP, maximum slope, T50, 
% Ratio24h, and variance of increments.
%
% Author: Patricia Rodrigo
% Repository: MechanicalPower-Analysis-PANDORA
% --------------------------------------------------------------

clear; clc;

%% Load dataset
data = readtable('PM_acumulada.xlsx', 'VariableNamingRule', 'preserve');


%% Extract patient IDs
patients = data.PACIENTE;

%% Time points (hours)
time_points = [0 6 12 24 72 168];
column_time_labels = {'T0','T6','T12','T24','T72','T168'};

%% Table to store results
results = table;

%% Loop through each patient
for i = 1:height(data)

    patient_id = patients(i);

    % Extract cumulative MP curve for this patient
    curve = table2array(data(i, column_time_labels));

    % Keep valid values
    valid_idx = ~isnan(curve);
    valid_times = time_points(valid_idx);
    valid_area = curve(valid_idx);

    if length(valid_area) < 2
        continue
    end

    %% Total cumulative area
    area_total = valid_area(end);

    %% Duration (hours)
    duration_hours = valid_times(end) - valid_times(1);
    MP_mean = area_total / duration_hours;

    %% Slopes between consecutive points
    delta_area = diff(valid_area);
    delta_time = diff(valid_times);
    slopes = delta_area ./ delta_time;
    max_slope = max(slopes);

    %% Variance of increments (progressivity)
    var_increments = var(delta_area);

    %% Interpolate cumulative area with 1-hour resolution
    time_interp = 0:1:168;
    area_interp = interp1(valid_times, valid_area, time_interp, 'linear');

    %% T50: time until 50% of total area is accumulated
    half_area = area_total / 2;
    idx_T50 = find(area_interp >= half_area, 1, 'first');
    T50_hours_interp = time_interp(idx_T50);

    %% Ratio24h: proportion of cumulative area delivered in first 24 hours
    idx_24 = find(time_interp <= 24, 1, 'last');
    area_24h = area_interp(idx_24);
    Ratio24h = area_24h / area_total;

    %% Store results
    row = table(patient_id, area_total, MP_mean, max_slope, ...
                T50_hours_interp, Ratio24h, var_increments);

    results = [results; row];
end


%% Rename table columns
results.Properties.VariableNames = { ...
    'Patient_ID', ...
    'Area_Total', ...
    'MP_Mean', ...
    'Max_Slope', ...
    'T50_Hours', ...
    'Ratio24h', ...
    'Var_Increments' ...
};

%% Export to Excel
writetable(results, 'Dynamic_MP_Indicators.xlsx');
disp('Dynamic indicators saved to Dynamic_MP_Indicators.xlsx');
