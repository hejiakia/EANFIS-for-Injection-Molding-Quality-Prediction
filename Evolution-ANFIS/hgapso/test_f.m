% 目标函数
% 该函数设计需要对输入的参数矩阵的每一行做运算
% 特别注意的是，需要返回自变量值也就是x，用于argmin函数
function [res,rx] = test_f(x)
for i = 1:size(x,1)
    xi = x(i,:);
    rx(i,:) = xi;
    %res(i) = -( xi(1)^2 - xi(2)^2 + 10 * cos(2*pi*xi(1)) + 10 * cos(2*pi*xi(2)) + 100 );
    % 一维测试
    res(i) = -(xi(1) - 10)^2 + xi(1)*sin(xi(1))*cos(2*xi(1))-5*xi(1)*sin(3*xi(1));
end
end