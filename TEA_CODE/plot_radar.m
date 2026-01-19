% Example 3: Set fill option on. The fill transparency can be adjusted.
clc;
clear;
% Initialize data points
% 6 metrics
D1 = [ ];
D2 = [ ];
D3 = [ ];

P = [D1; D2; D3];

% Delete variable in workspace if exists
if exist('s', 'var')
    delete(s);
end

% Spider plot
s = spider_plot_class(P);
s.LegendLabels = {'Conventional', '2-step', '3-step'};
% Spider plot properties
s.AxesLabels = {'LCOM', 'LACC', 'LAEC', 'System Efficiency','Conversion', 'MeOH yield'};
s.AxesInterval = 2;
s.FillOption = {'on', 'on', 'on'};
s.FillTransparency = [0.1, 0.1, 0.1];