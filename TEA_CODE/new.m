
V = 20:10:120; % sccm
T = 25:5:75;   % °C
U = 2.5:0.1:3.5; 
UVT_SPCE = zeros(length(U), length(V), length(T));


for i = 1:length(U)
    for j = 1:length(V)
        for k = 1:length(T)
            [n_CO,PI_CO,I_eCO2R,FE_CO,SPCE_eCO2R,J_eCO2R,Ws_eCO2R,H2_FLOW,H2O_FLOW,eff_eCO2R] = func_eCO2R(V_eCO2R_o,T_eCO2R_o,U_eCO2R_o,N_eCO2R);
            UVT_SPCE(i,j,k) = SPCE_eCO2R;
        end
    end
end


[U_grid, V_grid, T_grid] = meshgrid(U, V, T);
UVT_SPCE_vector = UVT_SPCE(:);


figure;
set(gcf, 'Units', 'centimeters', 'Position', [10 5 17.4 10], 'Color', 'w');


sc = scatter3(U_grid(:), V_grid(:), T_grid(:), 50, UVT_SPCE_vector, 'filled');
sc.MarkerEdgeColor = [0.2 0.2 0.2];
sc.MarkerFaceAlpha = 0.7;


ax = gca;
ax.FontName = 'Arial';
ax.FontSize = 10;
ax.FontWeight = 'bold';
ax.LineWidth = 1.0;
ax.TickDir = 'out';
ax.XAxis.MinorTick = 'on';
ax.YAxis.MinorTick = 'on';
ax.ZAxis.MinorTick = 'on';
ax.GridLineStyle = '--';
ax.MinorGridLineStyle = ':';
ax.MinorGridAlpha = 0.3;

xlabel('Voltage (V)', 'FontSize', 10, 'FontWeight', 'bold');
ylabel('Flow Rate (sccm)', 'FontSize', 10, 'FontWeight', 'bold');
zlabel('Temperature (°C)', 'FontSize', 10, 'FontWeight', 'bold');
title('SPCE vs. Voltage, Flow Rate, and Temperature', 'FontSize', 12, 'FontWeight', 'bold');


cb = colorbar;
cb.Label.String = 'SPCE';
cb.Label.FontSize = 10;
cb.Label.FontWeight = 'bold';
colormap(parula);  % 使用 parula 色图


print(gcf, '-dtiff', '-r300', 'Science_Style_Figure.tiff');