clc 
clear all
%% this file is used for Respond Surface for 2 operating variables once a time
%% pre defined bound
%VTU

%V = linspace(70,160,100); % sccm
V = linspace(54,162,100); % sccm
tao = flip(linspace(0.02,0.05,100)); %residence time tao 
T = linspace(25,65,100); % C
Vc  = linspace(2.4,3.2,100);

CO2_emission = 27464.9 ; %kg/h
 
%interms of carbon emission ,calculating the residence time 
N_CE_o = 2890000; % number of cells by the emission 
A_CE = 25e-4; %25cm
[V_CE_o,tao_CE] = func_carbon_emission(CO2_emission,N_CE_o);


%% sensitive analysis for current density
for i = 1:length(Vc)

        Vc_CE_o = Vc(i);  
        V_CE_o = 80;   % velocity std
        T_CE_o = 25;   % temp std

        [n_CO,PI_CO,I_CE,FE_CO,SPC_CE,J_CE,Ws_CE,H2_FLOW,H2O_FLOW,eff_CE] = func_eCO2R(V_CE_o,T_CE_o,Vc_CE_o,N_CE_o,A_CE);

        s_FE_CE(i) = FE_CO;

        s_J_CE(i) = J_CE*100; 

        s_SPCE_CE(i) = SPC_CE ; 

        s_nCO_CE(i) = n_CO ; %CO yield

        s_eff_CE(i) = eff_CE; % %
end

for ip = 1:length(Vc)

    Vc_CE_o = Vc(ip); 

    for j = 1:length(V)

        V_CE_o = V(j);

        [n_CO,PI_CO,I_CE,FE_CO,SPC_CE,J_CE,Ws_CE,H2_FLOW,H2O_FLOW,eff_CE] = func_eCO2R(V_CE_o,T_CE_o,Vc_CE_o,N_CE_o,A_CE);

        sV_FE_CE(ip,j) = FE_CO;

        sV_J_CE(ip,j) = J_CE*100; % gas purity  %

        sV_SPC_CE(ip,j) = SPC_CE ; 

        sV_nCO_CE(ip,j) = n_CO ; %CO yield

        sV_eff_CE(ip,j) = eff_CE; % %

    end
end


for ipp = 1:length(Vc)

    Vc_CE_o = Vc(ipp); 

    for k = 1:length(T)

        T_CE_o = T(k);

        [n_CO,PI_CO,I_CE,FE_CO,SPC_CE,J_CE,Ws_CE,H2_FLOW,H2O_FLOW,eff_CE] = func_eCO2R(V_CE_o,T_CE_o,Vc_CE_o,N_CE_o,A_CE);

        sT_FE_CE(ipp,k) = FE_CO;

        sT_J_CE(ipp,k) = J_CE*100; 

        sT_SPCE_CE(ipp,k) = SPC_CE ; 

        sT_nCO_CE(ipp,k) = n_CO ; %CO 

        sT_eff_CE(ipp,k) = eff_CE; % %

    end

end
% %% plot
% figure(1)
% subplot(2,2,1)
% plot(Vc,s_J_CE,'red');
% %xlabel('Cell voltage (V)');
% %ylabel('Current density (mA/cm^2)');
% %title('Polarization curve')
% 
% subplot(2,2,2)
% plot(Vc,s_FE_CE,'magenta');
% %xlabel('Cell voltage (V)');
% %ylabel('FE (%)');
% %title('Faraday efficiency')
% 
% subplot(2,2,3)
% plot(Vc,s_SPCE_CE,'black');
% %xlabel('Cell voltage (V)');
% %ylabel('SPCE (%)');
% %title('Single pass conversion efficiency')
% 
% subplot(2,2,4)
% plot(Vc,s_eff_CE,'blue');
% %xlabel('Cell voltage (V)');
% %ylabel('Energy efficiency (%)');

%%  
figure(2)
s=mesh(tao,Vc,sV_FE_CE,'FaceAlpha','0.7');
% xlabel('Flow rate (sccm)');
% ylabel('Cell voltage (V)')
% zlabel('FE (%)')
s.FaceColor = 'flat';
colormap(cool);      % 青-品红渐变
colorbar

figure(3)
s=mesh(tao,Vc,sV_J_CE,'FaceAlpha','0.7');
% xlabel('Flow rate (sccm)');
% ylabel('Cell voltage (V)');
% zlabel('Current density (mA/cm^2)')
s.FaceColor = 'flat';
colormap(hot);
colorbar

figure(4)
s=mesh(tao,Vc,sV_SPC_CE,'FaceAlpha','0.7');
% xlabel('Flow rate (sccm)');
% ylabel('Cell voltage (V)');
% zlabel('SPCE (%)')
s.FaceColor = 'flat';
colorbar

figure(5)
s=mesh(tao,Vc,sV_nCO_CE,'FaceAlpha','0.7');
% xlabel('Flow rate (sccm)');
% ylabel('Cell voltage (V)');
% zlabel('CO production (kmol/h)')
s.FaceColor = 'flat';
colormap(spring);
colorbar
 
figure(6)
s=mesh(tao,Vc,sV_eff_CE,'FaceAlpha','0.7');
% xlabel('Flow rate (sccm)');
% ylabel('Cell voltage (V)');
% zlabel('Energy efficiency (%)');
s.FaceColor = 'flat';
colormap(jet);
colorbar

%%  
figure(7)
s=mesh(T,Vc,sT_FE_CE,'FaceAlpha','0.7');
% xlabel('Temperature (C)');
% ylabel('Cell voltage (V)');
% zlabel('FE (%)');
s.FaceColor = 'flat';
colormap(cool);
colorbar

figure(8)
s=mesh(T,Vc,sT_J_CE,'FaceAlpha','0.7');
% xlabel('Temperature (C)');
% ylabel('Cell voltage (V)');
% zlabel('Current density (mA/cm^2)');
s.FaceColor = 'flat';
colormap(hot);      % 青-品红渐变
colorbar

figure(9)
s=mesh(T,Vc,sT_SPCE_CE,'FaceAlpha','0.7');
% xlabel('Temperature (C)');
% ylabel('Cell voltage (V)');
% zlabel('SPCE (%)');
s.FaceColor = 'flat';
colorbar


figure(10)
s=mesh(T,Vc,sT_nCO_CE,'FaceAlpha','0.7');
% xlabel('Temperature (C)');
% ylabel('Cell voltage (V)');
% zlabel('CO production (kmol/h)');
s.FaceColor = 'flat';
colormap(spring);
colorbar
 
figure(11)
s=mesh(T,Vc,sT_eff_CE,'FaceAlpha','0.7');
% xlabel('Temperature (C)');
% ylabel('Cell voltage (V)');
% zlabel('Energy efficiency (%)');
s.FaceColor = 'flat';
colormap(jet);
colorbar


%saveas(1, 'eCO2R results at 1 bar 25C', 'svg');

saveas(2, 'sV_FE_eCO2R', 'svg');
saveas(3, 'sV_J_eCO2R', 'svg');
saveas(4, 'sV_SPCE_eCO2R', 'svg');
saveas(5, 'sV_nCO_eCO2R', 'svg');
saveas(6, 'sV_eff_eCO2R', 'svg');

saveas(7, 'sT_FE_eCO2R', 'svg');
saveas(8, 'sT_J_eCO2R', 'svg');
saveas(9, 'sT_SPCE_eCO2R', 'svg');
saveas(10, 'sT_nCO_eCO2R', 'svg');
saveas(11, 'sT_eff_eCO2R', 'svg');