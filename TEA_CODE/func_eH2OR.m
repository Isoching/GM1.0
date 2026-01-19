
%% this function is for surrogate model of CO2 electrolyser in Aspen %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% THIS PART IS FOR VALIDATING THE ECO2 FUNCTION 
% 
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
% 
% 
% [Vc_WE,FE_WE,nH2,nO2,I_WE,Ws_WE,FH2O_IN,HTO_WE,SPC_WE,eff_WE] = func_eH2OR1(params);

%% function of eH2OR
 function [Vc_WE,FE_WE,nH2,nO2,I_WE,Ws_WE,FH2O_IN,HTO_WE,SPC_WE,eff_WE] = func_eH2OR(params)

 %% 参数设定eH2OR
N_s_WE = 18200; %12 cells in stack determined BY INLET co2
N_cps_WE = 12; %cell per stack

N_c_WE = N_s_WE*N_cps_WE;   %根据氢气需求决定氢气产能

A_WE = 1000; %m2 1000cm2 总面积
%初始的电解水参数设定 后期优化
T_WE_o = 75;%C
P_WE_o = 7; % bar
J_WE_o = 0.4; %A/cm2 

    load('max_data.mat')
    % 输入的scaling
    % x1
    T_WE = T_WE_o/max_PTJ_T;
    % x2
    P_WE = P_WE_o/max_PTJ_P;
    % x3
    J_WE = J_WE_o/max_PTJ_J;  % current density is in A /cm2 in dataset

    I_WE = A_WE * J_WE_o; % cm2 * A/cm2 = A 

    % HTO Gas purity (diffusion of hydrogen in oxygen)
    %HTO_eH2OR = p_C1 + p_C2*T_eH2OR_o + p_C3 * T_eH2OR_o.^2 + (p_C4 + p_C5*T_eH2OR_o + p_C6 * T_eH2OR_o.^2) .* exp((p_C7+p_C8*T_eH2OR_o+p_C9*T_eH2OR_o.^2)./J_eH2OR_o)...
    %          + p_E1 + p_E2*P_eH2OR + p_E3 * P_eH2OR.^2 + (p_E4 + p_E5*P_eH2OR + p_E6 * P_eH2OR.^2) .* exp((p_E7+p_E8*P_eH2OR+p_E9*P_eH2OR.^2)./J_eH2OR_o) ;
    HTO_WE_middle = 0.497*T_WE + 0.0731*(J_WE^4 - P_WE) - 0.17*log(J_WE^2) - 0.129*T_WE/P_WE + 0.154;


    %% cell voltage
    %VR_eH2OR = E0-(R*(T_eH2OR+T0))./(z_eH2O*F).*log(P_eH2OR/P0) ;
    %VC_eH2OR = VR_eH2OR + ((p_r1+p_d1)+p_r2.*T_eH2OR+p_d2.*P_eH2OR) .* J_eH2OR + p_s .* log((p_t1 + p_t2./T_eH2OR + p_t3./T_eH2OR./T_eH2OR) .* J_eH2OR + 1) ;
    Vc_WE_middle = 0.112*J_WE - 0.101*T_WE - 0.255*T_WE/(T_WE+J_WE) + 1.07;


    %% Faraday efficiency
    %FE_eH2OR = (J_eH2OR.^2 ./ (p_f11+p_f12.*T_eH2OR+J_eH2OR.^2)) .* (p_f21 + p_f22.*T_eH2OR); 
    %FE_eH2OR_middle = 0.0103 * log(2*T_eH2OR.^2 .* J_eH2OR.^3) - 0.329 * J_eH2OR - 0.107 * J_eH2OR .* log(T_eH2OR) + 0.627 * J_eH2OR .^ (1/2) + 0.667;
    FE_WE_middle = 0.0188 * T_WE - 0.547*P_WE - 0.46*J_WE + 0.0869 * J_WE/T_WE + 0.779 * J_WE^(0.5) + 1.09;


    % anti scaling
    FE_WE = FE_WE_middle * max_PTJ_FE;
    Vc_WE = Vc_WE_middle * max_PTJ_V;  % this voltage is for single cell
    HTO_WE = HTO_WE_middle * max_PTJ_HTO;

    %H2 实际产率跟电流 和 法拉第效率相关 阴极出 需要考虑到扩散到阳极的损失
    nH2 = (FE_WE*0.01 * (I_WE /params.z_WE / params.F)*3600/1000)*(1-HTO_WE*0.01) * N_c_WE ; % 1C = 1A s   mol/s to kmol/h
    % 反算出需要的电流 和 电流密度
    %I_eH2OR = nH2_ideal/N_eH2OR/(1-HTO_eH2OR)/FE_eH2OR*1000*F*z_eH2O/3600 ;

    % ideal H2 production = actual production / purity / selectivity
    nH2_ideal = ((I_WE /params.z_WE / params.F)*3600/1000) * N_c_WE; %kmol/h

    nH2_an = (FE_WE*0.01 * (I_WE /params.z_WE / params.F)*3600/1000)*HTO_WE*0.01 * N_c_WE; %kmol/h
    
    %% ideal oxygen production from anode side
    nO2 = 0.5*nH2_ideal ;

    % water consumption = hydrogen from anode + hydrogen from cathode
    nH2O = nH2 + nH2_an ; %kmol/h

    %ideally H+ in water all into H2
    FH2O_IN = nH2_ideal; 
    
    %转化率计算：水消耗量/水进料量 
    SPC_WE = nH2O / FH2O_IN;

    Ws_WE = Vc_WE * I_WE * N_s_WE / 1000; % power of stack of eH2O  KW
    
    eff_WE = nH2 * params.LHV_H2_kwh_kg * params.M_H2 / Ws_WE * 100;      %  kmol/h * kJ/mol / w    1kwh = 3600kJ
% 241920 kj/kmol
 end

 % First calculate the required amount of hydrogen based on the ratio, 
% then calculate the required water feed under the set temperature and pressure conditions

%%parameters
%%%Parameter for polarization
%     p_r1 = 4.45153e-5; % ou m2
%     p_r2 = 6.88874e-9; 
%     p_d1 = -3.12996e-6;
%     p_d2 = 4.47137e-7;
%     p_s = 0.33824; %V
%     p_t1 = -0.01539;
%     p_t2 = 2.00181;
%     p_t3 = 15.24178;
%     
%     %%%Parameter for FE analysis
%     p_f11 = 478645.74;
%     p_f12 = -2953.15;
%     p_f21 = 1.03960 ;
%     p_f22 = -0.00104 ;
%     
    %%%Parameter for HTO analysis gas purity
%     p_C1 = 0.09901 ;
%     p_C2 = -0.00207 ;
%     p_C3 = 1.31064e-5 ;
%     p_C4 = -0.08483 ;
%     p_C5 = 0.00179 ;
%     p_C6 = -1.1339e-5 ;
%     p_C7 = 1481.45 ;
%     p_C8 = -23.60345 ; 
%     p_C9 = -0.25774 ; 
%     p_E1 = 3.71417 ;
%     p_E2 = -0.93063 ; 
%     p_E3 = 0.05817 ;
%     p_E4 = -3.72068 ;
%     p_E5 = 0.93219 ;
%     p_E6 = -0.05826 ;
%     p_E7 = -18.38215 ; 
%     p_E8 = 5.87316 ;
%     p_E9 = -0.46425 ;

    %%% for Vr calculation
%     T0=273.15;  %K
%     E0=1.229; % standard 
%     P0=0.1197;
%     R = 8.134;  %J/(mol·K) Ideal gas constant

%%% polarization curve (monica )
    %%% The polarization curve analyzes the different overpotentials that occur during the electrolysis of water in order
    %%% to determine the cell potential (Vcell) according to the current density
    %%% Vrev is the minimum voltage 1.23V at standard condition (1 bar and 25 °C)
    %VR_eH2OR = 1.23; %V
