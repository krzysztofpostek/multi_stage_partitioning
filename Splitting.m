% Scenario extraction, splitting, etc.
k=Number_of_subproblems;

    for iterate_problem=1:k
        Critical_scenarios_single_problem=[];
        
        for t=1:(3*T-2)
            if(abs(eta{(iterate_problem-1)*(3*T-2)+t})>0.01)
                Critical_scenarios_single_problem = [Critical_scenarios_single_problem v{(iterate_problem-1)*(3*T-2)+t}/eta{(iterate_problem-1)*(3*T-2)+t}];
            end
        end
        
        Choosing_the_T;
        Splitting_of_the_subproblem;
        Adding_lower_bound_scenarios;
    end