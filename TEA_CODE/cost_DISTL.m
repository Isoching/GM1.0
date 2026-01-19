
function [Cost_DISTL,Cost_op_DISTL] = cost_DISTL(Total_liquid_flow,num_DISTL)
%%% captial cost for distillation column
    DISTL_ref_capacity =1000; %L/min
    DISTL_ref_cost = 4514670; % $ for methanol 
    DISTL_cap_scaling_factor = 0.7;
    DISTL_operating_cost = 11508.05714;%$/day

    Cost_DISTL = num_DISTL * DISTL_ref_cost*(Total_liquid_flow/DISTL_ref_capacity)^DISTL_cap_scaling_factor;
    Cost_op_DISTL = (Total_liquid_flow/DISTL_ref_capacity) * DISTL_operating_cost ;%$/day
end