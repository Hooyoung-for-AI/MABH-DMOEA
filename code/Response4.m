function Population = Response4(PROBLEM,Population,i)
    if rand() <= 0.5
        Population = Gaussian_mutation(PROBLEM,Population(i).dec,PROBLEM.lower,PROBLEM.upper,Population,i);
    else
        Population = Polynomial_mutation(PROBLEM,Population(i).dec,1,PROBLEM.D,1,20,PROBLEM.lower,PROBLEM.upper,Population,i);
    end
end

%% Gaussian mutation
function Population = Gaussian_mutation(PROBLEM,pop_decs,lower,upper,Population,i)
    x=pop_decs;
   [len,dim]= size(x);
   sigma = (upper-lower)./20;
   prob=1/dim;
   newparam = min(max(normrnd(x, repmat(sigma,len,1)), repmat(lower,len,1)), repmat(upper,len,1));
   C = rand(len,dim)<prob;
   x(C) = newparam(C');
   X_dec=Boundary_Repair(x,lower,upper);
   x = PROBLEM.Evaluation(X_dec);
   Population(i) = x;  
end

%% Polynomial mutation
function Population=Polynomial_mutation(PROBLEM,pop_one_dec,N,D,proM,disM,Lower,Upper,Population,i)
   % Lower=repmat(Lower,N,1);
   % Upper=repmat(Upper,N,1);
    Site  = rand(N,D) < proM/D;
     mu    = rand(N,D);
    temp  = Site & mu<=0.5;
    pop_one_dec       = min(max(pop_one_dec,Lower),Upper);
    pop_one_dec(temp) = pop_one_dec(temp)+(Upper(temp)-Lower(temp)).*((2.*mu(temp)+(1-2.*mu(temp)).*...
                      (1-(pop_one_dec(temp)-Lower(temp))./(Upper(temp)-Lower(temp))).^(disM+1)).^(1/(disM+1))-1);
    temp = Site & mu>0.5; 
    pop_one_dec(temp) = pop_one_dec(temp)+(Upper(temp)-Lower(temp)).*(1-(2.*(1-mu(temp))+2.*(mu(temp)-0.5).*...
                      (1-(Upper(temp)-pop_one_dec(temp))./(Upper(temp)-Lower(temp))).^(disM+1)).^(1/(disM+1)));
    x = PROBLEM.Evaluation(pop_one_dec);
    Population(i) = x;             
end

