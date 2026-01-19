function gp = assignadf(gp)
%ASSIGNADF Create ADF function handles in the caller workspace
%此代码通过 assignin 和 str2func 实现了动态函数注入，使遗传编程中预定义的ADF能在调用者环境中直接使用，简化了函数调用逻辑，适用于需要动态生成函数的复杂算法（如符号回归、遗传编程）。
% Get both function names and the corresponding evaluation symbols
funNames = gp.nodes.adf.name;     % ADF名称列表（单元格数组）
funSymbols = gp.nodes.adf.eval;   % 对应的函数表达式（字符串单元格数组）

% Assign in caller's workspace
for k=1:length(funNames)
   assignin('caller', funNames{k}, str2func(funSymbols{k})); 
end

end

