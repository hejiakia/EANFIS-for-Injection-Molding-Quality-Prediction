function [vMin,theBestVct,Convergence_curve]=EANFIS_Train(npop,fis,data)

    %% Problem Definition
    disp("EANFIS Start")

%     p0=FISParameters(fis);  
    fobj=@(i,x) FISCost(x,fis,data);    % 弄清楚
    dim=numel(npop(1,:));    
    alpha=1;
    lb=-(10^alpha);
    ub=10^alpha;

    % EANFIS Params
    Params.MaxIt=50;
    Params.nPop=7;

    f_target = 0;   % 目标值
    f_max = -1;    % 目标函数的最大值，对应文中第7页的式子13，通过计算概率决定是否计算Xi3和Xi4，减少计算量
    % 可以将该值设置为-1，代表一定要计算Xi3和Xi4
    k1 = 0.5;   % 用于调整中间斜率
    k2 = 0.5;   % 同上
    xmin = 0;   % x的最小值
    xmax = 20;  % x的最大值
    dime = 1;   % D维
    t = 100;    % 迭代次数

    % 超参数，值来源于文中第8页，table I。
    %p = 1000;   % 粒子数量规模
    %l = 12000;  % 粒子生命周期
    p = size(npop,1);
    l = 120*p;
    wg = 0.024;
    wl = 0.016;
    wr = 0.6;
    %k = 20;
    k=2;
    pg = 0.3;
    pp = 0.7;

    % Run AHA 
    % [vMin,theBestVct,Convergence_curve]=hgapso(Params.nPop,Params.MaxIt,lb,ub,dim,fobj);
    [vMin,theBestVct,Convergence_curve]=EANFIS(npop,fobj,lb,ub,t,dim,p,l,wg,wl,wr,k,pg,pp,f_max,k1,k2);
    
    disp("EANFIS Finished")
end
