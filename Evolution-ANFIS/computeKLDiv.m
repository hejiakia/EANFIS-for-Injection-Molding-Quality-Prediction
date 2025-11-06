function kl_div = computeKLDiv(true_dist, pred_dist)
    % 计算KL散度：KL(P || Q)
    % true_dist: 真实数据分布 (P)
    % pred_dist: 预测数据分布 (Q)
    
    % 防止log(0)的情况，增加一个小的epsilon值
    epsilon = 1e-8;
    
    % 使用Softmax转换预测值为概率分布
    pred_dist = softmax(pred_dist, 2);  % 2表示按行进行Softmax操作
    
    % 计算KL散度
    kl_div = sum(true_dist .* log(true_dist + epsilon) - true_dist .* log(pred_dist + epsilon), 2);
end