function gp = eH2O_PTJ_FE(gp) %configuration

%
%   In this example, a maximum run time of 10 seconds is allowed (3 runs).


%run control parameters
gp.runcontrol.pop_size = 300;	%250			                  				   
gp.runcontrol.timeout = 20;   % 10
gp.runcontrol.runs = 4; %3

%selection
gp.selection.tournament.size = 20; %25
gp.selection.tournament.p_pareto = 0.7; 

gp.selection.elite_fraction = 0.3;

gp.nodes.const.p_int= 0.6; 

%fitness 
gp.fitness.terminate = true;
gp.fitness.terminate_value = 0.1; %0.2

%maximum depth of trees 
gp.treedef.max_depth = 3; 
 	              
%maximum depth of sub-trees created by mutation operator
%gp.treedef.max_mutate_depth = 3;
% %genes
gp.genes.max_genes = 4;

%% 读取训练和测试数据集 这里的数据来自于 data preprocessing
load data_eH2OR.mat

%% x1 是T x2是J Y 是FE和V

gp.userdata.xtrain = train_PTJ_FE(:,1:3); 
gp.userdata.ytrain = train_PTJ_FE(:,4); 
gp.userdata.xtest = test_PTJ_FE(:,1:3); 
gp.userdata.ytest = test_PTJ_FE(:,4); 
gp.userdata.name = 'eH2OR_PTJ_FE';


%gp.nodes.functions.name = {'times','minus','plus','sqrt','square','sin','cos','exp','add3','mult3','negexp','neg','abs'};
gp.nodes.functions.name = {'times','minus','plus', 'sqrt','rdivide','square','exp','log','cube','add3','mult3'};