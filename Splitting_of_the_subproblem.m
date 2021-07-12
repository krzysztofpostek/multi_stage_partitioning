

Critical_scenarios_single_problem_for_splitting = unique(0.0001*floor(Critical_scenarios_single_problem*10000)','rows')';

Number_of_scenarios_single_problem_for_splitting=size(Critical_scenarios_single_problem_for_splitting);
Number_of_scenarios_single_problem_for_splitting=Number_of_scenarios_single_problem_for_splitting(2);

if(Number_of_scenarios_single_problem_for_splitting > 1)
    max_dispersion=0;
    for first_candidate=1:Number_of_scenarios_single_problem_for_splitting-1
        for second_candidate=first_candidate+1:Number_of_scenarios_single_problem_for_splitting
            if(norm(Critical_scenarios_single_problem_for_splitting(1:splitting_T,first_candidate)-Critical_scenarios_single_problem_for_splitting(1:splitting_T,second_candidate),2) > max_dispersion)
                first_scenario=first_candidate;
                second_scenario=second_candidate;
                max_dispersion=norm(Critical_scenarios_single_problem_for_splitting(1:splitting_T,first_candidate)-Critical_scenarios_single_problem_for_splitting(1:splitting_T,second_candidate),2);                
            end
            
        end
    end
    
    if(max_dispersion >0)
        slope=[Critical_scenarios_single_problem_for_splitting(1:splitting_T,first_scenario)-Critical_scenarios_single_problem_for_splitting(1:splitting_T,second_scenario); zeros(T-splitting_T,1)];
        intercept=slope'*0.5*(Critical_scenarios_single_problem_for_splitting(:,first_scenario)+Critical_scenarios_single_problem_for_splitting(:,second_scenario));
        Extra_hyperplanes(Number_of_splits(iterate_problem)+1,:,iterate_problem)=slope;
        Extra_hyperplanes(1:Number_of_splits(iterate_problem)+1,:,Number_of_subproblems+1)=Extra_hyperplanes(1:Number_of_splits(iterate_problem)+1,:,iterate_problem);
        Extra_hyperplanes(Number_of_splits(iterate_problem)+1,:,Number_of_subproblems+1)=-slope;
        Extra_intercepts(Number_of_splits(iterate_problem)+1,iterate_problem)=intercept;
        Extra_intercepts(1:Number_of_splits(iterate_problem)+1,Number_of_subproblems+1) = Extra_intercepts(1:Number_of_splits(iterate_problem)+1,iterate_problem);
        Extra_intercepts(Number_of_splits(iterate_problem)+1,Number_of_subproblems+1) = -intercept;
        
        Equality_constraints=[Equality_constraints; iterate_problem Number_of_subproblems+1 splitting_T-1];
        Number_of_equality_constraints=Number_of_equality_constraints+1;
        Highest_splitted_period(iterate_problem)=splitting_T;
        Highest_splitted_period(Number_of_subproblems+1)=splitting_T;
    
        Timing_of_extra_hyperplanes(Number_of_splits(iterate_problem)+1,iterate_problem)=splitting_T;
        Timing_of_extra_hyperplanes(1:Number_of_splits(iterate_problem)+1,Number_of_subproblems+1) = Timing_of_extra_hyperplanes(1:Number_of_splits(iterate_problem)+1,iterate_problem);
    
        Number_of_splits(iterate_problem)=Number_of_splits(iterate_problem)+1;
        Number_of_splits(Number_of_subproblems+1)=Number_of_splits(iterate_problem);
        Number_of_subproblems=Number_of_subproblems+1;
    end
end