% 边界处理
function x = mlimit(x,xmax,xmin)
for i=1:size(x,2)
    if x(i) > xmax
        x(i) = xmax;
    else
        if x(i) < xmin
            x(i) = xmin;
        end
    end
end