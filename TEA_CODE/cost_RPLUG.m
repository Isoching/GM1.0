%%captial cost for PFR reactor from 'Chemical Engineering Design P325-328'
%1pound = 0.4536 kg
%766490*0.4536 % from aspen economic analysis
% RPLUG design data is from Aspen

function [Cost_RPLUG] = cost_RPLUG(num_RPLUG)
    % RPLUG design data is from Aspen
    d_RPLUG = 0.0375; %m
    n_channel_RPLUG = 8000 ; % 5000 channels
    length_RPLUG = 12.2;%m
    V_RPLUG = pi*(d_RPLUG/2)^2 * length_RPLUG * n_channel_RPLUG;
    S_RPLUG = V_RPLUG;
    
    a_RPLUG = 61500;
    b_RPLUG = 32500;
    n_RPLUG = 0.8;
    
    Cost_RPLUG = num_RPLUG * (a_RPLUG + b_RPLUG * S_RPLUG^n_RPLUG);
end