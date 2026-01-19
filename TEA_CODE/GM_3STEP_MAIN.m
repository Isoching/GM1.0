clc
clear
tic
%%% Comparative Assessment of Green Methanol Synthesis Systems using CO2 electroreduction based on Surrogate Models
%%% Y.ZHAO  this file is for 3 step
%%% 20240919

%%%this is for green methanol 3-step main function

%code for calling aspen engine
Aspen = actxserver('Apwn.Document.40.0');
[stat,mess] = fileattrib; %get attributes of folder
Simulation_Name = 'eco2';

Aspen.invoke('InitFromArchive2','C:\Users\YUANJING\Desktop\3step\threestep.apw');

Aspen.Visible =0;  %not showing aspen 
Aspen.SuppressDialogs = 1; % Suppress windows dialogs.

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

%% global variable statement
global A_WE_stack
    
A_WE_stack = 1000;    % cm2
    

%% PSA predefined
purity_CO2 = 0.965;
eff_CC = 0.934;
PSA_CO2_recover = purity_CO2*eff_CC;


i_CO2_in = 0.2; % mass PERCENTAGE
i_O2_in= 0.05 ;
i_H2O_in = 0.17;
i_N2_in = 0.58 ;
i_H2S_in= 0 ;

%% base data input--------------------------------------------------------
[running_time,running_days,running_years,price_MeOH,price_CO,price_CO2,price_H2O,price_elec,price_carbon_tax,num_MSR,num_compressor,num_ST,num_DISTL] = base_data_case2();

% eCO2R size defined by the flow rate of the industry
FG = 137324.5 ; %kg/h total flue gas 
xCO2 = i_CO2_in;



% get the flow rate and the residence time of CO2 before into the eCO2R
[V_CE_o,tao_CE] = func_carbon_emission(FG,N_CE_o,xCO2,params);


%% 甲醇反应器参数
l_RPLUG = 12.2; %m
d_RPLUG = 0.0375; %m
tube_RPLUG = 8000;

% 反应釜温度分布
% Temp_MSR_0 = 150;
% Temp_MSR_1 = 280;
% Temp_MSR_2 = 267;
% 反应釜压力
P_MSR = 78 ;

%% 赋值 总PSA进料量 kmol/h
%Aspen.Application.Tree.FindNode('\Data\Streams\CO2FEED\Input\FLOW\MIXED\CO2').Value = CO2_emission; %注意有些赋值不可读取和改写问题
Aspen.Application.Tree.FindNode("\Data\Streams\FG\Input\FLOW\MIXED\CO2").Value = i_CO2_in;
Aspen.Application.Tree.FindNode("\Data\Streams\FG\Input\FLOW\MIXED\O2").Value = i_O2_in;
Aspen.Application.Tree.FindNode("\Data\Streams\FG\Input\FLOW\MIXED\H2O").Value = i_H2O_in;
Aspen.Application.Tree.FindNode("\Data\Streams\FG\Input\FLOW\MIXED\N2").Value = i_N2_in;
Aspen.Application.Tree.FindNode("\Data\Streams\FG\Input\FLOW\MIXED\H2S").Value = i_H2S_in;

%% 赋值PSA 碳捕集效率 
Aspen.Application.Tree.FindNode("\Data\Blocks\PSA\Input\FRACS\TOST2\MIXED\CO2").Value = PSA_CO2_recover;
%控制CO2电解槽进料温度加热至
Aspen.Application.Tree.FindNode("\Data\Blocks\ST2\Input\TEMP").Value = T_CE_o;
Aspen.Application.Tree.FindNode("\Data\Blocks\ST2\Input\PRES").Value = P_CE_o;

%根据代理模型设置反应器温度和压力
Aspen.Application.Tree.FindNode("\Data\Blocks\CE\Input\TEMP").Value = T_CE_o;
Aspen.Application.Tree.FindNode("\Data\Blocks\CE\Input\PRES").Value = P_CE_o;


%% eCO2R 调用函数 代理模型------------------------------------------------------------------------------------
[n_CO,I_CE,FE_CE,SPC_CE,J_CE,Ws_CE,H2_FLOW,H2O_FLOW,eff_CE] = func_eCO2R(V_CE_o,T_CE_o,Vc_CE_o,N_CE_o,A_CE,params);

% assign the conversion of CO2 electrolyser
Aspen.Application.Tree.FindNode("\Data\Blocks\CE\Input\CONV\1").Value = SPC_CE*0.01; 

% 计算CO 产量


% 计算 HER的H2 产量 



%% Param of methanol reactor 
% Aspen.Application.Tree.FindNode("\Data\Blocks\MSR\Input\SPEC_TEMP\#0").Value = Temp_MSR_0;
% Aspen.Application.Tree.FindNode("\Data\Blocks\MSR\Input\SPEC_TEMP\#1").Value = Temp_MSR_1;
% Aspen.Application.Tree.FindNode("\Data\Blocks\MSR\Input\SPEC_TEMP\#2").Value = Temp_MSR_2;

% assign lconfiguration of methanol reactor
Aspen.Application.Tree.FindNode("\Data\Blocks\MSR\Input\LENGTH").Value = l_RPLUG;
Aspen.Application.Tree.FindNode("\Data\Blocks\MSR\Input\DIAM").Value = d_RPLUG;
Aspen.Application.Tree.FindNode("\Data\Blocks\MSR\Input\NTUBE").Value = tube_RPLUG;

% assign methanol reactor pressure
Aspen.Application.Tree.FindNode("\Data\Blocks\MSR\Input\PRES").Value = P_MSR;

% 进料温度 和压力 Heater 2
Aspen.Application.Tree.FindNode("\Data\Blocks\ST6\Input\TEMP").Value = Temp_MSR_1;
Aspen.Application.Tree.FindNode("\Data\Blocks\ST6\Input\PRES").Value = P_MSR;
% 进料压力 PUMP1 PUMP2
Aspen.Application.Tree.FindNode("\Data\Blocks\CP4\Input\PRES").Value = P_MSR;
Aspen.Application.Tree.FindNode("\Data\Blocks\CP3\Input\PRES").Value = P_MSR;

%% 精馏设备参数设定
RR_DISTL = -1.3;
PBOT_DISTL = 45 ;
PTOP_DISTL = 45 ;
Aspen.Application.Tree.FindNode("\Data\Blocks\DISTL\Input\RR").Value = RR_DISTL; %回流比
Aspen.Application.Tree.FindNode("\Data\Blocks\DISTL\Input\PBOT").Value = PBOT_DISTL; %冷凝器压力
Aspen.Application.Tree.FindNode("\Data\Blocks\DISTL\Input\PTOP").Value = PTOP_DISTL; %再沸器压力

%%%%%%%%%%%%%%%%%%%%%%%%%call for aspen%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Aspen.Reinit;                                                             %
pause(2);  % wait for aspen calling                                       %             
Run2(Aspen.Engine); % swtich if error is doesn't support dot index        %
%Aspen.Engine.Run2(1);                                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% outlet flow rate after CO2 electrolyser
RCO2 = Aspen.Application.Tree.FindNode("\Data\Streams\CACE\Output\MOLEFLOW\MIXED\CO2").Value ; %kmol/h
RCO = Aspen.Application.Tree.FindNode("\Data\Streams\CACE\Output\MOLEFLOW\MIXED\CO").Value ;  %kmol/h
RH2 = Aspen.Application.Tree.FindNode("\Data\Streams\CACE\Output\MOLEFLOW\MIXED\H2").Value ;  %kmol/h

new_conv = RCO/FG/xCO2/params.M_CO2 ; %kg/h total flue gas 

% ideal H2 production by the water electrolyser
nH2_real = 1.87*(RCO2+RCO)+RCO2-RH2 ; % %kmol/h

[Vc_WE,FE_WE,nH2,nO2,I_WE,Ws_WE,FH2O_IN,HTO_WE,SPC_WE,eff_WE] = func_eH2OR(T_WE_o,P_WE_o,J_WE_o,N_c_WE,A_WE,params);

% adjust the POWER IN of the WE to do the CO2 hydrogenation
%% Params setting of WE
% assign bump paressure
Aspen.Application.Tree.FindNode("\Data\Blocks\P1\Input\PRES").Value = P_WE_o;
% assign the T P of S&T heat exchanger
Aspen.Application.Tree.FindNode("\Data\Blocks\ST3\Input\TEMP").Value = T_WE_o;
Aspen.Application.Tree.FindNode("\Data\Blocks\ST3\Input\PRES").Value = P_WE_o;
%assign the conversion of WE
Aspen.Application.Tree.FindNode("\Data\Blocks\WE\Input\CONV\1").Value = SPC_WE*0.01; 
%assign the T and P of inlet flow 
Aspen.Application.Tree.FindNode("\Data\Blocks\WE\Input\TEMP").Value = T_WE_o;
Aspen.Application.Tree.FindNode("\Data\Blocks\WE\Input\PRES").Value = P_WE_o;

% IMPORTANT！！！reassign the water inlet of WE according to the S
Aspen.Application.Tree.FindNode("\Data\Streams\WIN\Input\TOTFLOW\MIXED").Value = FH2O_IN; % kmol/h

%% then run the aspen simulation again, to get the final results, and do the TEA
%Run 2nd time to get MeOH product %%%%%%%%
Aspen.Reinit;                            %                              
pause(2);  % wait for aspen calling      %
Run2(Aspen.Engine);                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Economic
%Analysis============================================================================================================================
%read comp kw for opex
power_CP1=Application.Tree.FindNode("\Data\Blocks\CP1\Output\POWER_ISEN").Value; %kW
power_CP2=Application.Tree.FindNode("\Data\Blocks\CP2\Output\POWER_ISEN").Value; %kW
power_CP3=Application.Tree.FindNode("\Data\Blocks\CP3\Output\POWER_ISEN").Value; %kW
power_CP4=Application.Tree.FindNode("\Data\Blocks\CP4\Output\POWER_ISEN").Value; %kW
power_CP5=Application.Tree.FindNode("\Data\Blocks\CP5\Output\POWER_ISEN").Value; %kW

weight_DISTL = 10000 ;  % kg

area_ST1=1;
area_ST2=1;
area_ST3=1;

% CO2 tax 40$ per ton
%% in TEA first we have to consider the CAPEX 
% including 
CO2_produce_dropout = Aspen.Application.Tree.FindNode("\Data\Streams\PG2\Output\MOLEFLOW\MIXED\CO2").Value; %kmol/h
CO2_produce_DISTLTOP = Aspen.Application.Tree.FindNode("\Data\Streams\DISTLTOP\Output\MOLEFLOW\MIXED\CO2").Value; %kmol/h
CO2_produce_DISTLBOT = Aspen.Application.Tree.FindNode("\Data\Streams\DISTLBOT\Output\MOLEFLOW\MIXED\CO2").Value; %kmol/h

CO_produce_dropout = Aspen.Application.Tree.FindNode("\Data\Streams\PG2\Output\MASSFLOW\MIXED\CO").Value; %kmol/h
CO_produce_DISTLTOP = Aspen.Application.Tree.FindNode("\Data\Streams\DISTLTOP\Output\MASSFLOW\MIXED\CO").Value; %kmol/h
CO_produce_DISTLBOT = Aspen.Application.Tree.FindNode("\Data\Streams\DISTLBOT\Output\MASSFLOW\MIXED\CO").Value; %kmol/h

MeOH_Prod = Aspen.Application.Tree.FindNode("\Data\Streams\DISTLTOP\Output\MASSFLOW\MIXED\CH3OH").Value; % kmol/h
MeOH_bot = Aspen.Application.Tree.FindNode("\Data\Streams\DISTLBOT\Output\MASSFLOW\MIXED\CH3OH").Value; % kmol/h

%% CAPEX eCO2R
[Cost_CE, Cost_BoP_CE,Cost_elec_CE, Cost_MM_CE,Cost_water_CE] =  cost_eCO2R(I_CE,Ws_CE,price_elec,running_days,price_H2O);
%% CAPEX eH2OR
[Cost_WE, Cost_BoP_WE,Cost_elec_WE,Cost_MM_WE,Cost_water_WE] =  cost_eH2OR(I_WE,Ws_WE,price_elec,running_days,price_H2O);
%% CAPEX RPLUG
[Cost_Jacketed_RPLUG] = cost_RPLUG(num_MSR);

%% CAPEX Compressor
[Cost_compressor,S_comp] = cost_compressor(num_compressor);

%%%CAPEX exchanger
[Cost_exchanger] = cost_exchanger(num_ST);

%%%CAPEX DISTL
Total_liquid_flow = Aspen.Application.Tree.FindNode("\Data\Streams\TODI\Output\VOLFLMX\MIXED").Value ; % l/min
[Cost_DISTL,Cost_op_DISTL] = cost_DISTL(Total_liquid_flow,num_DISTL);

%暂时用不到的
% gas flow from the cathode
MFlow_gasproduct = 0;
Mout_CE_CO2 = Aspen.Application.Tree.FindNode("\Data\Streams\CACE\Output\MASSFLOW\MIXED\CO2").Value; % 
Mout_CE_CO = Aspen.Application.Tree.FindNode("\Data\Streams\CACE\Output\MASSFLOW\MIXED\CO").Value; % kg/h
Mout_CE_H2 = Aspen.Application.Tree.FindNode("\Data\Streams\CACE\Output\MASSFLOW\MIXED\H2").Value; % kg/h

Mout_WE_H2 = Aspen.Application.Tree.FindNode("\Data\Streams\CAWE\Output\MASSFLOW\MIXED\H2").Value; % kg/h

Total_gas_flow = Mout_CE_CO2 + Mout_CE_CO + Mout_CE_H2 ;

%% flue gas flow rate
Total_FG_flowrate = i_CO2_in+i_O2_in+i_H2O_in+i_N2_in + i_H2S_in;
%%%CAPEX PSA
[Cost_PSA,Cost_op_PSA] = cost_PSA(Total_FG_flowrate,price_elec);

%%%carbon tax cost
CO2_produce = CO2_produce_dropout + CO2_produce_DISTLTOP + CO2_produce_DISTLBOT ; %kg/h

CO_produce = CO_produce_dropout + CO_produce_DISTLTOP + CO_produce_DISTLBOT ; % kg/h
%The current carbon price under the UK Emissions Trading Scheme (UK ETS) for 2024 is approximately £64.90 per tonne of CO2​ (GOV.UK)​​
Cost_CO2_tax = CO2_produce * running_time * price_carbon_tax / 1000; % $/day

%%% purchase CO2 for resources 二氧化碳电解槽花费
%Cost_CO2_buy = CO2_emission*24 * price_CO2/1000;  % $/day 二氧化碳购入
Cost_H2O_buy = FH2O_IN * 4.76 * price_H2O;  %from kmol to galon  1kmol = 4.76 galon 水购入
Cost_raw_materia_total = Cost_H2O_buy;

%%% utility cost-------------------------------------------
Cost_water_utility = Cost_water_CE + Cost_water_WE;
Cost_elec_utility = Cost_elec_CE + Cost_elec_WE;
Cost_utility_total = Cost_water_utility + Cost_elec_utility ;
Cost_carbontax_total = Cost_CO2_tax ;
Cost_opMaintance = Cost_MM_WE + Cost_MM_WE + Cost_op_DISTL + Cost_op_PSA;



%%% Operating cost
OPEX =  running_days * (Cost_utility_total + Cost_opMaintance + Cost_raw_materia_total + Cost_CO2_tax);   % cost per year

%%% total capital cost
CAPEX = Cost_PSA + Cost_DISTL + Cost_BoP_WE + Cost_CE + Cost_WE + Cost_BoP_WE + Cost_exchanger + Cost_compressor;


%%% Profit-----------------------------------------------------------------
Sell_CO = CO_produce * price_CO * 24; % $/day
Sell_MeOH = MeOH_Prod * price_MeOH * 24; % $/day

%%% skip 
Profit_products = running_days * (Sell_CO + Sell_MeOH) ;% $/day

%%% yearly profit
Profit_year = Profit_products - OPEX ; % $/year


Payback_time = CAPEX/Profit_year ;

%%% 
i=0.1; % fractional interest rate per year

n=running_years; %running years

Cost_Annualized_capital = CAPEX * i*(1+i)^n/((1+i)^n-1);

Cost_Insurance = 0.01 * CAPEX; % from Grazia Cost analysis 3
Cost_local_taxes = 0.02 * CAPEX;
Cost_Royalties = 0.01 * CAPEX;


%%% Energy %%%
elec_consumption = (Ws_WE + Ws_CE + S_comp*num_compressor)* running_time; %kWh/year
carbon_Emission = (CO2_produce + CO_produce) * running_time ; %kg/year
carbon_Zero = (CO2_produce + CO_produce - FG * xCO2) * running_time ; %kg/year
MeOH_yield_year = MeOH_Prod * running_time ; % kg/ year 

%%%Levelised
%%% LCOM levelised cost of methanol                                         
LCOM = (OPEX+CAPEX/running_years) / MeOH_yield_year; %year cost($)/year MeOH yield (kg)

%%% LCOE levelised cost of electricity 
LCOE = elec_consumption / MeOH_yield_year ; % total elec consume per year(kwh)/ MeOH (kg)

%%% LACC levelised amount of CO2 consumed kg CO2/kg MeOH
LACC = FG/MeOH_Prod;  %feed CO2 (kg/h) / MeOH prod (kg/h)

%%% L  levelised amount of CO2 produced kg CO2/kg MeOH
LACP = CO2_produce/MeOH_Prod;  % CO2 produced from system(kg/h)/ MeOH prod(kg/h)


%Closing Aspen
Aspen.Close();
Aspen.Quit;

toc

disp(['show the input parameters of electrolysers']);
disp(['The input flow rate, T and V of CE are:',  num2str(V_CE_o), ' sccm', ' ', num2str(T_CE_o),' C',' ', num2str(Vc_CE_o), ' V']);
disp(['The input P, T and J of WE are:',  num2str(P_WE_o),' bar',' ', num2str(T_WE_o),' C',' ', num2str(J_WE_o),' A/cm2']);

disp([' ']);
disp(['output the 6 metrics of electrolysers']);
disp(['The single pass conversion of CE: ', num2str(SPC_CE), ' %']);
disp(['The Farafay Efficiency of CE: ', num2str(FE_CE), ' %']);
disp(['The current density of CE: ', num2str(J_CE), ' mA/cm2']);
disp(['The energy efficiency of CE: ', num2str(eff_CE), ' %']);

disp(['The single pass conversion of WE: ', num2str(SPC_WE), ' %']);
disp(['The Farafay Efficiency of WE: ', num2str(FE_WE), ' %']);
disp(['The current density of WE: ', num2str(Vc_WE), ' V']);
disp(['The energy efficiency of WE: ', num2str(eff_WE), ' %']);

disp(['The conversion of CO2 is ',num2str(new_conv), ' %']);
%%% output
disp(['Running time is: ',num2str(toc)]);
