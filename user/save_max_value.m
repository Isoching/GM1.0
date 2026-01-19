%%读取并储存 训练集最大值
data_eCO2R_VTU_SPCE = readtable('C:\Users\YUANJING\Desktop\YJproject\SReh2o\data\data_eCO2R.xlsx', 'Sheet', 'VTU_SPCE');
data_eCO2R_VTU_FE = readtable('C:\Users\YUANJING\Desktop\YJproject\SReh2o\data\data_eCO2R.xlsx', 'Sheet', 'VTU_FE');
data_eCO2R_VTU_J = readtable('C:\Users\YUANJING\Desktop\YJproject\SReh2o\data\data_eCO2R.xlsx', 'Sheet', 'VTU_J');

data_eH2OR_PTJ_HTO = readtable('C:\Users\YUANJING\Desktop\YJproject\SReh2o\data\data_eH2OR.xlsx', 'Sheet', 'PTJ_HTO');
data_eH2OR_PTJ_FE = readtable('C:\Users\YUANJING\Desktop\YJproject\SReh2o\data\data_eH2OR.xlsx', 'Sheet', 'PTJ_FE');
data_eH2OR_PTJ_V = readtable('C:\Users\YUANJING\Desktop\YJproject\SReh2o\data\data_eH2OR.xlsx', 'Sheet', 'PTJ_V');

norm_VTU_SPCE = data_eCO2R_VTU_SPCE.Variables;
norm_VTU_FE = data_eCO2R_VTU_FE.Variables;  
norm_VTU_J = data_eCO2R_VTU_J.Variables;  %mA/cm2

norm_PTJ_FE = data_eH2OR_PTJ_FE.Variables;
norm_PTJ_V = data_eH2OR_PTJ_V.Variables;
norm_PTJ_HTO = data_eH2OR_PTJ_HTO.Variables;


max_VTU_V = max(norm_VTU_SPCE(:,1));
max_VTU_T = max(norm_VTU_SPCE(:,2));
max_VTU_U = max(norm_VTU_SPCE(:,3));
max_VTU_SPCE = max(norm_VTU_SPCE(:,4));
max_VTU_FE = max(norm_VTU_FE(:,4));
max_VTU_J = max(norm_VTU_J(:,4));

max_PTJ_P = max(norm_PTJ_FE(:,1));
max_PTJ_T = max(norm_PTJ_FE(:,2));
max_PTJ_J = max(norm_PTJ_FE(:,3));

max_PTJ_FE = max(norm_PTJ_FE(:,4));
max_PTJ_V = max(norm_PTJ_V(:,4));
max_PTJ_HTO = max(norm_PTJ_HTO(:,4));

save('max_data.mat','max_VTU_V','max_VTU_T','max_VTU_U','max_VTU_SPCE','max_VTU_FE','max_VTU_J','max_PTJ_P','max_PTJ_T','max_PTJ_J','max_PTJ_FE','max_PTJ_V','max_PTJ_HTO');