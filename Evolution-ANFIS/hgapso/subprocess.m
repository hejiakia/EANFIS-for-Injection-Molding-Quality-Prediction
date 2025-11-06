% 子程序1，本质上是GA算法里的选择、交叉和变异阶段
function [x,x_lb] = subprocess(i,xmax,xmin,x,x_lb,x_gb,cmax,cmin,dime,wg,wl,wr,f_max,k1,k2)
xi_1 = x(i,:) + wg * (x_gb - x(i,:));
xi_2 = xi_1 + wl * (x_lb(i,:) - x(i,:));
% 计算概率
if f_max == -1
    p_xi_3 = 1;
    p_xi_4 = 1;
else
    [ry,~] = test_f(x_gb);
    p_xi_3 = 1/2*tanh(k1*(1/2-ry/f_max)) + 1/2;
    p_xi_4 = 1/2*tanh(k2*(ry/f_max - 1/2)) + 1/2;
end
if rand < p_xi_3
    xi_3 = x(i,:) + wr * (my_rand(cmax-cmin,1) - (cmax-cmin)/2);
else 
    xi_3 = zeros(1,dime);
end
if rand < p_xi_4
    s_x = my_rcs(x,dime);
    [ry,rx] = test_f(s_x);
    xi_4 = argmin(ry,rx);
else
    xi_4 = zeros(1,dime);
end
% 边界处理
xi_1 = mlimit(xi_1,xmax,xmin);
xi_2 = mlimit(xi_2,xmax,xmin);
xi_3 = mlimit(xi_3,xmax,xmin);
xi_4 = mlimit(xi_4,xmax,xmin);

[ry,rx] = test_f([xi_1;xi_2;xi_3;xi_4]);
x(i,:) = argmin(ry,rx);

[ry_xi,~] = test_f(x(i,:));
[ry_xi_lb,~] = test_f(x_lb(i,:));
if ry_xi < ry_xi_lb
    x_lb(i,:) = x(i,:);
end
