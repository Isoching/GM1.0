
function [Cost_compressor,S_comp] = cost_compressor(num_compressor)
    %%% Centrifugal compressor size from 75 to 30000 kw
    S_comp = 3196.86; %kw from aspen 
    a_comp = 580000;
    b_comp = 20000;
    n_comp = 0.6;
    Cost_compressor = (a_comp + b_comp * S_comp^n_comp) * num_compressor;
end