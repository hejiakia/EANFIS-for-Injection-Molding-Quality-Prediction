% matlab中没有argmin函数，所以自己对应了一个
% 找到使函数值最小的参数x
function rx = argmin(y,x)
min_index = find(y== min(y));
rx = x(min_index,:);
rx = rx(1,:); % 防止存在y相同的情况
end