
function [Cost_PSA,Cost_op_PSA] = cost_PSA(Total_gas_flow,price_electricity)
    %%% PSA capital cost
    %feed FLOW RATE SHOULD BE m3/h
    
    PSA_ref_capacity = 1000; %m3/h 
    PSA_ref_cost = 1989043; % $ for methanol 
    PSA_cap_scaling_factor = 0.7;
    PSA_operating_cost = 0.25; %kWh/m^3

    Cost_PSA = PSA_ref_cost*(Total_gas_flow/PSA_ref_capacity)^PSA_cap_scaling_factor;
    Cost_op_PSA = 24*price_electricity*Total_gas_flow*PSA_operating_cost;%$/day?????????

end