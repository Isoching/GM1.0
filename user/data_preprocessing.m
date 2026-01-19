% data preprocessing
% clear all
% clc
% 这份文档是为了SR模型准备训练数据 包括数据的读取 scaling 
%% 读取Excel文件（假设文件名为 data.xlsx，工作表为 Sheet1）
% data_eCO2R_VTU_SPCE = readtable('C:\Users\YUANJING\Desktop\YJproject\SReh2o\data\data_eCO2R.xlsx', 'Sheet', 'VTU_SPCE');
% data_eCO2R_VTU_FE = readtable('C:\Users\YUANJING\Desktop\YJproject\SReh2o\data\data_eCO2R.xlsx', 'Sheet', 'VTU_FE');
% data_eCO2R_VTU_J = readtable('C:\Users\YUANJING\Desktop\YJproject\SReh2o\data\data_eCO2R.xlsx', 'Sheet', 'VTU_J');

data_eH2OR_PTJ_HTO = readtable('C:\Users\YUANJING\Desktop\YJproject\SReh2o\data\data_eH2OR.xlsx', 'Sheet', 'PTJ_HTO');
data_eH2OR_PTJ_FE = readtable('C:\Users\YUANJING\Desktop\YJproject\SReh2o\data\data_eH2OR.xlsx', 'Sheet', 'PTJ_FE');
data_eH2OR_PTJ_V = readtable('C:\Users\YUANJING\Desktop\YJproject\SReh2o\data\data_eH2OR.xlsx', 'Sheet', 'PTJ_V');

%% 
% norm_VTU_SPCE = data_eCO2R_VTU_SPCE.Variables;
% norm_VTU_FE = data_eCO2R_VTU_FE.Variables;  
% norm_VTU_J = data_eCO2R_VTU_J.Variables;  %mA/cm2
norm_PTJ_FE = data_eH2OR_PTJ_FE.Variables;
norm_PTJ_V = data_eH2OR_PTJ_V.Variables;
norm_PTJ_HTO = data_eH2OR_PTJ_HTO.Variables;


%% 归一化 x/smax
for i=1:4
%     norm_VTU_SPCE(1:end,i) = func_normalization(norm_VTU_SPCE(1:end,i));
%     norm_VTU_FE(1:end,i) = func_normalization(norm_VTU_FE(1:end,i));
%     norm_VTU_J(1:end,i) = func_normalization(norm_VTU_J(1:end,i));
    norm_PTJ_FE(1:end,i) = func_normalization(norm_PTJ_FE(1:end,i));
    norm_PTJ_V(1:end,i) = func_normalization(norm_PTJ_V(1:end,i));
    norm_PTJ_HTO(1:end,i) = func_normalization(norm_PTJ_HTO(1:end,i));
end

%% 准备数据集 调用函数

% [train_VTU_SPCE,test_VTU_SPCE] = func_prepare_dataset(norm_VTU_SPCE);
% [train_VTU_FE,test_VTU_FE] = func_prepare_dataset(norm_VTU_FE);
% [train_VTU_J,test_VTU_J] = func_prepare_dataset(norm_VTU_J);
[train_PTJ_HTO,test_PTJ_HTO] = func_prepare_dataset(norm_PTJ_HTO);
[train_PTJ_FE,test_PTJ_FE] = func_prepare_dataset(norm_PTJ_FE);
[train_PTJ_V,test_PTJ_V] = func_prepare_dataset(norm_PTJ_V);

%% 保存为.mat文件
%save('data_eCO2R.mat', 'train_VTU_SPCE','test_VTU_SPCE','train_VTU_FE','test_VTU_FE','train_VTU_J','test_VTU_J');

save('data_eH2OR.mat','train_PTJ_HTO','test_PTJ_HTO','train_PTJ_FE','test_PTJ_FE','train_PTJ_V','test_PTJ_V');


%% 加载.mat文件测试
% load('data_eCO2R.mat');

