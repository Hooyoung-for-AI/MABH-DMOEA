function [allPopulation,numPlays,historyReward] = UniformChangeResponse(Problem,Population,extremeNonDonminateSolution,RePop,numPlays,historyReward,responsePrar,Memory_Set)
    outputPopulation = repmat(extremeNonDonminateSolution,1,3);
    for i = 1 : length(outputPopulation)
        outputPopulation = ChoseToResponse(Problem,Population,outputPopulation,i,responsePrar,Memory_Set);
    end
    allPopulation = [outputPopulation,RePop];
    [FrontNo,~] = NDSort(allPopulation.objs,length(allPopulation));
    for t = 1 : length(outputPopulation)
        responseNum = mod(i,3) + 1;
        numPlays(responseNum) = numPlays(responseNum) + 1;
        if FrontNo(t) == 1
            historyReward(responseNum) = historyReward(responseNum) + 1;
        end
    end

        
end


function [outputPopulation,Memory_Set] = ChoseToResponse(Problem,Population,outputPopulation,i,responsePrar,Memory_Set)
    responseNum = mod(i,3);
    switch responseNum
        case 0
            outputPopulation = Response1(Problem,outputPopulation,i,responsePrar.kneeDirction,1);
        case 1
            MDPC = Population(responsePrar.clusterReprsentIdv);
            outputPopulation = Response2(Problem,outputPopulation,i,MDPC,responsePrar.clusterDirction,1);
        case 2
            outputPopulation = Response3(Problem,outputPopulation,i,Memory_Set); 
            if ~isempty(Memory_Set)
                Memory_Set(1) = [];
            end
    end
end