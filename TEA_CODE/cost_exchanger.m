
function [Cost_exchanger] = cost_exchanger(num_exchanger)
    %%% Floating head shell and tube size m2 for cooler and heater from Table 7.2 P327
    S_exchanger = 281.363; %m2 range 10-1000
    a_exchanger = 32000;
    b_exchanger = 70;
    n_exchanger = 1.2;
    Cost_exchanger = (a_exchanger + b_exchanger * S_exchanger^n_exchanger) * num_exchanger;
end