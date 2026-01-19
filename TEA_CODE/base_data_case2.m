%%%this is base data for case 2

function [running_hour,running_day,running_year,price_MeOH,price_CO,price_CO2,price_H2O,price_electricity,price_carbon_tax,n_PSA,n_CE,n_WE,n_MSR,n_COMP,n_ST,n_DISTL,n_PUMP,n_FD,n_SEP] = base_data_case2()
    % decision parameters designed by user
    running_hour = 350*24; % h 
    running_day = 350; % day
    running_year = 20; %year

    %%%carbon
    price_carbon_tax = 84;% $/ton

    %%% selling  price---------------------------------------------------------
    price_MeOH = 3.877; % $/kg  Jouny et al 2021
    price_CO = 0.6; % $/kg
    % levelized cost

    %%% Purchasing  price---------------------------------------------------------
    price_CO2 = 0.04;  % $/ton
    price_H2O = 0.0054;  %$/gal
    price_electricity = 0.03; % $/kwh

    n_PSA = 1;
    n_CE = 1;
    n_WE = 1;
    n_MSR = 1; %甲醇反应器
    n_COMP = 4; 
    n_ST = 7;  %shell and tube
    n_DISTL = 1;
    n_PUMP = 1;
    n_FD = 1 ; %flash drum
    n_SEP = 4;
end