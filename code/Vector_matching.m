%% Weight vector matching mechanism such that each individual is associated with its nearest weight vector subproblem
function Population=Vector_matching(Population,W)
        T_W=(1./W)./sum(1./W,2);
        Dist=pdist2(T_W,Population.objs,'cosine');
        [t,~]=size(T_W);
        Pop_indexs=1:t; P=[]; 
        for i=1:t
            [~,h]=sort(Dist(i,:),2);
            P(i)=Pop_indexs(h(1)); 
            Pop_indexs(h(1))=[];
            Dist(:,h(1))=[];    
        end
        Population=Population(P);   
end