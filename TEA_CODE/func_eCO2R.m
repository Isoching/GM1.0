
%% this function is for surrogate model of CO2 electrolyser in Aspen %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% THIS PART IS FOR VALIDATING THE ECO2 FUNCTION 
% 
% we get the number of cells 
% Params strusture
%     params.F = 96485;  %C/mol Faraday constant
%     params.M_CO2 = 44; %[g/mol]	0.044 kg/mol	Molar weight of CO2(l)
%     params.rho_CO2_g = 1.83;   %[kg/m^3]	1.83 kg/m³	Density of CO2(g)
%     params.M_H2 = 2;  %[g/mol]	0.002 kg/mol	Molar weight for H2
%     params.rho_H2_g = 0.083;  %[kg/m^3]		Density of H2
%     params.M_CO = 28;  %[g/mol]	0.028 kg/mol	Molar weight for CO
%     params.rho_CO_g = 1.164; %[kg/m^3]	1.164 kg/m³	Density of CO
%     params.M_H2O = 18;  %[g/mol]	0.018 kg/mol
% 
%     params.LHV_CO_kwh_kg = 2.81; %kwh/kg
%     params.LHV_H2_kwh_kg = 33.33; %kwh/kg
%     params.LHV_CO_kj_mol = 242; %kJ/mol
%     params.LHV_H2_kj_mol = 120.9; %kJ/mol
% 
%     params.z_CE = 2; % electrons
%     params.z_WE = 2;
%     params.STP_CO2 = 22.4; %STP 0C 1atm 22.4L/mol
% [n_CO,I_CE,FE_CE,SPC_CE,J_CE,Ws_CE,H2_HER,H2O_need,eff_CE] =  func_eCO2R1(params);


function [n_CO,I_CE,FE_CE,SPC_CE,J_CE,Ws_CE,H2_HER,H2O_FLOW,eff_CE] = func_eCO2R(params)

V_CE_o = 80; %sccm %%%%%%%%%%%%%%
T_CE_o = 60; % C    %%%%%%%%%%%%%%
Vc_CE_o = 3.1; %V    %%%%%%%%%%%%%%
%P_CE_o = 1; % bar 3-5

    % predefined configuration of eCO2R
    Ncellperstack = 10; % parallel channel

    Nstack = 24800; % number of stacks

    N_CE_o = Ncellperstack * Nstack;

    A_CE = 3000; %25cm2 *20 active area from jeng and jiao /   300cm2 * 10 from SIEMENS

%% anti normalization
    load('max_data.mat')  % MAX SCALING
    %%%design of eCO2RR
    % operating variables
    V_CE = V_CE_o/max_VTU_V;  %flow rate  sccm
    T_CE = T_CE_o/max_VTU_T;  % temperature C
    Vc_CE = Vc_CE_o/max_VTU_U;  %cell voltage V 
    
   

%% 3 performances by SR model
    FE_CO_middle = (7.13- 0.00478 * Vc_CE^4 / V_CE^2) - 1.47 * (T_CE-Vc_CE)^4 - 3.094*Vc_CE^3 - 8.756*exp(-Vc_CE^2);

    SPC_CE_middle = 4.74 * T_CE + 2.37*exp(-Vc_CE) - 1.09*(V_CE - Vc_CE)^3 - 2.05 * (T_CE-Vc_CE)^3 - 3.12*T_CE/Vc_CE - 1.45;

    J_CE_middle = 6.23 * Vc_CE^3 - 1.99 * T_CE - 10.5 * Vc_CE - 0.0000437 * exp(9.79*Vc_CE) - 1.989 * V_CE + 6.225 * V_CE * T_CE * Vc_CE + 6.16;
   
   
%% 反归一化
    J_CE = J_CE_middle * max_VTU_J ; % input data is in mA/cm2
    SPC_CE = SPC_CE_middle * max_VTU_SPCE ;
    FE_CE = FE_CO_middle * max_VTU_FE ;

    % current for rach cell
    I_CE = J_CE * A_CE/1000; % A

    %IMPORTANT CO production TOTAL
    n_CO = FE_CE * 0.01 * I_CE / params.z_CE / params.F * (3600/1000) * N_CE_o ; % kmol / h

    % total power needed for stack
    Ws_CE = I_CE * Vc_CE_o * N_CE_o/1000;  % power needed with Kw

    %HER for H2 production
    H2_HER = I_CE * (1 - FE_CE*0.01) / params.z_CE /params.F * (3600/1000) * N_CE_o ; % output from eCO2RR  kmol/h

    %H2O needed
    H2O_FLOW =  I_CE /2 / params.z_CE / params.F * (3600/1000) * N_CE_o ;  % output from eCO2RR kmol/h

    eff_CE = n_CO *  params.LHV_CO_kwh_kg * params.M_CO  / Ws_CE *100 ;  %

end
