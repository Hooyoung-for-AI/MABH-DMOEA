function [Population,historyReward,numPlays] = ChangeResponseWithTrain(Problem,Population,randChoseResult,numPlays,historyReward,responsePrar,Memory_Set,diversityIncrease)%,randChosepopResult,reward,C_Dirction,kneeDirction,clusterDirction,Center,objRank,numPlays,MDPC,MDPStep)
    responsePrar.numArms = responsePrar.responseNum;
    responsePrar.epsilon = 0.1;
    rank = zeros(Problem.N,Problem.M);
    PopulationObj = Population.objs;
    for i = 1 : Problem.M
        [~,index] = sort(PopulationObj(:,i));
        [~,rank(:,i)] = sort(index);
    end
    extremePoint = rank(1,:);
    lengthExtremePoint = length(extremePoint);
    extremePointSolution = Population(extremePoint);
    distBetweenPopAndExtremePoint = pdist2(Population.decs,extremePointSolution.decs);
    PopIndex = (1:Problem.N).';
    distBetweenPopAndExtremePoint = [PopIndex,distBetweenPopAndExtremePoint];
    unChangeDistBetweenPopAndExtremePoint = distBetweenPopAndExtremePoint;
    clusterIdvNum = floor(Problem.N./(lengthExtremePoint + 1));
    cluster = cell(1,lengthExtremePoint+1);
    for i = 1 : lengthExtremePoint
        dist_Pop_i = distBetweenPopAndExtremePoint(:,i+1);
        [~,rank_sort_dist_Pop_i] = sort(dist_Pop_i);
        remainDistbetweenPopAndExtremePoint = distBetweenPopAndExtremePoint(rank_sort_dist_Pop_i,1);
        cluster(i) = {remainDistbetweenPopAndExtremePoint(1:clusterIdvNum)};
        remainPop = remainDistbetweenPopAndExtremePoint(clusterIdvNum+1:end);
        distBetweenPopAndExtremePoint = unChangeDistBetweenPopAndExtremePoint(remainPop,:);
    end
    cluster(lengthExtremePoint+1) = {distBetweenPopAndExtremePoint(:,1)};
    trainGroup = cell(1,clusterIdvNum);
    clusterMat = zeros(clusterIdvNum,length(cluster));
    for i = 1 : length(cluster)
        randIndex = randperm(clusterIdvNum);
        clusterMatTmp = cell2mat(cluster(i));
        clusterMat(:,i) = clusterMatTmp(randIndex);
    end
    for i = 1 : length(trainGroup)
        trainGroup(i) = {clusterMat(i,:)};
    end
    clusterEnd = cell2mat(cluster(end));
    if length(clusterEnd) ~= clusterIdvNum
        errorNum = length(cell2mat(cluster(end))) - clusterIdvNum;
        errorIndv = clusterEnd(end-errorNum+1 : end);
        trainGroup(end) = {[cell2mat(trainGroup(end)),errorIndv]};
    end
    [Population,historyReward,numPlays,armRecord] = Multi_Armed_Bandit(Problem,Population,responsePrar,randChoseResult,numPlays,historyReward,trainGroup,Memory_Set,diversityIncrease);
    showReward = historyReward;
    [historyReward,numPlays] = ReverseTrain(Problem,Population,historyReward,numPlays,armRecord,trainGroup,randChoseResult);
    Population = [Population,randChoseResult];
    [FrontNo,MaxFNo] = NDSort(Population.objs,Problem.N);
    Next = FrontNo < MaxFNo;
    %% Calculate the crowding distance of each solution
    CrowdDis = CrowdingDistance(Population.objs,FrontNo);
    %% Select the solutions in the last front based on their crowding distances
    Last     = find(FrontNo==MaxFNo);
    [~,Rank] = sort(CrowdDis(Last),'descend');
    Next(Last(Rank(1:Problem.N-sum(Next)))) = true;
    
    %% Population for next generation
    Population = Population(Next);
end
