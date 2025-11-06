% Clearing the Space
clc;
clear;
close all;
warning('off');
%% Start The System 
% Loading Data

% load basic_diffusion_sp.mat
load test.mat
% load ZDdata.mat

% Shuffling or Swapping Rows (Diverse Result in Each Run)
random_x = test(randperm(size(test, 1)), :);
% Deviding Data and Labels
traininput=random_x(:,1:end-1);
traintarget=random_x(:,end);
% Creating Final Struct
data.TrainInputs=traininput;
data.TrainTargets=traintarget; 

for i=1:50
    Fuzzy=FISCreation(data,3);
    ANFIS=ANFISTrain(Fuzzy,data);
    npop(i,:)=FISParameters(ANFIS);
end

%% Training Stage
% Generating the FIS
tic
Fuzzy=FISCreation(data,3);
% Tarin Using ANFIS Method
ANFIS=ANFISTrain(Fuzzy,data);
% Tarining By AHA Algorithm (AHA-ANFIS)
%[ANFIS_vMin,ANFIS_theBestVct,ANFIS_Convergence_curve]=EANFIS_Train(ANFIS,data);
[ANFIS_vMin,ANFIS_theBestVct,ANFIS_Convergence_curve]=EANFIS_Train(npop,ANFIS,data);

% p0=FISParameters(ANFIS);
% pa=ANFIS_theBestVct.*p0;
pa=ANFIS_theBestVct;
EANFIS=FISSet(ANFIS,pa);

FuzzyOutputs=evalfis(data.TrainInputs,Fuzzy);
ANFISOutputs=evalfis(data.TrainInputs,ANFIS);
EANFISOutputs=evalfis(data.TrainInputs,EANFIS);
%% Calculating Classification Accuracy
AllTar=data.TrainTargets;
% Generating Outputs
FORound=round(FuzzyOutputs);
AORound=round(ANFISOutputs);
EAORound=round(EANFISOutputs);
sizedata=size(FORound);
sizedata=sizedata(1,1);
classmax=max(AllTar);
classmin=min(AllTar);
for i=1 : sizedata
    if FORound(i) > classmax
        FORound(i)=classmax;
    end
    if FORound(i) < classmin
        FORound(i)=classmin;
    end
end
for i=1 : sizedata
    if AORound(i) > classmax
        AORound(i)=classmax;
    end
    if AORound(i) < classmin
        AORound(i)=classmin;
    end
end
for i=1 : sizedata
    if EAORound(i) > classmax
        EAORound(i)=classmax;
    end
    if EAORound(i) < classmin
        EAORound(i)=classmin;
    end
end
% Calculating Accuracy
% Fuzzy Accuracy
ctfuzz=0;
for i = 1 : sizedata(1,1)
    if FORound(i) ~= AllTar(i)
        ctfuzz=ctfuzz+1;
    end
end
finfuzz=ctfuzz*100/ sizedata;
FuzzyAccuracy=(100-finfuzz);
% ANFIS Accuracy
ctanf=0;
for i = 1 : sizedata(1,1)
    if AORound(i) ~= AllTar(i)
        ctanf=ctanf+1;
    end
end
finanf=ctanf*100/ sizedata;
ANFISAccuracy=(100-finanf);
% AHA ANFIS Accuracy
ctganf=0;
for i = 1 : sizedata(1,1)
    if EAORound(i) ~= AllTar(i)
        ctganf=ctganf+1;
    end
end
finganf=ctganf*100/ sizedata;
EANFIS_Accuracy=(100-finganf);
% Confusion Matrixes
% Extracting Errors
FOMSE=mse(AllTar,FORound);
AOMSE=mse(AllTar,AORound);
EANFISMSE=mse(AllTar,EAORound);

C=confusionmat(AllTar, EAORound);
num_classes=size(C,1);
% 提取 TP, FP, FN
TP = zeros(1, num_classes);
FP = zeros(1, num_classes);
FN = zeros(1, num_classes);
for i = 1:num_classes
    TP(i) = C(i, i); % 真正例
    FP(i) = sum(C(:, i)) - C(i, i); % 假正例
    FN(i) = sum(C(i, :)) - C(i, i); % 假反例
end

% 计算 Precision 和 Recall
Precision = TP ./ (TP + FP);
Recall = TP ./ (TP + FN);

% 计算 F1-score
F1 = 2 * (Precision .* Recall) ./ (Precision + Recall);

% 显示结果
macro_Recall = mean(Recall);
macro_F1 = mean(F1);
disp(['Precision: ', num2str(EANFIS_Accuracy-EANFISMSE)]);
disp(['MSE:', num2str(EANFISMSE)])
disp(['F1-score: ', num2str(macro_F1)]);
disp(['Recall: ', num2str(macro_Recall)]);

errors = EAORound-AllTar;
var_error = var(errors, 0);
std_error = std(errors, 0);
disp(['Var:', num2str(var_error)]);
disp(['Std:', num2str(std_error)]);

% Print Accuracy
%fprintf('The EANFIS Classification Accuracy is = %0.4f.\n',EANFIS_Accuracy-EANFISMSE)
toc

figure;
plot(ANFIS_Convergence_curve,'-.','LineWidth',3,'MarkerSize',12,'MarkerEdgeColor','b',...
    'Color',[0.6,0,0.9]);title('ANFIS Genetic Algorithm','Color','r');
xlabel('EANFIS Iteration Number','FontSize',12,'FontWeight','bold','Color',[0.6,0,0.9]);
ylabel('EANFIS Best Cost Result','FontSize',12,'FontWeight','bold','Color',[0.6,0,0.9]);
legend({'EANFIS Train'});
% fprintf('EANFIS Iteration Number = %0.4f.\n',n)
% Record(n,:)=EANFIS_Accuracy-EANFISMSE;