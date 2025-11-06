% 文中的rcs实现，在x上随机选择一个维度，修改这个维度的值为随机数（0-1）
% 类似于退火算法的随机扰动
function s_x = my_rcs(x,dime)
for i=1:size(x,1)
    xi = x(i,:);
    random_dim = randi(dime);
    xi(random_dim) = rand; % xmax=1 xmin=0
    s_x(i,:) = xi;
end