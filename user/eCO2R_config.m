function gp = eCO2R_config(gp)
%GPDEMO3_CONFIG Config file demonstrating multigene symbolic regression on data from a simulated pH neutralisation process.
%  
%   This is the configuration file that GPDEMO3 calls.   
%
%   GP = GPDEMO3_CONFIG(GP) generates a parameter structure GP that 
%   specifies the GPTIPS run settings.
%
%   In this example, a maximum run time of 10 seconds is allowed (3 runs).
%
%   Remarks:
%   The data in this example is taken a simulation of a pH neutralisation
%   process with one output (pH), which is a non-linear function of the 
%   four inputs.
%
%   Example:
%   GP = RUNGP(@GPDEMO3_CONFIG) uses this configuration file to perform 
%   symbolic regression with multiple gene individuals on the pH data. The 
%   results and parameters used are stored in fields of the returned GP 
%   structure.
%

%
%   See also REGRESSMULTI_FITFUN, GPDEMO3, GPDEMO2, GPDEMO1, RUNGP

%run control parameters
gp.runcontrol.pop_size = 250;	%250			                  				   
gp.runcontrol.timeout = 10;   % 10
gp.runcontrol.runs = 3; %3

%selection
gp.selection.tournament.size = 25; %25
gp.selection.tournament.p_pareto = 0.7; 
gp.selection.elite_fraction = 0.7;
gp.nodes.const.p_int= 0.5; 

%fitness 
gp.fitness.terminate = true;
gp.fitness.terminate_value = 0.1; %0.2

%quartic example doesn't need constants
%gp.nodes.const.p_ERC = 0;	
%% dataloading
%set up user data 
load XtraineCO2R.mat
load XtesteCO2R.mat
load YtraineCO2R.mat
load YtesteCO2R.mat
%% 
% [VC_eH2OR,FE_eH2OR,nH2,nO2,I_eH2OR,Ws_eH2OR,FH2O_IN,HTO_eH2OR,eff_eH2OR] = eH2OR(T_eH2OR,P_eH2OR,J_eH2OR);

%var=1; % for VC
%var=2; % for FE
%var=3; % for nH2
%var=4; % for nO2
%var=5; % for I
%var=6; % for Ws
%var=7; % for H2Oin
% var=8; % for HTO
%var=9; % for eff
% YYtrain = Ytrain(:,var);
% YYtest = Ytest(:,var);

%% 
gp.userdata.xtest = Xtest; %testing set (inputs)
gp.userdata.ytest = YYtest; %testing set (output)

gp.userdata.xtrain = Xtrain; %training set (inputs)
gp.userdata.ytrain = YYtrain; %training set (output)
%gp.userdata.name = 'eH2OR';

%maximum depth of trees 
gp.treedef.max_depth = 8; 
 	              
%maximum depth of sub-trees created by mutation operator
% gp.treedef.max_mutate_depth = 7;
% %genes
% gp.genes.max_genes = 6;

%define building block function nodes
%gp.nodes.functions.name = {'times','minus','plus','tanh','mult3','add3','abs'};
%gp.nodes.functions.name = {'times','minus','plus','sqrt','square','sin','cos','exp','add3','mult3','negexp','neg','abs'};
gp.nodes.functions.name = {'times','minus','plus', 'sqrt','rdivide','square','exp','log','mult3','add3','cube'};%,'negexp','neg'};