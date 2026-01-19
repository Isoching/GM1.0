%clc; clear; close all

%% this code is to find the best operating variables for CE to maximise the CO production
%% Params strusture
    params.F = 96485;  %C/mol Faraday constant
    params.M_CO2 = 44; %[g/mol]	0.044 kg/mol	Molar weight of CO2(l)
    params.rho_CO2_g = 1.83;   %[kg/m^3]	1.83 kg/m³	Density of CO2(g)
    params.M_H2 = 2;  %[g/mol]	0.002 kg/mol	Molar weight for H2
    params.rho_H2_g = 0.083;  %[kg/m^3]		Density of H2
    params.M_CO = 28;  %[g/mol]	0.028 kg/mol	Molar weight for CO
    params.rho_CO_g = 1.164; %[kg/m^3]	1.164 kg/m³	Density of CO
    params.M_H2O = 18;  %[g/mol]	0.018 kg/mol

    params.LHV_CO_kwh_kg = 2.81; %kwh/kg
    params.LHV_H2_kwh_kg = 33.33; %kwh/kg
    params.LHV_CO_kj_mol = 242; %kJ/mol
    params.LHV_H2_kj_mol = 120.9; %kJ/mol

    params.z_CE = 2; % electrons
    params.z_WE = 2;
    params.STP_CO2 = 22.4; %STP 0C 1atm 22.4L/mol

%% decision vars boundary
nvars = 3;              % [V_CE_o, T_CE_o, Vc_CE_o]
lb = [15, 25, 2];
ub = [160, 70, 3.5];

%% electrolyser configuration param
Ncellperstack = 10;
Nstack = 289000;
N_CE_o = Ncellperstack * Nstack;
A_CE = 25e-4;           % 25 cm2

%% obj：max FE_CE * J_CE
% ga is minimisation and hence should be a negative in the front
singleobj = @(x) - singleobj_wrapper(x, N_CE_o, A_CE, params);

options = optimoptions('ga', 'Display', 'iter', 'PopulationSize', 50);

% ==== optimisation ====
[x_opt, fval, exitflag, output] = ga(singleobj, nvars, [], [], [], [], lb, ub, [], options);

% ==== trun back to the max value  ====
obj_max = -fval;

% ==== output the optimal point ====
disp(['Best V_{CE,o} = ', num2str(x_opt(1)), ...
      ', T_{CE,o} = ', num2str(x_opt(2)), ...
      ', Vc_{CE,o} = ', num2str(x_opt(3))]);
disp(['Max CO production = FE_{CE} × J_{CE} (CO production) = ', num2str(obj_max), ' kmol/h']);

[~, ~, FE_CE, ~, J_CE, ~, ~, ~, ~] = func_eCO2R(x_opt(1), x_opt(2), x_opt(3), N_CE_o, A_CE, params);
disp(['Best operatings FE_{CE} = ', num2str(FE_CE), ' %',', J_{CE} = ', num2str(J_CE), 'mA/cm2']);

FG = 137324.5 ; %kg/h total flue gas 
xCO2 = 0.2;
% the conversion of CO2 electrolyser defined by the CO products/CO2 inlet
conversion_CE = obj_max / (FG * xCO2 / params.M_CO2) ;
disp(['Conversion_CE = ', num2str(conversion_CE),' %']);


%% ====== for obj function package（can be an independent file） ======
function obj = singleobj_wrapper(x, N_CE_o, A_CE, params)
    
    [~, ~, FE_CE, SPC_CE, J_CE, ~, ~, ~, ~] = func_eCO2R(x(1), x(2), x(3), N_CE_o, A_CE, params);
    obj = SPC_CE;
    %FE_CE * J_CE * A_CE / params.z_CE / params.F * (3600/1000) * N_CE_o /1000; % kmol / h
     
end
