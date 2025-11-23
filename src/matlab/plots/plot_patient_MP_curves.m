%% plot_patient_MP_curves.m
% --------------------------------------------------------------
% Plots individual mechanical power (MP) time curves for each patient,
% using logarithmic scale on the X-axis (time in hours).
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

% Time points in hours
time_points_original = [0, 6, 12, 24, 72, 168];

% Adjust for semilogx (log axis cannot include 0)
time_points = time_points_original + 1;


%% Number of patients per figure (grid layout 3 × 3)
patients_per_figure = 9;


%% Iterate through patient blocks
for i = 1:patients_per_figure:n_patients
    
    figure;
    set(gcf, 'Position', [100, 100, 1200, 800]);  % Figure size
    
    % Select block of patients
    block_ids = patient_ids(i : min(i + patients_per_figure - 1, n_patients));
    n_subplots = length(block_ids);
    
    for j = 1:n_subplots
        
        subplot(3, 3, j);
        
        % Select one patient
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
        
        % Clean invalid entries
        valid_idx = ~isnan(mp_values);
        valid_times = time_points(valid_idx);
        valid_mp = mp_values(valid_idx);
        
        % Plot curve using logarithmic X-scale
        semilogx(valid_times, valid_mp, '-o', 'LineWidth', 1.5);
        grid on;
        
        title(['Patient ', num2str(pid)]);
        xlabel('Hours since diagnosis');
        ylabel('Mechanical Power (MP)');
        
        % Restore readable x-axis labels
        xticks(time_points);
        xticklabels(time_points_original);
        
        % Normalized area under the curve
        if length(valid_times) > 1
            area_norm = trapz(valid_times, valid_mp) / ...
                        (max(valid_times) - min(valid_times));
            disp(['Patient ', num2str(pid), ...
                  ' - Normalized Area: ', num2str(area_norm)]);
        end
        
    end
end
