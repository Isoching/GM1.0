function [norm_data] = func_normalization(data)
    norm_data = data/max(data);
