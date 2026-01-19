clc 
clear all
%% this file is used for Respond Surface for 2 operating variables once a time
%% pre defined bound
% inlet water 0.65  KOH 0.35  mole flow 900 kmol/h
% Capacity of hydrogen production  2.5 m3 h-1
% maximum operating pressure      30 bar
% electrolyte concentration       30-40% KOH 
% voltage range                    0-120V
% electrical current range         0-500 A
% maximum power                     15000 W

% J = 0:0.01:0.6; % A/cm2
% T = 40:1:100; %C
% P = 1:0.5:15; %bar
J = linspace(0.2,0.8,100); % A/cm2
T = linspace(50,80,100); %C
P = linspace(7,12,100); 

T_eH2OR_o = 75; 
P_eH2OR_o = 7; %

N_eH2OR = 12;
AREA_stack = 1000;    % cm2


%% sensitive analysis for current density
for i = 1:length(J)
        J_eH2OR_o = J(i);    
        [VC_eH2OR,FE_eH2OR,nH2,nO2,I_eH2OR,Ws_eH2OR,FH2O_IN,HTO_eH2OR,CONV_eH2OR,eff_eH2OR] = func_eH2OR(T_eH2OR_o,P_eH2OR_o,J_eH2OR_o,N_eH2OR,AREA_stack);       
        s_U_eH2OR(i) = VC_eH2OR;
        s_FE_eH2OR(i) = FE_eH2OR;
        s_HTO_eH2OR(i) = HTO_eH2OR; % gas purity  %
        s_nH2_eH2OR(i) = nH2 ; 
        s_eff_eH2OR(i) = eff_eH2OR; % %
end

% plot
figure(1)
subplot(2,2,1)
plot(J,s_U_eH2OR,'red');
xlabel('Current density (A/cm^2)');
ylabel('Cell voltage (V)');
title('Polarization curve')

subplot(2,2,2)
plot(J,s_FE_eH2OR,'magenta');
xlabel('Current density (A/cm^2)');
ylabel('FE (%)');
title('Faraday efficiency')

subplot(2,2,3)
plot(J,s_nH2_eH2OR,'black');
xlabel('Current density (A/cm^2)');
ylabel('H_2 yield (kmol/h)');
title('Hydrogen production')

subplot(2,2,4)
plot(J,s_HTO_eH2OR,'blue');
xlabel('Current density (A/cm^2)');
ylabel('HTO (%)');
title('Diffusion of hydrogen to oxygen')

%plot(x, y1, 'r:', x, y2, 'g-.', x, y3, 'b--');
%saveas(gcf,'name.png')
%% sensitive analysis for different J T

for k = 1:length(T)
    
    T_eH2OR_o = T(k);

    for ij = 1:length(J)
        J_eH2OR_o = J(ij);    
        [Cost_WE, Cost_BoP_WE,Cost_elec_WE,Cost_MM_WE,Cost_water_WE] =  cost_eH2OR(I_WE,Ws_WE,price_elec,running_days,price_H2O);

        sT_U_eH2OR(k,ij) = U_eH2OR; %#ok<*SAGROW> 
        
        sT_FE_eH2OR(k,ij) = FE_eH2OR; % faraday efficiency
        
        sT_HTO_eH2OR(k,ij) = HTO_eH2OR; % gas purity 
        sT_nH2_eH2OR(k,ij) = nH2 ; 
        sT_eff_eH2OR(k,ij) = eff_eH2OR;
    end
end
%% sensitive analysis for different J P
for lp = 1:length(P)
    P_eH2OR = P(lp);
    for ip = 1:length(J)
        J_eH2OR_o = J(ip);    
        [U_eH2OR,FE_eH2OR,nH2,nO2,I_eH2OR,Ws_eH2OR,FH2O_IN,HTO_eH2OR,CONV_eH2OR,eff_eH2OR] = func_eH2OR(T_eH2OR_o,P_eH2OR_o,J_eH2OR_o,N_eH2OR,AREA_stack);
        sP_U_eH2OR(lp,ip) = U_eH2OR; %#ok<*SAGROW> 

        sP_FE_eH2OR(lp,ip) = FE_eH2OR; % faraday efficiency

        sP_HTO_eH2OR(lp,ip) = HTO_eH2OR ; 
        sP_nH2_eH2OR(lp,ip) = nH2 ; 
        sP_eff_eH2OR(lp,ip) = eff_eH2OR;
    end
end

%% plot
figure(2)
s=mesh(J,T,sT_U_eH2OR,'FaceAlpha','0.7');
xlabel('Current density (A/cm^2)');
ylabel('Temperature (C)')
zlabel('Cell voltage (V)')
s.FaceColor = 'flat'; %interp
%colormap(jet);       % 
%colormap(parula);    % 
colormap(hot);      % 
% colormap(spring);    % 
colorbar




figure(3)
s=mesh(J,P,sP_U_eH2OR,'FaceAlpha','0.7');
xlabel('Current density (A/m^2)');
ylabel('Pressure (bar)')
zlabel('Cell voltage (V)')
s.FaceColor = 'flat';
colormap(hot);      % 青-品红渐变
colorbar



figure(4)
s=mesh(J,T,sT_FE_eH2OR,'FaceAlpha','0.7');
xlabel('Current density (A/cm^2)');
ylabel('Temperature (C)')
zlabel('Faraday efficiency (%)')
s.FaceColor = 'flat';
colormap(cool)  % 紫-黄渐变
colorbar

figure(5)
s=mesh(J,P,sP_FE_eH2OR,'FaceAlpha','0.7');
xlabel('Current density (A/cm^2)');
ylabel('Pressure (bar)')
zlabel('Faraday efficiency (%)')
s.FaceColor = 'flat';
colormap(cool)  % 紫-黄渐变
colorbar

figure(6)
s=mesh(J,T,sT_HTO_eH2OR,'FaceAlpha','0.7');
xlabel('Current density (A/cm^2)');
ylabel('Temperature (C)')
zlabel('Diffusion of hydrogen to oxygen HTO (%)')
s.FaceColor = 'flat';
colorbar

figure(7)
%[x1,y]=meshgrid(J,T);
s=mesh(J,P,sP_HTO_eH2OR,'FaceAlpha','0.7');
xlabel('Current density (A/m^2)');
ylabel('Pressure (bar)')
zlabel('Diffusion of hydrogen to oxygen HTO (%)')
s.FaceColor = 'flat';
colorbar

figure(8)
s=mesh(J,T,sT_nH2_eH2OR,'FaceAlpha','0.7');
xlabel('Current density (A/cm^2)');
ylabel('Temperature (C)')
zlabel('Hydrogen production (kmol/h)')
s.FaceColor = 'flat';
colormap(spring);
colorbar

figure(9)
s=mesh(J,P,sP_nH2_eH2OR,'FaceAlpha','0.7');
xlabel('Current density (A/cm^2)');
ylabel('Pressure (bar)')
zlabel('Hydrogen production (kmol/h)')
s.FaceColor = 'flat';
colormap(spring);
colorbar

figure(10)
s=mesh(J,T,sT_eff_eH2OR,'FaceAlpha','0.7');
xlabel('Current density (A/cm^2)');
ylabel('Temperature (C)')
zlabel('Energy efficiency (%)')
s.FaceColor = 'flat';
colormap(jet)
colorbar

figure(11)
s=mesh(J,P,sP_eff_eH2OR,'FaceAlpha','0.7');
xlabel('Current density (A/cm^2)');
ylabel('Pressure (bar)')
zlabel('Energy efficiency (%)')
s.FaceColor = 'flat';
colormap(jet)
colorbar

%% save plot
saveas(1, 'eH_2O results at 75 C and 7 bar', 'png');

saveas(2, 'sT_U_eH2OR', 'png');
saveas(3, 'sP_U_eH2OR', 'png');

saveas(4, 'sT_FE_eH2OR', 'png');
saveas(5, 'sP_FE_eH2OR', 'png');

saveas(6, 'sT_HTO_eH2OR', 'png');
saveas(7, 'sP_HTO_eH2OR', 'png');

saveas(8, 'sT_nH2_eH2OR', 'png');
saveas(9, 'sT_nH2_eH2OR', 'png');

saveas(10, 'sT_eff_eH2OR', 'png');
saveas(11, 'sP_eff_eH2OR', 'png');