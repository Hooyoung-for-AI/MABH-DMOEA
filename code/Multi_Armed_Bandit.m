function [Population,totalReward,numPlays,armRecord] = Multi_Armed_Bandit(Problem,Population,responsePrar,randChoseResult,numPlays,historyReward,trainGroup,Memory_Set,diversityIncrease)
    criticPoint = Memory_Set(:,1);
    valCriticPoint = Problem.Evaluation(criticPoint.decs);
    [FrontNoOfMemory,~] = NDSort(valCriticPoint.objs,length(valCriticPoint));
    [~,sortFrontNoOfMemory] = sort(FrontNoOfMemory);
    FrontNoOfMemoryRank = sort(sortFrontNoOfMemory);
    Memory_Set = Memory_Set(FrontNoOfMemoryRank,:);
    Memory_Set = reshape(Memory_Set,[],1).';

    [~,FrontNoOfMemorySortIndex] = sort(FrontNoOfMemory);
    Memory_Set = Memory_Set(FrontNoOfMemorySortIndex);
    numArms=responsePrar.numArms;
    epsilon=responsePrar.epsilon;
    epsilon = 0.2;
    % 多臂赌博机的臂数numArms
    % ε贪心算法
    numIterations = length(trainGroup);armRecord = zeros(1,numIterations);
    % 初始化每个臂的总奖励和选择次数
    totalReward = historyReward;
    %numPlays = zeros(1, numArms);
    % 模拟numIterations次选择
    % 开始模拟选择过程
    for i = 1 : numArms
        [Population,reward,Memory_Set,randChoseResult] = playArm(i,Problem,Population,i,randChoseResult,responsePrar,trainGroup,Memory_Set,diversityIncrease);
        reward = i./numIterations * reward;
        numPlays(i) = numPlays(i) + 1;
        totalReward(i) = totalReward(i) + 0.3*(reward-totalReward(i));
        armRecord(i) = i;
    end

    for i = numArms + 1:numIterations
        % 使用ε-贪心算法选择一个臂
        if rand() < 0
            % 随机选择一个臂进行探索
            chosenArm = randi(numArms);
        else
            % 选择估计收益最高的臂进行利用
            estimatedMeans = totalReward ;%./ numPlays;
            estimatedMeans(isnan(estimatedMeans)) = 0;
            a = cumsum(estimatedMeans)./sum(estimatedMeans);
            b = rand(1);
            if b < a(1)
                chosenArm = 1;
            elseif b>=a(1) && b<=a(2)
                chosenArm = 2;
            else
                chosenArm = 3;
            end

            %[~, chosenArm] = max(estimatedMeans);
        end
        % 假设根据选择的臂执行并得到奖励
        %chosenArm = 2;
        [Population,reward,Memory_Set,randChoseResult] = playArm(chosenArm,Problem,Population,i,randChoseResult,responsePrar,trainGroup,Memory_Set,diversityIncrease);
        reward = i./numIterations * reward;
        % 更新选择的臂的总奖励和选择次数
        numPlays(chosenArm) = numPlays(chosenArm) + 1;%1;
        totalReward(chosenArm) = totalReward(chosenArm) + 0.3*(reward-totalReward(chosenArm));%(reward - totalReward(chosenArm)) / numPlays(chosenArm);
        armRecord(i) = chosenArm;
    end
    
    % 显示每个臂的平均奖励
    averageRewards = totalReward; %./ numPlays;
    %chosenArmprob = softmax(averageRewards);
    %numPlays=zeros(1,4);
end