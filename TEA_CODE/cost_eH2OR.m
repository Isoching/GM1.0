%cost_eH2OR
function [Cost_WE, Cost_BoP_WE,Cost_elec_WE,Cost_MM_WE,Cost_water_WE] =  cost_eH2OR(I_WE,Ws_WE,price_elec,running_days,price_H2O)
%%captial cost for eH2O electrolyzer
%% according to the Ws power needed
    a = 250.25;% $/kw From the DOE H2A analysis for central grid electrolysis

    Cost_WE = a * Ws_WE;

    %the balance of plant capital cost (F5) is 35% of the total cost, while the stack is 65%:
    Cost_BoP_WE = Cost_WE * 0.35/0.65; %$

    %operating cost
    Cost_elec_WE = Ws_WE * 24 * 0.001 * price_elec ; %$/day

    price_MM_WE = 0.025;   % price for manage and maintance
    Cost_MM_WE = Cost_WE * price_MM_WE/running_days; %$/day

    Consume_water = I_WE/4/96480*18/1000*24*3600*0.2642; % gal/day

    Cost_water_WE = Consume_water * price_H2O; % $/day
end
