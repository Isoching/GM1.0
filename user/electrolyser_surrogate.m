
%   Demonstrates multigene symbolic regression and some post run analysis
%   functions such as SUMMARY and RUNTREE and the use of the Symbolic Math
%   Toolbox to simplify expressions and create HTML reports using
%   PARETOREPORT, GPMODELREPORT and DRAWTREES to visualise the models.
%
% 符号回归的数学方程 主函数 需要调用eh2o config 参数设定



%% 
addpath('C:\Users\YUANJING\Desktop\YJproject\SReh2o\core')
addpath('C:\Users\YUANJING\Desktop\YJproject\SReh2o\conversion')
addpath('C:\Users\YUANJING\Desktop\YJproject\SReh2o\fitness')
addpath('C:\Users\YUANJING\Desktop\YJproject\SReh2o\nodefcn')
addpath('C:\Users\YUANJING\Desktop\YJproject\SReh2o\rules')
addpath('C:\Users\YUANJING\Desktop\YJproject\SReh2o\user')
%调用 configuration 函数

%config_function = @eH2O_PTJ_V;
%config_function = @eH2O_PTJ_FE;
config_function = @eH2O_PTJ_HTO;

%config_function = @eCO2_VTU_FE;
%config_function = @eCO2_VTU_SPCE;
%config_function = @eCO2_VTU_J;
%% 
gp = rungp(config_function);
%run the best individual of the run on the fitness function
runtree(gp,'best');


% disp('Next, display the population in terms of performance and complexity.');
popbrowser(gp);

%If Symbolic Math toolbox is present
if gp.info.toolbox.symbolic()
   
    %pareto report
    paretoreport(gp);
    
    % display any multigene model at the command line
    gppretty(gp,'best');
end

drawtrees(gp,'best');

%reports
if gp.info.toolbox.symbolic()
   
    gpmodelreport(gp,'best');
end

%% 保存数据
%save('eCO2_VTU_J.mat', 'gp', 'ans');
%save('eH2O_PTJ_V.mat', 'gp', 'ans');
%save('eH2O_PTJ_FE.mat', 'gp', 'ans');
save('eH2O_PTJ_HTO.mat', 'gp', 'ans');