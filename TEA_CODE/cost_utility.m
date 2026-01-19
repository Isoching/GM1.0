

function [Cost_CO2_buy,Cost_water_utility] = cost_utility(price_CO2,I_eH2O,I_eCO2)
    %%% purchase CO2 for resources
    Cost_CO2_buy = CO2_emission*24/1000 * price_CO2;  % $/day
    
    
    % Water utility cost     price: 0.0054 $per gal
    Consume_water = (I_eH2O + I_eCO2)/4/96480*18/1000*24*3600*0.2642; % gal/day
    Cost_water_utility = Consume_water * price_water; % $/day

end
