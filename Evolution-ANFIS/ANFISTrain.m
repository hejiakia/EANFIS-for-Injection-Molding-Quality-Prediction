function fis=ANFISTrain(fis,data)
    x=data.TrainInputs;
    t=data.TrainTargets;
    % 训练迭代次数
    train_Epoch=80;
    % 训练目标误差
    train_ErrorGoal=0;
    % 训练初始步长
    train_InitialStepSize=1.1;
    % 训练步长减弱因子
    train_StepSizeDecrease=0.9;
    % 训练步长增强因子
    train_StepSizeIncrease=1.1;
    TrainOptions=[train_Epoch train_ErrorGoal train_InitialStepSize train_StepSizeDecrease train_StepSizeIncrease];
    % 显示信息
    display_Info=false;
    display_Error=false;
    display_StepSize=false;
    display_Final=false;
    DisplayOptions=[display_Info display_Error display_StepSize display_Final];
    % 优化选项
    % 1：使用最小二乘估计和后向传播
    % 0：仅仅使用后向传播
    OptMethod.Backpropagation=0;
    fis=anfis([x t],fis,TrainOptions,DisplayOptions,[],OptMethod.Backpropagation);
end