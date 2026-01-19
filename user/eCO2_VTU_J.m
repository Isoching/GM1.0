function gp = eCO2_VTU_J(gp) %configuration

%
%   In this example, a maximum run time of 10 seconds is allowed (3 runs).


%run control parameters
gp.runcontrol.pop_size = 1000;	%250	种群规模，即每代中个体（数学模型）的数量。较大的种群能增加多样性，但计算成本更高。	                  				   
gp.runcontrol.timeout = 40;   % 单次GP运行的超时时间s。算法会在达到时间后终止。
gp.runcontrol.runs = 3; %3 独立运行的次数。多次运行可减少随机性影响，提高找到优质解的概率
% 总生成数量 = pop_size * runs

%selection
gp.selection.tournament.size = 40; %25锦标赛选择的竞争池大小。每次从种群中随机选取25个个体，从中选出最优者进入下一代。 
% %较大的值：偏向选择更优个体，可能加速收敛，但降低多样性。
gp.selection.tournament.p_pareto = 0.7;  %在多目标优化中，80%的概率基于帕累托支配关系选择个体（如同时优化模型精度和复杂度），20%基于其他指标（如拥挤距离）。
%作用：平衡解的多样性和收敛性。
gp.selection.elite_fraction = 0.3;%保留每代中70%的精英个体直接进入下一代，剩余30%通过选择、交叉和变异生成。
%注意：该值通常较低（如0.1~0.3），0.7可能过于激进，需确认是否为比例或绝对数量。

gp.nodes.const.p_int= 0.6;  %生成常数节点时，60%概率为整数，40%为浮点数。影响模型中的常数类型，适用于特定问题（如离散数据）。
%调整意义：控制模型常数的多样性。

%fitness 
gp.fitness.terminate = true; %启用适应度终止条件。当适应度达到阈值时，提前终止运行。
gp.fitness.terminate_value = 0.01; % 0.2适应度阈值（如均方误差MSE）。若某次运行的适应度≤0.05，则停止。你的调整：从0.2降低到0.05，要求模型更精确。

%高elite_fraction可能牺牲多样性，需谨慎设置（可能更适合简单问题）


%maximum depth of trees 
gp.treedef.max_depth = 3; 
% . 树的最大深度 (gp.treedef.max_depth)
% 
%     作用：
%     限制生成的表达式树的最大深度（根节点到最深叶节点的层数）。
% 
%         例如：深度为3的树可能对应类似 a + (b * c) 的表达式；深度为5可能生成更复杂的嵌套结构（如 sin(a) + (b * (c - d))）。
% 
%     默认值：
%     通常默认值较低（如4-5），但此处被注释并设为10，意味着允许生成非常深/复杂的树。
% 
%     调整意义：
% 
%         增大：允许更复杂的模型，可能提高拟合能力，但也可能导致过拟合或计算成本激增。
% 
%         减小：限制模型复杂度，提升可解释性，但可能欠拟合。
% 
%     建议：
%     符号回归中，复杂问题（如高阶非线性关系）可能需要较深的树，但需结合交叉验证防止过拟合。
 	              
%maximum depth of sub-trees created by mutation operator
%gp.treedef.max_mutate_depth = 4;
% 2. 变异子树的最大深度 (gp.treedef.max_mutate_depth)
% 
%     作用：
%     限制变异操作中生成的替换子树的最大深度。例如，若原树某节点发生变异，替换的新子树深度不能超过此值。
% 
%     与 max_depth 的区别：
% 
%         max_depth 控制全局树深度，max_mutate_depth 仅限制变异生成的局部子树深度。
% 
%         例如，若原树深度为8，max_mutate_depth=5，则变异时替换的子树最多5层，最终树深度可能仍为8（取决于替换位置）。
% 
%     调整意义：
% 
%         增大：允许更复杂的局部变异，增强搜索多样性。
% 
%         减小：限制变异规模，保持模型简洁性，加速收敛。

%% 
gp.genes.max_genes = 4;
% 3. 最大基因数量 (gp.genes.max_genes)
% 
%     作用：
%     在多基因遗传编程（Multi-Gene Genetic Programming, MGGP）中，每个个体由多个“基因”（即多个树）组成，最终模型为这些树的线性组合（如 y = w1*Tree1 + w2*Tree2 + ... + w10*Tree10）。
% 
%         max_genes=10 表示每个个体最多包含10个基因（即10棵树）。
% 
%     意义：
% 
%         增大：允许更复杂的组合模型，可能捕捉更多非线性关系，但计算成本高且易过拟合。
% 
%         减小：简化模型结构，提升可解释性，适合简单问题。
% 
%     典型值：
%     通常设为3-10，需根据问题复杂度权衡。例如：
% 
%         max_genes=3：适合低维数据或线性主导的问题。
% 
%         max_genes=10：适合高维、强非线性的复杂系统。
%% 
% 参数间的关联与平衡
% 
%     树深度与基因数量：
% 
%         若 max_genes 较大（如10），即使单棵树较浅（如 max_depth=5），组合模型仍可能非常复杂。
% 
%         若同时设置 max_genes=10 和 max_depth=10，模型复杂度会指数级增长，需谨慎使用。
% 
%     与种群规模 (pop_size) 的关系：
% 
%         更大的 pop_size（如500）能容纳更多复杂个体，但需配合较高的计算资源。
% 
%     与适应度终止条件 (gp.fitness.terminate_value) 的关系：
% 
%         若追求高精度（terminate_value=0.05），可能需要更大的 max_depth 或 max_genes，但也需延长 timeout。
% 
% 实际应用建议
% 
%     简单问题：
% 
%         限制 max_depth=5, max_genes=3，避免过拟合。
% 
%     复杂问题：
% 
%         逐步增加 max_depth（如5→8→10）和 max_genes（如3→5→10），观察验证集性能。
% 
%     计算资源有限：
% 
%         优先增大 pop_size 和 runs，而非盲目增加树深度或基因数量。
%% 读取训练和测试数据集 这里的数据来自于 data preprocessing
load data_eCO2R.mat

%% x1 是T x2是J Y 是FE和V

gp.userdata.xtrain = train_VTU_J(:,1:3); 
gp.userdata.ytrain = train_VTU_J(:,4); 
gp.userdata.xtest = test_VTU_J(:,1:3); 
gp.userdata.ytest = test_VTU_J(:,4); 
gp.userdata.name = 'eCO2R_VTU_J';

gp.nodes.functions.name = {'times','minus','plus', 'sqrt','rdivide','square','exp','log','cube','neg','negexp','add3','mult3'};