function [historyReward,numPlays] = ReverseTrain(Problem,Population,historyReward,numPlays,armRecord,trainGroup,randChoseResult)
    AllPopulation = [Population,randChoseResult];
    [FrontNo,~] = NDSort(AllPopulation.objs,length(AllPopulation));
    PopulationFrontNo = FrontNo(1 : Problem.N);
    TmpReward = PopulationFrontNo==ones(1,Problem.N);
    LtrainGroup = length(trainGroup);
    for i = 1 : LtrainGroup
        trainGroupIndv = cell2mat(trainGroup(i));
        reward = sum(TmpReward(trainGroupIndv));
        reward = reward * (1-i./LtrainGroup);
        historyReward(armRecord(i)) = historyReward(armRecord(i)) + 0.3*(reward-historyReward(armRecord(i)));
        %numPlays(armRecord(i)) = numPlays(armRecord(i)) + 1;
    end
end

