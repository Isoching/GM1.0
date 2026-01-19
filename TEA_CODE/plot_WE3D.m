
% 3-D relationship between the operating vars and the indicating vars
J = flip(linspace(0.2,0.8,40)); % A/cm2

Jreal =  flip(linspace(200,800,40)); % mA/cm2

T = flip(linspace(50,80,40)); %C
P = linspace(7,12,40); 

PTJ_HTO = zeros(length(P), length(T), length(J));
PTJ_Vc = zeros(length(P), length(T), length(J));
PTJ_FE = zeros(length(P), length(T), length(J));
PTJ_nH2 = zeros(length(P), length(T), length(J));
PTJ_eff = zeros(length(P), length(T), length(J));

N_WE = 12;

% 
for i = 1:length(J)
    J_WE_o = J(i);  
    for j = 1:length(T)
        T_WE_o = T(j);
        for k = 1:length(P)
            P_WE_o = P(k);  

            %

            [Vc_WE,FE_WE,nH2,nO2,I_WE,Ws_WE,FH2O_IN,HTO_WE,CONV_WE,eff_WE] = func_eH2OR(T_WE_o,P_WE_o,J_WE_o,N_WE,A_WE);       
            %JTP
            PTJ_HTO(i, j, k) = HTO_WE;
            PTJ_FE(i, j, k) = FE_WE;
            PTJ_Vc(i,j,k) = Vc_WE;
            PTJ_eff(i,j,k) =eff_WE;
            PTJ_nH2(i,j,k) = nH2;
        end
    end
end


[J_grid, T_grid, P_grid] = meshgrid(Jreal,T,P);
PTJ_HTO_vector = PTJ_HTO(:);
PTJ_FE_vector = PTJ_FE(:);
PTJ_U_vector = PTJ_Vc(:);
PTJ_eff_vector = PTJ_eff(:);
PTJ_nH2_vector = PTJ_nH2(:);

figure(1)  %SPCE
scatter3(J_grid(:), T_grid(:), P_grid(:), 50, PTJ_HTO_vector, 'filled');
%colormap(jet);

colorbar;
colormap(jet);

%colorbar.Label.String = '（%）' ;         

% details
set(gca, 'FontName', 'Arial', 'FontSize', 11, 'FontWeight', 'bold');  
% xlabel('Current density (A/cm^2)', 'FontSize', 10, 'FontWeight', 'bold');          
% ylabel('Temperature (°C)', 'FontSize', 10, 'FontWeight', 'bold');    
% zlabel('Pressure (bar)', 'FontSize', 10, 'FontWeight', 'bold');    
%title('HTO vs. Pressure and Temperature', 'FontSize', 24, 'FontWeight', 'bold'); 

set(gcf, 'Units', 'centimeters', 'Position', [10 5 17.4 10]);  
set(gcf, 'Color', 'w');  
%% 2
% figure(2)  
% scatter3(J_grid(:), T_grid(:), P_grid(:), 50, PTJ_nH2_vector, 'filled')
% colorbar;
% colormap(jet);
% 
% set(gca, 'FontName', 'Arial', 'FontSize', 10, 'FontWeight', 'bold');  %
% 
% xlabel('Current density (A/cm^2)', 'FontSize', 10, 'FontWeight', 'bold');          
% ylabel('Temperature (°C)', 'FontSize', 10, 'FontWeight', 'bold');     % 
% zlabel('Pressure (bar)', 'FontSize', 10, 'FontWeight', 'bold');     % 

%title('nH2 vs.Pressure and Temperature', 'FontSize', 12, 'FontWeight', 'bold'); 

set(gcf, 'Units', 'centimeters', 'Position', [10 5 17.4 10]);  % 
set(gcf, 'Color', 'w');  %

%% 3
figure(3)  %J
scatter3(J_grid(:), T_grid(:), P_grid(:), 50, PTJ_U_vector, 'filled')

colormap(jet);
colorbar;

set(gca, 'FontName', 'Arial', 'FontSize', 11, 'FontWeight', 'bold');  
% xlabel('Current density (A/cm^2)', 'FontSize', 10, 'FontWeight', 'bold');          
% ylabel('Temperature (°C)', 'FontSize', 10, 'FontWeight', 'bold');    
% zlabel('Pressure (bar)', 'FontSize', 10, 'FontWeight', 'bold');     
%title('U vs. Pressure and Temperature', 'FontSize', 12, 'FontWeight', 'bold'); 

set(gcf, 'Units', 'centimeters', 'Position', [10 5 17.4 10]);  
set(gcf, 'Color', 'w');  % 背景设为白色
%% 4
figure(4)  %FE
scatter3(J_grid(:), T_grid(:), P_grid(:), 50, PTJ_FE_vector, 'filled')

colormap(jet);
colorbar;

set(gca, 'FontName', 'Arial', 'FontSize', 11, 'FontWeight', 'bold');  
% xlabel('Current density (A/cm^2)', 'FontSize', 10, 'FontWeight', 'bold');          
% ylabel('Temperature (°C)', 'FontSize', 10, 'FontWeight', 'bold');     
% zlabel('Pressure (bar)', 'FontSize', 10, 'FontWeight', 'bold');    
%title('FE vs. Pressure and Temperature', 'FontSize', 12, 'FontWeight', 'bold'); 


set(gcf, 'Units', 'centimeters', 'Position', [10 5 17.4 10]);  
set(gcf, 'Color', 'w');  

%% 5
figure(5)  %eff
scatter3(J_grid(:), T_grid(:), P_grid(:), 50, PTJ_eff_vector, 'filled')

colormap(jet);
%colormap(spring);3
colorbar;

set(gca, 'FontName', 'Arial', 'FontSize', 11, 'FontWeight', 'bold');  
% xlabel('Current density (A/cm^2)', 'FontSize', 10, 'FontWeight', 'bold');          
% ylabel('Temperature (°C)', 'FontSize', 10, 'FontWeight', 'bold');     
% zlabel('Pressure (bar)', 'FontSize', 10, 'FontWeight', 'bold');     
% title('eff vs. Pressure and Temperature', 'FontSize', 12, 'FontWeight', 'bold'); 

set(gcf, 'Units', 'centimeters', 'Position', [10 5 17.4 10]);  
set(gcf, 'Color', 'w');  % 背景设为白色
%% save
saveas(1, 'HTO_WE', 'png');
% saveas(2, 'nH2_eH2OR', 'png');
saveas(3, 'Vc_WE', 'png');
saveas(4, 'FE_WE', 'png');
saveas(5, 'eff_WE', 'png');