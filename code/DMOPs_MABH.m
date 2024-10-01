classdef DMOPs_MABH < ALGORITHM
%<multi/many> <real> <none> <dynamic>
%基于强化学习的动态多目标算法
%platemo('algorithm',@DMOPs_RE,'problem',@FDA1,'N',100,'maxFE',10000)
    methods
        function main(Algorithm,Problem)
            t = 1;
            Problem.iter = t;
            Population = Problem.Initialization();
            changeTag = 0;
            responsePrar.responseNum = 3;
            historyReward = zeros(1,responsePrar.responseNum);
            AllPop = [];
            numArms = responsePrar.responseNum;
            numPlays = zeros(1, numArms);
 %%
            %[FrontNo,~] = NDSort(Population.objs,Problem.N);

 %%
            type = Algorithm.ParameterSet(2);
            Memory_Set=[];K=0; t_size=30;M_num=10;
            [W,~] = UniformPoint(Problem.N,Problem.M);
            W=Update_Weight(W,Problem.N);
            B = pdist2(W,W);
            [~,B] = sort(B,2);
            Z = min(Population.objs,[],1);
            changeSeverityRecord = [];
            MutationSelectIndex = 0;
 %%
            %uniformProb = ones(1,responseNum) ./ responseNum;
            while Algorithm.NotTerminated(Population)
                %%
                %%
                [changed,RePop,diversityIncrease,changeSeverityRecord] = My_Changed(Problem,Population,changeSeverityRecord,changeTag);
                if changed
                    AllPop = [AllPop,Population]; 
                    %%
                    [Memory_Set,K]=Memory_store(Population,Memory_Set,t_size,M_num,K,Problem); 
                    %%
                    if changeTag == 0
                        responsePrar.Curr_C = mean(Population.decs,1);
                        [responsePrar.clusterRepresentIdv,responsePrar.clusterRepresentObjRank,responsePrar.clusterRepresentDec] = cluster(Problem,Population,FrontNo);
                        [responsePrar.kneePoint,responsePrar.kneePointIndex] = getKneePoint(Problem,Population,FrontNo);                    
                        for i = 1 : Problem.N
                            Population = Response4(Problem,Population,i);
                        end
                        changeTag = changeTag + 1;
                        MutationSelectIndex = 0;
                    else
                        %%
                        responsePrar.Last_C = responsePrar.Curr_C;
                        responsePrar.Curr_C = mean(Population.decs,1);
                        responsePrar.C_Dirction = responsePrar.Curr_C - responsePrar.Last_C;
                        %%
                        responsePrar.oldClusterRepresentIdv = responsePrar.clusterRepresentIdv; responsePrar.oldClusterRepresentObjRank = responsePrar.clusterRepresentObjRank;
                        responsePrar.oldClusterRepresentDec = responsePrar.clusterRepresentDec;
                        [responsePrar.clusterReprsentIdv,responsePrar.clusterRepresentObjRank,responsePrar.clusterRepresentDec] = cluster(Problem,Population,FrontNo);
%                         [FrontNo,~] = NDSort(Population.objs,Problem.N);
%                         responsePrar.NoDonSol = Population(FrontNo==1);
                        dist_newClusterRepresentObj_oldClusterRepresentObj = pdist2(responsePrar.clusterRepresentObjRank,responsePrar.oldClusterRepresentObjRank);
                        [~,matchRepresentIdvTmp] = min(dist_newClusterRepresentObj_oldClusterRepresentObj,[],2);
                        responsePrar.clusterDirction = responsePrar.clusterRepresentDec - responsePrar.oldClusterRepresentDec(matchRepresentIdvTmp,:);
                        %%
                        responsePrar.oldKneePoint = responsePrar.kneePoint;
                        [responsePrar.kneePoint,responsePrar.kneePointIndex] = getKneePoint(Problem,Population,FrontNo);
                        responsePrar.kneeDirction = responsePrar.C_Dirction;%responsePrar.kneePoint.dec - responsePrar.oldKneePoint.dec;
                        %%
                        NonDonminateSolution = Population(FrontNo == 1);
                        NonDonminateSolutionObjs = NonDonminateSolution.objs;
                        index = zeros(size(NonDonminateSolutionObjs,1),Problem.M);
                        for i = 1 : Problem.M
                            [~,index(:,i)] = sort(NonDonminateSolutionObjs(:,i));
                        end
                        extremeNonDonminateSolution = NonDonminateSolution(index(1,:));
                        extremeNonDonminateSolution = [extremeNonDonminateSolution,responsePrar.kneePoint];
%%
                        [randChoseResult,numPlays,historyReward] = UniformChangeResponse(Problem,Population,extremeNonDonminateSolution,RePop,numPlays,historyReward,responsePrar,Memory_Set);                 
                        [Population,historyReward,numPlays] = ChangeResponseWithTrain(Problem,Population,randChoseResult,numPlays,historyReward,responsePrar,Memory_Set,diversityIncrease);
                        Population=Vector_matching(Population,W);
                        Z=min(Population.objs,[],1);
                        MutationSelectIndex = 0;
                    end
                end
                %%
                    if Problem.M>2
                        T=50; 
                        B1 = B(:,1:T);
                    else
                        T=30; 
                        B1 = B(:,1:T);
                    end
                        %%
                    for i = 1 : Problem.N
                        if MutationSelectIndex <= 1
                            
%                             B2 = B(:,1:T);
                            P = B1(i,randperm(end));
                            tmprand = rand;
                              if tmprand < 0.1
                                  Offspring=DE_current_to_lbest(Problem,Population,Population(i),W,Z,P,Problem.lower,Problem.upper,1.2);

                                  %Offspring=OperatorGAhalf(Problem,[Population(i) Population(P(1))]);
                              elseif tmprand <=0.5
                                  Offspring=DE_current_to_lbest(Problem,Population,Population(i),W,Z,P,Problem.lower,Problem.upper,0.6);

                              elseif tmprand <=0.7
                                  Offspring=DE_rand_to_lbest(Problem,Population,Population(i),W,Z,P,Problem.lower,Problem.upper,1.5);
                              else
                                    Offspring =OperatorDE(Problem,Population(i),Population(P(1)),Population(P(2)),{1,0.5,1,20});
                              end
                        else
                            P = B1(i,randperm(end));
                            tmprand = rand;
                          if tmprand <0.5
                              Offspring=OperatorGAhalf(Problem,[Population(i) Population(P(1))]);
                          elseif tmprand <=0.7
                              Offspring=DE_current_to_lbest(Problem,Population,Population(i),W,Z,P,Problem.lower,Problem.upper,0.6);
                          else
                                Offspring =OperatorDE(Problem,Population(i),Population(P(1)),Population(P(2)),{1,0.5,1,20});
                          end
                        end
%                         MutationSelectIndex = MutationSelectIndex + 1;  
                        % Update the ideal point
                        Z = min(Z,Offspring.obj);
                        % Update the solutions in P by Tchebycheff approach
                        g_old = max(abs(Population(P).objs-repmat(Z,length(P),1)).*W(P,:),[],2);
                        g_new = max(repmat(abs(Offspring.obj-Z),length(P),1).*W(P,:),[],2);
                        update_index=P(find(g_old>=g_new,type));
                        Population(update_index) = Offspring;
                    end
                    MutationSelectIndex = MutationSelectIndex + 1; 
                %end
                    %%
        %% 选择合适的多目标优化器进行优化
                [FrontNo,~] = NDSort(Population.objs,Problem.N);                
                for ii = 1 : length(Population)
                    Population(ii).iter = t;
                end
                if Problem.iter >= Problem.maxIter - 1
                    Population = [AllPop,Population];
                end
                t = t + 1;
                Problem.iter = t;
                        
            end
        end
    end
end