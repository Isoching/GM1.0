clc; clear; close all

%FIND THE PARETO OF FE and J

%% Params structure
params.F = 96485;  % C/mol Faraday constant
params.M_CO2 = 44; %[g/mol]
params.rho_CO2_g = 1.83;   %[kg/m^3]
params.M_H2 = 2;  %[g/mol]
params.rho_H2_g = 0.083;  %[kg/m^3]
params.M_CO = 28;  %[g/mol]
params.rho_CO_g = 1.164; %[kg/m^3]
params.M_H2O = 18;  %[g/mol]

params.LHV_CO_kwh_kg = 2.81; % kWh/kg
params.LHV_H2_kwh_kg = 33.33; % kWh/kg
params.LHV_CO_kj_mol = 242; % kJ/mol
params.LHV_H2_kj_mol = 120.9; % kJ/mol

params.z_CE = 2; % electrons
params.z_WE = 2;
params.STP_CO2 = 22.4; % L/mol

% number of opt vars
nvars = 3; % V_CE_o, T_CE_o, Vc_CE_o
lb = [15, 25, 2];   % lower bound
ub = [160, 70, 3.5]; % upper bound

% predefined configuration of eCO2R
Ncellperstack = 10; % parallel channel
Nstack = 289000; % number of stacks
N_CE_o = Ncellperstack * Nstack;
A_CE = 25e-4; % 25 cm2  active area

% === packing the obj params ===
myobj = @(x) multiobj_wrapper(x, N_CE_o, A_CE, params);

% === multi gps optimisation ===
options = optimoptions('gamultiobj', 'PopulationSize', 50, ...
    'Display', 'iter', 'UseParallel', false);
[x_pareto, fval_pareto] = gamultiobj(myobj, nvars, [], [], [], [], lb, ub, [], options);

% === back to the real value===
fval_pareto = -fval_pareto;

% === for pareto front ===
figure('Color','w')
scatter(fval_pareto(:,1), fval_pareto(:,2), 50, 'filled', ...
    'MarkerFaceColor',[0 0.447 0.741],'MarkerEdgeColor','k');
xlabel('FE_{CE}','FontSize',16,'FontWeight','bold');
ylabel('J_{CE}','FontSize',16,'FontWeight','bold');
title('Pareto Front for FE_{CE} and J_{CE}','FontSize',16,'FontWeight','bold');
grid on
set(gca,'FontSize',14,'LineWidth',1.5)
axis tight

% save
% exportgraphics(gcf,'pareto_front.png','Resolution',600);

% === decision var and its obj===
disp(array2table([x_pareto fval_pareto], ...
    'VariableNames', {'V_CE_o','T_CE_o','Vc_CE_o','FE_CE','J_CE'}));

function y = multiobj_wrapper(x, N_CE_o, A_CE, params)
    [~, ~, FE_CE, ~, J_CE, ~, ~, ~, ~] = func_eCO2R(x(1), x(2), x(3), N_CE_o, A_CE, params);
    y = [-FE_CE, -J_CE];
end
