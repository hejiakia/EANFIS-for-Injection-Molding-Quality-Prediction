% 文中rand(V)函数
function x = my_rand(c,p)
for j=1:p
    for i=1:size(c,2)
        ximax = c(i);
        ximin = 0;
        x(j,i) = (ximax-ximin)*rand+ximin;
    end
end
end
    
