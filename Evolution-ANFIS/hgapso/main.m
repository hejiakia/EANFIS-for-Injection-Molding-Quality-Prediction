clear;
f_target = 0;   % 目标值
f_max = -1;    % 目标函数的最大值，对应文中第7页的式子13，通过计算概率决定是否计算Xi3和Xi4，减少计算量
                % 可以将该值设置为-1，代表一定要计算Xi3和Xi4
k1 = 0.5;   % 用于调整中间斜率
k2 = 0.5;   % 同上
xmin = 0;   % x的最小值
xmax = 20;  % x的最大值
dime = 1;   % D维
t = 50;    % 迭代次数

% 超参数，值来源于文中第8页，table I。
p = 1000;   % 粒子数量规模
l = 12000;  % 粒子生命周期
wg = 0.024;
wl = 0.016;
wr = 0.6;
k = 20;
pg = 0.3;
pp = 0.7;

[result_x,h_y,i_count] = hgapso(f_target,xmin,xmax,t,dime,p,l,wg,wl,wr,k,pg,pp,f_max,k1,k2);

figure('Name','收敛状态')
i_counts = (1:i_count+1);
plot(i_counts,h_y);
xlabel('迭代次数');
ylabel('目标值');
disp(result_x);