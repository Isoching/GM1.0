function ISBL = calc_ISBL(P_act)
% calc_ISBL 
%
% input
%   P_act - N×M matrix（10 equips），M design point
%
% output：
%   ISBL - N×M matrix， ISBL cost（USD）

% FOR 
    % 表格中参考数据（与设备一一对应）
    Cost_ref = [100000; 70000; 65000; 9500; 20000; ...
                1300000; 5180; 235000; 5000; 341];  % USD
    P_ref    = [8000; 100; 100; 1; 20; ...
                100; 3.785; 252; 1; 1];             % Units
    r        = [0.65; 0.71; 1.04; 0.29; 0.75; ...
                0.4; 0.7; 0.67; 1; 1];              % Scaling factors

    % 维度检查
    [n, m] = size(P_act);
    if n ~= length(Cost_ref)
        error('P_act must be a 10×M matrix, each row corresponding to a device type.');
    end

    % 广播兼容性处理
    Cost_mat = repmat(Cost_ref, 1, m);
    P_ref_mat = repmat(P_ref, 1, m);
    r_mat = repmat(r, 1, m);

    % 计算 ISBL
    ISBL = Cost_mat .* (P_act ./ P_ref_mat) .^ r_mat;
end
