function Population = Response3(Problem,Population,i,Memory_Set)
    if isempty(Memory_Set)
        Population = Response4(Problem,Population,i);
        return
    end
    individual = Memory_Set(1);
    Population(i) = Problem.Evaluation(individual.dec);
end