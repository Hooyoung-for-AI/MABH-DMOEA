function [MDPC,MDPCdec] = MDPcluster(Problem,Population,kneePointID,K)
    extremeSolutionIndex = zeros(1,Problem.M);
    tmpPopulationObjs = Population.objs;
    for i = 1 : Problem.M
        [~,extremeSolutionIndex(i)] = min(tmpPopulationObjs(:,i));
    end
    Cid = [extremeSolutionIndex,kneePointID];
    L = length(Cid);
    while L <= K
        CidPop = Population(Cid);
        CidPopobj = CidPop.objs;
        [~,SortCidPopobjIndex] = sort(CidPopobj(:,1));
        Cid = Cid(SortCidPopobjIndex);
        C = Population(Cid);
        Cpopobj = C.objs;
        dist = pdist2(Population.decs,C.decs);
        [~,clusterIndex] = min(dist,[],2);
        newClusterCtmp = zeros(1,L);
        distTmp = zeros(L,1);
        for i = 1 : L
            Lj = find(clusterIndex == i); 
            DistLj = dist(Lj,i);
            [distTmp(i),furthestIdv] = max(DistLj);
            newClusterCtmp(i) = Lj(furthestIdv);
        end
        newClusterCtmpPop = Population(newClusterCtmp);
        newClusterCtmpObj = newClusterCtmpPop.objs;
        newClusterC = zeros(1,L-1);
        for i = 1 : L - 1
            middleObjofC = mean(Cpopobj(i:i+1,:),1);
            compareObjDist = pdist2(newClusterCtmpObj(i:i+1,:),middleObjofC);
            [~,choseIndex] = min(compareObjDist);
            newClusterC(i) = newClusterCtmp(i + choseIndex-1);
        end
        Cid = [Cid,newClusterC];
        L = length(Cid);
    end
    CidPop = Population(Cid);
    CidPopobj = CidPop.objs;
    [~,SortCidPopobjIndex] = sort(CidPopobj(:,1));
    MDPC = Cid(SortCidPopobjIndex);
    MDPCdecTmp = Population(MDPC);
    MDPCdec = MDPCdecTmp.decs;
    MDPC = MDPCdecTmp;
 end





%     while L <= K
%         C = Population(Cid);
%         dist = pdist2(Population.decs,C.decs);
%         [~,clusterIndex] = min(dist,[],2);     
%         removeIdv = zeros(1,L);
%         distTmp = zeros(L,1);
%         for i = 1 : L
%             Lj = find(clusterIndex == i);
%             DistLj = dist(Lj,i);
%             [distTmp(i),furthestIdv] = max(DistLj);
%             removeIdv(i) = Lj(furthestIdv);
%         end
%         booleanIndex = ones(length(removeIdv),1);
%         for i = 1 : length(removeIdv) - 1
%             Pop1 = Population(removeIdv(i)).dec;
%             for j = i + 1 : length(removeIdv)
%                 Pop2 = Population(removeIdv(j)).dec;
%                 disttmp = pdist2(Pop1,Pop2);
%                 tmp = [distTmp(i),distTmp(j)];
%                 [mindist,removeNum] = min(tmp);
%                 if disttmp < mindist
%                     if removeNum == 1
%                         removeNum1 = i;
%                     elseif removeNum == 2
%                         removeNum1 = j;
%                     end
%                     booleanIndex(removeNum1) = 0;
%                 end
%             end
%         end
%         Cid = [Cid,removeIdv(booleanIndex==1)];
%         L = length(Cid); 
%     end
%     MDPC = Cid;
% end