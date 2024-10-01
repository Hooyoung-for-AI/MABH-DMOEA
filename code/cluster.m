function [clusterRepresentIdv,clusterRepresentObjRank,clusterRepresentDec] = cluster(Problem,Population,FrontNo)
    [idx] = kmeans(Population.decs,20);
    clusterTmpIndex = cell(1,20);
    for i = 1 : 20
        %得到每个类中个体的索引
        clusterTmpIndex(i) = {find(idx == i)};
    end
    clusterRepresentIdv = zeros(1,20);
    for i = 1 : 20
        clusterIdv = cell2mat(clusterTmpIndex(i));
        chackFrontNo = FrontNo(clusterIdv);
        [~,minFrontNo] = min(chackFrontNo);
        clusterRepresentIdv(i) = clusterIdv(minFrontNo);
    end
    clusterReprsentPop = Population(clusterRepresentIdv);
    %clusterRepresentObj = clusterReprsentPop.objs;
    clusterRepresentDec = clusterReprsentPop.decs;
    rank = zeros(Problem.N,Problem.M);
    PopulationObj = Population.objs;
    for i = 1 : Problem.M
        [~,index] = sort(PopulationObj(:,i));
        [~,rank(:,i)] = sort(index);
    end
    clusterRepresentObjRank = rank(clusterRepresentIdv,:);
end






%     rank = zeros(Problem.N,Problem.M);
%     PopulationObj = Population.objs;
%     for i = 1 : Problem.M
%         [~,index] = sort(PopulationObj(:,i));
%         [~,rank(:,i)] = sort(index);
%     end
%     Center = zeros(20,Problem.M);
%     for i = 1 : 20
%         k = cell2mat(clusterTmpIndex(i));
%         Center(i,:) = mean(rank(k,:),1);
%     end
%     [~,tmp] = sort(Center(:,2));
%     Center = Center(tmp,:);
%     C = C(tmp,:);
%     for i = 1 : 5
%         k = cell2mat(clusterTmpIndex(i));
%         l = length(k);
%         for j = 1 : l
%             k(l)
% 
%         Center(i,1) = mean(find(objSort(:,1) == cell2mat(clusterTmpIndex(i))));
%         Center(i,2) = mean(find(objSort(:,2) == cell2mat(clusterTmpIndex(i))));
%         Center(i,3) = mean(find(objSort(:,3) == cell2mat(clusterTmpIndex(i))));
%     end