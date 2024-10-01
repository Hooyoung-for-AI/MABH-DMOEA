function [Population,reward,Memory_Set,entirePopulation] = playArm(chosenArm,Problem,Population,i,randChoseResult,responsePrar,trainGroup,Memory_Set,diversityIncrease)
%%
    trainGroupIndv = cell2mat(trainGroup(i));
    %chosenArm = 4;
    switch chosenArm
        case 1
            for j = 1 : length(trainGroupIndv)
                Population = Response1(Problem,Population,trainGroupIndv(j),responsePrar.kneeDirction,diversityIncrease);
            end
        case 2
            for j = 1 : length(trainGroupIndv)
                Population = Response2(Problem,Population,trainGroupIndv(j),Population(responsePrar.clusterReprsentIdv),responsePrar.clusterDirction,diversityIncrease);
            end
        case 3
            for j = 1 : length(trainGroupIndv)
                Population = Response3(Problem,Population,trainGroupIndv(j),Memory_Set); 
                if ~isempty(Memory_Set)
                    Memory_Set(1) = [];
                end
            end
        case 4
            for j = 1 : length(trainGroupIndv)
                Population = Response4(Problem,Population,trainGroupIndv(j));
            end
    end

%%
    %getReward(Population(i),randChoseResult);
    %[FrontNo,MaxFNo] = NDSort(Population.objs,Population.cons,N);
    entirePopulation = [Population(trainGroupIndv),randChoseResult];
    [FrontNo,~] = NDSort(entirePopulation.objs,size(entirePopulation,2));
%    compareMatrixDomN = FrontNo > FrontNo(1);
%     DomN = sum(compareMatrixDomN);
%     compareMatrixNDomN = FrontNo <= FrontNo(1);
%     NDomN = sum(compareMatrixNDomN);
%%
    trainGroupFrontNo = FrontNo(1:length(trainGroupIndv));
    reward = sum(trainGroupFrontNo == ones(1,length(trainGroupFrontNo)));
    %reward = sum(1./FrontNo(1:length(trainGroupIndv)));
%     %如果通过该动作得到的新个体支配所有的检测种群，那么就给最大的奖励值
%     if FrontNo(1) == 1
%         reward = 1.5;
%         return
%     end
%     %用一个分段函数得到奖励值
%     critic = DomN / NDomN;
%     if critic <= 0.5
%         reward = -1;
%     elseif (critic > 0.5) && (critic <= 1.2)
%         reward = 0;
%     elseif (critic > 1.2) && (critic <= 10)
%         reward = 1;
%     else 
%         reward = 1.5;
%     end
end



    