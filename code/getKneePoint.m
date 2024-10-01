%MMD knee point selection
function [kneePoint,kneePointIndex] = getKneePoint(Problem,Population,FrontNo)
    NonDonminSol = Population(FrontNo == 1);
    Dist = zeros(1,size(NonDonminSol,2));
    PopulationObjs = NonDonminSol.objs;
    fm_min = min(PopulationObjs,[],1);
    fm_max = max(PopulationObjs,[],1);
    L = fm_max - fm_min;
    fm_midian = (fm_max + fm_min)./2;
    for i = 1 : Problem.M       
        for j = 1 : length(NonDonminSol)
            tmp = NonDonminSol(j).obj;
            Dist(j) = Dist(j) + abs(tmp(i) - fm_midian(i))./L(i);
        end
    end
    [~,kneePointIndex] = min(Dist);
    kneePoint = NonDonminSol(kneePointIndex);
    tmp = find(FrontNo == 1);
    kneePointIndex = tmp(kneePointIndex);
end
