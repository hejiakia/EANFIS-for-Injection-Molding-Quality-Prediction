function p=FISParameters(fis,p)
    p=[];
    nInput=numel(fis.input);
    for i=1:nInput
        % 获取隶属函数的数量
        nMF=numel(fis.input(i).mf);
        for j=1:nMF
            % 遍历每个隶属函数将参数添加到数组p中
            p=[p fis.input(i).mf(j).params];
        end
    end
    nOutput=numel(fis.output);
    for i=1:nOutput
        % 获取隶属函数的数量
        nMF=numel(fis.output(i).mf);
        for j=1:nMF
            % 遍历每个隶属函数将参数添加到数组p中
            p=[p fis.output(i).mf(j).params];
        end
    end 
end