%% clean the space
clc;
clear;
close all;
warning('off');
%% Start the diffusion model
load ZDdata.mat
random_x = ZDdata(randperm(size(ZDdata, 1)), :);
data=random_x;

% 构建一个简单的扩散模型
input_dim = size(data, 2); % 输入数据的特征维度

% 定义神经网络模型
layers = [
    imageInputLayer([input_dim 1 1], 'Normalization', 'none', 'Name', 'input')
    fullyConnectedLayer(128, 'Name', 'fc1')
    reluLayer('Name', 'relu1')
    fullyConnectedLayer(64, 'Name', 'fc2')
    reluLayer('Name', 'relu2')
    fullyConnectedLayer(input_dim, 'Name', 'output')];

% 设置优化器
options = trainingOptions('adam', ...
    'MaxEpochs', 100, ...
    'MiniBatchSize', 32, ...
    'InitialLearnRate', 0.001, ...
    'Plots', 'training-progress', ...
    'ExecutionEnvironment', 'auto');

% 自定义训练过程
epochs = 100;  % 训练轮次
learning_rate = 0.001;  % 学习率
num_samples = size(data, 1);  % 样本数量

model = trainNetwork(data,data,layers,options);

% % 训练循环
% for epoch = 1:epochs
%     % 随机打乱数据
%     idx = randperm(num_samples);
%     data = data(idx, :); % 打乱训练数据
%     
%     % 分批训练
%     batch_size = 32;  % 每批次大小
%     for batch_start = 1:batch_size:num_samples
%         batch_end = min(batch_start + batch_size - 1, num_samples);
%         X_batch = data(batch_start:batch_end, :);  % 输入数据
%         Y_batch = X_batch;  % 目标数据
% 
%         % 获取当前层的权重和偏置
%         learnables = layers.Learnables;
%         fc1_weights = learnables(1).Value;
%         fc1_bias = learnables(2).Value;
%         fc2_weights = learnables(3).Value;
%         fc2_bias = learnables(4).Value;
%         output_weights = learnables(5).Value;
%         output_bias = learnables(6).Value;
%         
%         % 前向传播
%         % 手动计算每一层的输出
%         fc1_output = relu(X_batch * layers.fc1.Weight' + layers.fc1.Bias');
%         fc2_output = relu(fc1_output * layers.fc2.Weight' + layers.fc2.Bias');
%         output = fc2_output * layers.output.Weight' + layers.output.Bias';
%         
%         % 计算KL散度损失
%         loss = computeKLDiv(Y_batch, predictions');
%         
%         % 计算梯度并更新网络参数
%         % 使用自动微分来计算梯度并更新权重
%         gradients = dlgradient(loss, layers.Learnables);
%         
%         % 更新网络权重
%         layers = updateWeights(layers, gradients, learning_rate);
%     end
%     
%     % 打印损失值
%     fprintf('Epoch %d, Loss: %.4f\n', epoch, mean(loss));
% end

% 生成数据（使用训练好的模型）
num_samples = size(data,1); % 生成1000个新样本
generated_data = zeros(num_samples, input_dim);
for i = 1:num_samples
    noise = randn(1, input_dim); % 随机噪声
    generated_data(i, :) = predict(model, noise'); % 生成数据
end