%% plot_cumulative_MP_curves.m
% --------------------------------------------------------------
% Plots cumulative mechanical power (MP) over time for each patient.
% Mechanical power is integrated using trapezoidal approximation 
% (cumtrapz) to obtain cumulative area curves.
%
% Author: Patricia Rodrigo
% Repository: MechanicalPower-Analysis-PANDORA
% --------------------------------------------------------------

clear; clc;

%% Load dataset
file_name = 'PANDORA_complete_patients.xlsx';
data = readtable(file_name, 'VariableNamingRule', 'preserve');


%% Extract unique patient IDs
patient_ids = unique(data.PACIENTE);
n_patients = length(patient_ids);


%% Mechanical power variables over time
mp_vars = {'MP_eff_norm_T0', 'MP_eff_norm_T6', ...
           'MP_eff_norm_D0_VTMAX', 'MP_eff_norm_D1_VTMAX', ...
           'MP_eff_norm_D3_VTMAX', 'MP_eff_norm_D7_VTMAX'};


%% Time points in hours
time_points_original = [0, 6, 12, 24, 72, 168];

% For logarithmic plotting axis (cannot include 0)
time_points_plot = time_points_original + 1;


%% Number of patients per figure (3 × 3 layout)
patients_per_figure = 9;


%% Iterate through blocks of patients
for i = 1:patients_per_figure:n_patients
    
    figure;
    set(gcf, 'Position', [100, 100, 1200, 800]);
    
    block_ids = patient_ids(i : min(i + patients_per_figure - 1, n_patients));
    n_subplots = length(block_ids);
    
    for j = 1:n_subplots
        
        subplot(3, 3, j);
        
        pid = block_ids(j);
        patient_data = data(data.PACIENTE == pid, :);
        
        % Extract MP values for this patient
        mp_values = nan(1, length(mp_vars));
        for k = 1:length(mp_vars)
            var = mp_vars{k};
            if ismember(var, patient_data.Properties.VariableNames)
                mp_values(k) = patient_data.(var);
            end
        end
        
        % Keep only valid values
        valid_idx = ~isnan(mp_values);
        valid_times = time_points_original(valid_idx);
        valid_mp = mp_values(valid_idx);
        
        % Compute cumulative area (trapezoidal integration)
        cumulative_area = cumtrapz(valid_times, valid_mp);
        
        % Shift time for logarithmic plotting
        valid_times_plot = valid_times + 1;
        
        % Plot cumulative mechanical power
        semilogx(valid_times_plot, cumulative_area, '-o', 'LineWidth', 1.5);
        grid on;
        
        title(['Patient ', num2str(pid)]);
        xlabel('Hours since diagnosis');
        ylabel('Cumulative Mechanical Power');
        
        % Restore readable x-axis labels
        xticks(time_points_plot);
        xticklabels(time_points_original);
    end
end
