function Population = Response2(Problem,Population,i,MDPC,clusterDirction,option)
    %MDPC = Population(clusterReprsentIdv);
    [~,clusterIndex] = min(pdist2(Population(i).dec,MDPC.decs));
    switch option
        case 0
            individual = Population(i).dec + clusterDirction(clusterIndex,:);
            individual = min(max(individual,Problem.lower),Problem.upper);
        case 1
            sigma = clusterDirction(clusterIndex,:)./30;
            individual = Population(i).dec + clusterDirction(clusterIndex,:) + normrnd(clusterDirction(clusterIndex,:),sigma);
            individual = min(max(individual,Problem.lower),Problem.upper);
    end
    x = Problem.Evaluation(individual);
    Population(i) = x;
end
    