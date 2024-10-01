function [Population] = Response1(Problem,Population,i,kneeDirction,option)
    switch option
        case 0              
            individual = Population(i).dec + kneeDirction;
            individual = min(max(individual,Problem.lower),Problem.upper);
        case 1
            sigma = kneeDirction./30;
            individual = Population(i).dec + kneeDirction + normrnd(kneeDirction,sigma);
            individual = min(max(individual,Problem.lower),Problem.upper);
    end
    x = Problem.Evaluation(individual);
    Population(i) = x;
end