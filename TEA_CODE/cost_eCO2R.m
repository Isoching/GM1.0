%cost_eCO2 including fixed cost and maintaince cost
%%%captial cost for eCO2R electrolyzer
function [Cost_CE, Cost_BoP_CE,Cost_elec_CE, Cost_MM_CE,Cost_water_CE] =  cost_eCO2R(I_CE,Ws_CE,price_elec,running_days,price_H2O)
    a = 250.25;% $/kw From the DOE H2A analysis for central grid electrolysis
    %REF_ECO2_cost = a * J_CE * VC_CE * 1/1000; %$/m2
    %Cost_CE = A_CE_s * REF_ECO2_cost; % $
    Cost_CE = a*Ws_CE;
    %the balance of plant capital cost (F5) is 35% of the total cost, while the stack is 65%:
    Cost_BoP_CE = Cost_CE * 0.35/0.65; %$

    %%% operating cost
    Cost_elec_CE =  Ws_CE * 24 * price_elec /1000; %$/day  0.03$/kwh Power is MW
    price_opMaintance_CE = 0.025;
    Cost_MM_CE = Cost_CE * price_opMaintance_CE/running_days; %$/day
    
    Consume_water = I_CE/4/96480*18/1000*24*3600*0.2642; % gal/day
    Cost_water_CE = Consume_water * price_H2O; % $/day
end