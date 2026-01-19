function [train,test] = func_prepare_dataset(data)

    propotation_train = 0.9; %%训练集比例 0.8 测试集0.2

    a_data=size(data, 1);

    train_a = round(propotation_train*a_data);

    rowranka = randperm(a_data); % size获得a的行数，randperm打乱各行的顺序

    random_data = data(rowranka,:);              % 按照rowrank重新排列各行，注意rowrank的位置
    train = random_data(1:train_a,:);
    test = random_data(train_a+1:end,:);

end