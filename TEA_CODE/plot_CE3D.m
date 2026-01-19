
tic

V = linspace(54,162,40); % sccm
tao = flip(linspace(0.02,0.06,40));

T = linspace(25,65,40); % C
U  = linspace(2.4,3.3,40);

UVT_SPC = zeros(length(U), length(V), length(T));
UVT_J = zeros(length(U), length(V), length(T));
UVT_FE = zeros(length(U), length(V), length(T));
UVT_nCO = zeros(length(U), length(V), length(T));
UVT_eff = zeros(length(U), length(V), length(T));

% V T U to predict FE SPCE J
%FE_CO,SPCE_eCO2R,J_eCO2R eff_eCO2R,
CO2_emission = 27464.9 ; %kg/h

N_CE = 2890000; 

[V_CE_o,tao_CE] = func_carbon_emission(CO2_emission,N_CE);

A_CE = 25e-4; %25cm2
% calculation
for i = 1:length(U)
    U_eCO2R_o = U(i);  
    for j = 1:length(V)
        V_CE_o = V(j);
        %tao_CE_o = tao(j);

        for k = 1:length(T)
            T_eCO2R_o = T(k);  % order k
  
            [n_CO,PI_CO,I_CE,FE_CO,SPC_CE,J_CE,Ws_CE,H2_FLOW,H2O_FLOW,eff_CE] = func_eCO2R(V_CE_o,T_eCO2R_o,U_eCO2R_o,N_CE,A_CE);

            UVT_SPC(i, j, k) = SPC_CE;
            UVT_FE(i, j, k) = FE_CO;
            UVT_J(i,j,k) = J_CE;
            UVT_eff(i,j,k) =eff_CE;
            UVT_nCO(i,j,k) = n_CO;
        end
    end
end

% to plot
%[U_grid, V_grid, T_grid] = meshgrid(U, V, T);
[U_grid, V_grid, T_grid] = meshgrid(U, tao, T);
UVT_SPC_vector = UVT_SPC(:);
UVT_FE_vector = UVT_FE(:);
UVT_J_vector = UVT_J(:);
UVT_eff_vector = UVT_eff(:);
UVT_nCO_vector = UVT_nCO(:);

%% ploting
figure(1)  %SPCE
scatter3(U_grid(:), V_grid(:), T_grid(:), 50, UVT_SPC_vector, 'filled')
colormap(jet);
%colormap(spring);
colorbar;
% details
%set(gca, 'FontName', 'Arial', 'FontSize', 10, 'FontWeight', 'bold');  %font
% xlabel('Voltage (V)', 'FontSize', 10, 'FontWeight', 'bold');          % X
% ylabel('Flow Rate (sccm)', 'FontSize', 10, 'FontWeight', 'bold');     % Y
% zlabel('Temperature (°C)', 'FontSize', 10, 'FontWeight', 'bold');     % Z
%title('SPCE vs. Voltage, Flow Rate, and Temperature', 'FontSize', 12, 'FontWeight', 'bold'); 

set(gca, 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'bold');  % font
set(gcf, 'Units', 'centimeters', 'Position', [10 5 17.4 10]);  % weight 17.4cm，height 10cm
set(gcf, 'Color', 'w');  % 背景设为白色
% %% 2
% figure(2)  %n_CO
% scatter3(U_grid(:), V_grid(:), T_grid(:), 50, UVT_nCO_vector, 'filled')
% 
% colormap(jet);
% colorbar;
% 
% set(gca, 'FontName', 'Arial', 'FontSize', 10, 'FontWeight', 'bold');  % 
% % xlabel('Voltage (V)', 'FontSize', 10, 'FontWeight', 'bold');          % X
% % ylabel('Flow Rate (sccm)', 'FontSize', 10, 'FontWeight', 'bold');     % Y
% % zlabel('Temperature (°C)', 'FontSize', 10, 'FontWeight', 'bold');     % Z
% %title('nCO vs. Voltage, Flow Rate, and Temperature', 'FontSize', 12, 'FontWeight', 'bold'); 
% 
% set(gcf, 'Units', 'centimeters', 'Position', [10 5 17.4 10]);  % width 17.4cm， height 10cm
% set(gcf, 'Color', 'w');  % background white

%% 3
figure(3)  %J
scatter3(U_grid(:), V_grid(:), T_grid(:), 50, UVT_J_vector, 'filled')

colormap(jet);
colorbar;

set(gca, 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'bold'); 
% xlabel('Voltage (V)', 'FontSize', 10, 'FontWeight', 'bold');          
% ylabel('Flow Rate (sccm)', 'FontSize', 10, 'FontWeight', 'bold');     
% zlabel('Temperature (°C)', 'FontSize', 10, 'FontWeight', 'bold');    
%title('J vs. Voltage, Flow Rate, and Temperature', 'FontSize', 12, 'FontWeight', 'bold'); 

set(gcf, 'Units', 'centimeters', 'Position', [10 5 17.4 10]);  % 
set(gcf, 'Color', 'w');  % 
%% 4
figure(4)  %FE
scatter3(U_grid(:), V_grid(:), T_grid(:), 50, UVT_FE_vector, 'filled')

colormap(jet);
colorbar;
set(gca, 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'bold');  %
% xlabel('Voltage (V)', 'FontSize', 10, 'FontWeight', 'bold');          % 
% ylabel('Flow Rate (sccm)', 'FontSize', 10, 'FontWeight', 'bold');     % 
% zlabel('Temperature (°C)', 'FontSize', 10, 'FontWeight', 'bold');     %
%title('FE vs. Voltage, Flow Rate, and Temperature', 'FontSize', 12, 'FontWeight', 'bold'); 

set(gcf, 'Units', 'centimeters', 'Position', [10 5 17.4 10]);  % 17.4cm，10cm
set(gcf, 'Color', 'w');  % 背景设为白色

%% 5
figure(5)  %eff
scatter3(U_grid(:), V_grid(:), T_grid(:), 50, UVT_eff_vector, 'filled')
colormap(jet);
%colormap(spring);3
colorbar;
set(gca, 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'bold');  % 
% xlabel('Voltage (V)', 'FontSize', 10, 'FontWeight', 'bold');          % 
% ylabel('Flow Rate (sccm)', 'FontSize', 10, 'FontWeight', 'bold');     % 
% zlabel('Temperature (°C)', 'FontSize', 10, 'FontWeight', 'bold');     % 
%title('eff vs. Voltage, Flow Rate, and Temperature', 'FontSize', 12, 'FontWeight', 'bold'); 

set(gcf, 'Units', 'centimeters', 'Position', [10 5 17.4 10]);  % 17.4cm，10cm
set(gcf, 'Color', 'w');  % 
%% save
saveas(1, 'SPC_CE', 'png');
% saveas(2, 'nCO_eCO2R', 'png');
saveas(3, 'J_CE', 'png');
saveas(4, 'FE_CE', 'png');
saveas(5, 'EE_CE', 'png');
toc