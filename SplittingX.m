% Scenario extraction, splitting, etc.
k=Number_of_subproblems;

    for iterate_problem=1:k
        Critical_scenarios_single_problem=[];
        
        for t=1:T
            if(abs(v{(iterate_problem-1)*T+t})>0.01)
                Critical_scenarios_single_problem = [Critical_scenarios_single_problem eta{(iterate_problem-1)*T+t}/v{(iterate_problem-1)*T+t}];
            end
        end
        
        Choosing_the_TX
        Splitting_of_the_subproblemX
        Adding_lower_bound_scenariosX;
    end