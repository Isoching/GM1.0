%% this function is dealing with the carbon emission transform to sccm
%% from kmol/h or from kg/h
function [V_CE_o,tao_CE] = func_carbon_emission(FG,N_CE_o,xCO2,params)

% carbon emission from Teeside is 123,771.97  kg/h
    % Serpentine flow channel design
    X_CE = 0.001; %channel cross section length m
    Y_CE = 0.001; %channel cross section height m
    L_CE = 0.054; %channel length  0.0054 m
 

    
%begin of calculator of eCO2RR-------------------------------------------------------------------------------------------------
%to calculate CO product from CO2IN
    Fc_CE = FG * xCO2 / N_CE_o / params.M_CO2 ; %CO2 kg/h  to kmol/h  

    VOL_percell = X_CE * Y_CE * L_CE; % m3

    tao_CE = VOL_percell * 1e3 * 3600/ (Fc_CE * params.STP_CO2 * 1000) ; %s
    
    V_CE_o = Fc_CE * params.STP_CO2 * 1000 * 1000/60; %ml/min

end
