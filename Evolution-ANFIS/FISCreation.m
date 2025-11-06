function fis=FISCreation(data,nCluster)
    if ~exist('nCluster','var')
        nCluster='auto';
    end
    x=data.TrainInputs;
    t=data.TrainTargets;
    %% 接下来的是FCM算法的参数设置
    % 表示模糊度参数，用于控制聚类的模糊程度
    fcm_U=2;
    % 表示最大迭代次数，用于控制算法的收敛速度。
    fcm_MaxIter=100;
    % 表示最小收敛值，用于控制算法的收敛速度
    fcm_MinImp=1e-5;
    % 表示是否显示聚类结果
    fcm_Display=false;
    % 将FCM算法的参数存储在数组中
    fcm_options=[fcm_U fcm_MaxIter fcm_MinImp fcm_Display];
    % 使用genfis3函数生成一个sugeno类型的模糊推理系统
    fis=genfis3(x,t,'sugeno',nCluster,fcm_options);
end