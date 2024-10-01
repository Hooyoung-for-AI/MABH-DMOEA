%%  Memory storage strategy
function [Memory_Set,K]=Memory_store(Population,Memory_Set,t_size,M_num,K,Problem)
    PopulationObjs = Population.objs;
    Dist = zeros(1,size(Population,2));
    fm_min = min(PopulationObjs,[],1);
    fm_max = max(PopulationObjs,[],1);
    L = fm_max - fm_min;
    fm_midian = (fm_max + fm_min)./2;
    for i = 1 : Problem.M       
        for j = 1 : length(Population)
            tmp = Population(j).obj;
            Dist(j) = Dist(j) + abs(tmp(i) - fm_midian(i))./L(i);
        end
    end
    [~,kneePointIndex] = min(Dist);
    tmpPopulation = Population;
    tmpPopulation(kneePointIndex) = [];

       indexs=Farthest_first_selection(tmpPopulation,t_size-1);
       indexs = [kneePointIndex,indexs];

      if size(Memory_Set,1)<M_num
             Memory_Set=[Memory_Set;Population(indexs)];
      else
            V=mod(K,5)+1;
            Memory_Set(V,:)=Population(indexs);
            K=K+1;
      end
end

