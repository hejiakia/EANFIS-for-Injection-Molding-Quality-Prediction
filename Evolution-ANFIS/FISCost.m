function [z, out]=FISCost(x,fis,data)

    % 如果绝对值小于MinAbs，将此值限制在此范围之间
    MinAbs=1e-5;
    if any(abs(x)<MinAbs)
        S=(abs(x)<MinAbs);
        x(S)=MinAbs.*sign(x(S));
    end

%     % 提取fis参数
%     p0=FISParameters(fis);
% 
%     % 将调整后的参数x相乘得到新的参数p
%     p=npop(i).*x; 

    % 将新的参数p设置给fis
    fis=FISSet(fis,x);  

    % 使用数据进行模糊推理的预测
    x=data.TrainInputs;
    t=data.TrainTargets;
    y=evalfis(x,fis); 

    % 计算RMSE作为其适应度值z
    e=t-y; 
    MSE=mean(e(:).^2);
    RMSE=sqrt(MSE);  
    z=RMSE;  
    out.fis=fis;
    out.MSE=MSE;
    out.RMSE=RMSE; 
end