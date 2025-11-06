% HGAPSO算法
% 返回值x_gb为全局最佳位置（也就是最优解），h_y为历史函数值，i_count为已经迭代次数
function [EANFIS_best_score,EANFIS_best_pos,Convergence_curve] = EANFIS(npop,fobj,lb,ub,Max_iter,dim,p,l,wg,wl,wr,k,pg,pp,f_max,k1,k2)
%% 边界定义
cmax = ones(1,dim) * ub;
cmin = ones(1,dim) * lb;

%% 初始化每个种群为ANFIS，赋予寿命L
x=npop;
L = ones(1,p) * l;
Convergence_curve=zeros(1,Max_iter);
Temp_best_fitness=zeros(1,Max_iter);
fitness=zeros(1,p);
EANFIS_best_pos=zeros(1,dim);
EANFIS_best_score=inf;

%% Initialize parameters
t=0;m=0.8;a=0.97;b=0.001;t1=20;t2=20;

%% 主循环
while t<Max_iter
    N1=floor((m+(1-m)*(t/Max_iter)^2)*p);

    for i=1:size(x,1)
        % boundary checking
        Flag4ub=x(i,:)>cmax;
        Flag4lb=x(i,:)<cmin;
        x(i,:)=(x(i,:).*(~(Flag4ub+Flag4lb)))+cmax.*Flag4ub+cmin.*Flag4lb;
        % Calculate objective function for each search agent
        fitness(i)=fobj(i,x(i,:));
        % Update best Leeches
        if fitness(i)<=EANFIS_best_score
            EANFIS_best_score=fitness(i);
            EANFIS_best_pos=x(i,:);
        end
    end
    Prey_Position=EANFIS_best_pos;

    [sv,si]=sort(fitness);
    % reinitialize particles with negative lifespan
    for i=1:p
        if si(i)>(2*p/3)
           L(i) = L(i) - si(i);
        end
        if L(i) >= 0
            continue;
        end
        L(i) = l;
        if rand < pp
            x(i,:) = my_rand(cmax-cmin,1) + cmin;
        else
            x(i,:) = my_rand(ones(1,dim),1);
        end
        wc = log10(t+1);  %对应文中的W变量，其定义在文中第7页
        % pre-optmize particles
        j=1;
        while j <= wc
            x(i,:) = subprocess(fobj,i,ub,lb,x(i,:),EANFIS_best_pos,cmax,cmin,dim,wg,wl,wr,f_max,k1,k2);
            ry_lb = fobj(x(i,:));
            ry_gb = fobj(x_gb);
            if ry_lb < ry_gb
                x_gb = x(i,:);
            end
            j = j + 1;
        end
    end

    %% Re-tracking strategy
    Temp_best_fitness(t+1)=EANFIS_best_score;
    if t>t1
        if Temp_best_fitness(t+1)==Temp_best_fitness(t+1-t2)
            for i=1:size(x,1)
                if fitness(i)==EANFIS_best_score
                    x(i,:)=rand(1,dim).*(cmax-cmin)+cmin;
                end
            end
        end
    end
    if rand()<0.5
        s=8-1*(-(t/Max_iter)^2+1);
    else
        s=8-7*(-(t/Max_iter)^2+1);
    end
    beta=-0.5*(t/Max_iter)^6+(t/Max_iter)^4+1.5;
    LV=0.5*levy(p,dim,beta);
    %% Generate random integers
    minValue = 1;  % minimum integer value
    maxValue = floor(p*(1+t/Max_iter)); % maximum integer value
    k2 = randi([minValue, maxValue], p, dim);
    k = randi([minValue, dim], p, dim);
    for i=1:N1
        for j=1:size(x,2) 
            r1=2*rand()-1; % r1 is a random number in [0,1]
            r2=2*rand()-1;
            r3=2*rand()-1;           
            PD=s*(1-(t/Max_iter))*r1;
            if abs(PD)>=1
                % Exploration of directional ANFIS
                b=0.001;
                W1=(1-t/Max_iter)*b*LV(i,j);
                L1=r2*abs(Prey_Position(j)-x(i,j))*PD*(1-k2(i,j)/p);
                L2=abs(Prey_Position(j)-x(i,k(i,j)))*PD*(1-(r2^2)*(k2(i,j)/p));
                if rand()<a
                if abs(Prey_Position(j))>abs(x(i,j))
                x(i,j)=x(i,j)+W1*x(i,j)-L1;
                else
                x(i,j)=x(i,j)+W1*x(i,j)+L1;
                end
                else
                if abs(Prey_Position(j))>abs(x(i,j))
                x(i,j)=x(i,j)+W1*x(i,k(i,j))-L2;
                else
                x(i,j)=x(i,j)+W1*x(i,k(i,j))+L2;
                end
                end                
            else
                % Exploitation of directional ANFIS
                if t>=0.1*Max_iter
                    b=0.00001;
                end
                W1=(1-t/Max_iter)*b*LV(i,j);
                L3=abs(Prey_Position(j)-x(i,j))*PD*(1-r3*k2(i,j)/p);
                L4=abs(Prey_Position(j)-x(i,k(i,j)))*PD*(1-r3*k2(i,j)/p);
                if rand()<a
                if abs(Prey_Position(j))>abs(x(i,j))
                x(i,j)=Prey_Position(j)+W1*Prey_Position(j)-L3;
                else
                x(i,j)=Prey_Position(j)+W1*Prey_Position(j)+L3;
                end
                else
                 if abs(Prey_Position(j))>abs(x(i,j))
                x(i,j)=Prey_Position(j)+W1*Prey_Position(j)-L4;
                else
                x(i,j)=Prey_Position(j)+W1*Prey_Position(j)+L4;
                end                   
                end
            end
        end
    end
    %% Search strategy of directionless ANFIS
    for i=(N1+1):size(x,1)
        for j=1:size(x,2)
            if min(cmin)>=0
                LV(i,j)=abs(LV(i,j));
            end
            if rand()>0.5
            x(i,j)=(t/Max_iter)*LV(i,j)*x(i,j)*abs(Prey_Position(j)-x(i,j));  
            else
            x(i,j)=(t/Max_iter)*LV(i,j)*Prey_Position(j)*abs(Prey_Position(j)-x(i,j));          
            end
        end
    end
    t=t+1;     
    Convergence_curve(t)=EANFIS_best_score;  
    %%%%

    disp(['In Iteration Number ' num2str(t) ': Highest Cost Is = ' num2str(EANFIS_best_score)]);
end


