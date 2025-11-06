% HGAPSO算法
% 返回值x_gb为全局最佳位置（也就是最优解），h_y为历史函数值，i_count为已经迭代次数
function [h_y,x_gb,i_count] = hgapso(npop,fitness,xmin,xmax,t,dime,p,l,wg,wl,wr,k,pg,pp,f_max,k1,k2)
% start
cmax = ones(1,dime) * xmax;
cmin = ones(1,dime) * xmin;
% x = my_rand(cmax-cmin,p);
% x(1,:)=ones();
x=npop;
x_lb = x;
L = ones(1,p) * l;

%[ry,rx] = fobj(x);
ry=[];
rx=[];
for i=1:p
    candi = x(i,:);
    ry_candi =fitness(candi);
    ry(i)=ry_candi;
    rx(i,:)=candi;
end
x_gb = argmin(ry,rx);

i_count = 0;

% 主循环
while true
    [ry,~] = fitness(x_gb);
    h_y(i_count+1) = ry;    %保存历史函数值
    if (i_count >= t)     %结束
        break;
    end
    % normal iteration
    for i=1:p
        [x,x_lb] = subprocess(fitness, i,xmax,xmin,x,x_lb,x_gb,cmax,cmin,dime,wg,wl,wr,f_max,k1,k2);
    end
    for i=1:size(x_lb,1)
        ry(i)=fitness(x_lb(i,:));
        rx(i,:)=x_lb(i,:);
    end
    %[ry,rx] = fitness(x_lb);
    x_gb = argmin(ry,rx);
    % update classifier
    g = ones(1,dime) * (pg/2);  %文中定义向量G的每个维度值等于2/G
    
    %[ry,~] = test_f(x);
    for i=i:size(x,1)
        ry(i) = fitness(x(i,:));
    end
    [sv,si] = sort(ry);
    % maxd mind
    % 将每个维度的最大值最小值作为新的cmax，cmin
    for i=1:dime    % 遍历每一个维度
        maxd = -1;  % 预定值，一定要比所有函数值都要小（无穷小）
        mind = 100; % 预定值，一定要比所有函数值都要大（无穷大）
        for j=si(1:k)   % 选取最优的k个粒子（函数值最小的k个粒子）
            if maxd < x(j,i)
                maxd = x(j,i);
            end
            if mind > x(j,i)
                mind = x(j,i);
            end
        end
        cmax(i) = maxd;
        cmin(i) = mind;
    end
    cmax = cmax + g;
    cmin = cmin - g;
    
    % reinitialize particles with negative lifespan
    for i=1:p
        L(i) = L(i) - si(i);
        if L(i) >= 0
            continue;
        end
        L(i) = l;
        if rand < pp
            x(i,:) = my_rand(cmax-cmin,1) + cmin;
        else
            x(i,:) = my_rand(ones(1,dime),1);
        end
        wc = log10(i_count+1);  %对应文中的W变量，其定义在文中第7页
        % pre-optmize particles
        while j <= wc
            [x,x_lb] = subprocess(fitness,i,xmax,xmin,x,x_lb,x_gb,cmax,cmin,dime,wg,wl,wr,f_max,k1,k2);
            ry_lb = fitness(x_lb(i,:));
            ry_gb = fitness(x_gb);
            if ry_lb < ry_gb
                x_gb = x_lb(i,:);
            end
            j = j + 1;
        end
        i = i + 1;
    end
    i_count = i_count + 1;

    % show
    % cla;
    % [ry,~] = test_f(x_gb);
    % plot(xx,yy);
    % plot(x_gb,ry,'o','Color','red','MarkerSize',5);
    % pause(0.1);
    % hold on;
    ry_gb=min(ry);
    disp(['In Iteration Number ' num2str(i_count) ': Highest Cost Is = ' num2str(ry_gb)]);
end


