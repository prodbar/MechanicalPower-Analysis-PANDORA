%% compute_MP_columns.m
% --------------------------------------------------------------
% Computes Effective Mechanical Power (PME) for all available
% time points using the pediatric formula:
%
% PME = 0.098 * FR * (VT / IBW) * ( PIP - 0.5*(Pplat + PEEP) )
%
% Author: Patricia Rodrigo
% Repository: MechanicalPower-Analysis-PANDORA
% --------------------------------------------------------------

clear; clc;

%% Load dataset
file_name = 'PANDORA_complete_patients.xlsx';
data = readtable(file_name, 'VariableNamingRule', 'preserve');

%% Define time points and column name patterns
timepoints = {'T0', 'T6', 'D0_VTMAX', 'D1_VTMAX', 'D3_VTMAX', 'D7_VTMAX'};

% Column naming template based on your Excel structure
col_VT   = {'T0VTML',      'T6VTML',      'D0VTMAX',      'D1VTMAX',      'D3VTMAX',      'D7VTMAX'};
col_FR   = {'T0FR',        'T6FR',        'D0FRMAX',      'D1FRMAX',      'D3FRMAX',      'D7FRMAX'};
col_PIP  = {'T0PPI',       'T6PPI',       'D0PPIMAX',     'D1PPIMAX',     'D3PPIMAX',     'D7PPIMAX'};
col_PPLAT= {'T0PPLAT',     'T6PPLAT',     'D0PPLATMAX',   'D1PPLATMAX',   'D3PPLATMAX',   'D7PPLATMAX'};
col_PEEP = {'T0PEEP',      'T6PEEP',      'D0PEEPMAX',    'D1PEEPMAX',    'D3PEEPMAX',    'D7PEEPMAX'};

%% IBW (required for normalization)
if ~ismember('PCI', data.Properties.VariableNames)
    error('Column PCI (weight—IBW surrogate) not found in dataset.');
end

IBW = data.PCI;

%% Compute PME for each time point
for i = 1:length(timepoints)

    vt    = data.(col_VT{i});
    fr    = data.(col_FR{i});
    pip   = data.(col_PIP{i});
    pplat = data.(col_PPLAT{i});
    peep  = data.(col_PEEP{i});

    % PME formula
    PME = 0.098 .* fr .* (vt ./ IBW) .* ( pip - 0.5*(pplat + peep) );

    % Store in new column
    new_var_name = ['MP_eff_norm_' timepoints{i}];
    data.(new_var_name) = PME;
end

%% Save updated table
output_file = 'PANDORA_with_PME.xlsx';
writetable(data, output_file);

disp('Effective Mechanical Power columns created successfully.');
disp(['Saved as: ' output_file]);
