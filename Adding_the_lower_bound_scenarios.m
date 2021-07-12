Distances_from_the_remaining_scenarios=[];
Outside_convex_hull_or_not=zeros(Number_of_scenarios_single_problem_for_splitting,1);

if(Number_of_lower_bound_scenarios>0)
    for iterate_potential_new_scenario=1:Number_of_scenarios_single_problem_for_splitting
        cvx_begin
            variable f(Number_of_lower_bound_scenarios,1);
        
            minimize(norm(Lower_bound_scenarios*f-Critical_scenarios_for_subproblem(:,iterate_potential_new_scenario),1) )
        
            subject to
                f>=0;
                sum(f)==1;    
        cvx_end
    
        if(cvx_optval > 10^-4)
            Outside_convex_hull_or_not(iterate_potential_new_scenario)=1;
            Distances_from_the_remaining_scenarios=[Distances_from_the_remaining_scenarios norm(Lower_bound_scenarios-kron(ones(1,Number_of_lower_bound_scenarios),Critical_scenarios_for_subproblem(:,iterate_potential_new_scenario)),'fro')];        
        end
    end
else
    Outside_convex_hull_or_not=ones(Number_of_scenarios_single_problem_for_splitting,1);
    Distances_from_the_remaining_scenarios=ones(Number_of_scenarios_single_problem_for_splitting,1);
end

Critical_scenarios_for_subproblem = Critical_scenarios_for_subproblem(:,logical(Outside_convex_hull_or_not));
[Distances_from_the_remaining_scenarios, ranks] = sort(Distances_from_the_remaining_scenarios,'descend');
Critical_scenarios_for_subproblem = Critical_scenarios_for_subproblem(:,ranks);
Number_of_scenarios_single_problem_for_splitting = sum(Outside_convex_hull_or_not);

Lower_bound_scenarios = [Lower_bound_scenarios Critical_scenarios_for_subproblem(:,1:min(Number_of_scenarios_single_problem_for_splitting,Max_allowed_scenarios_extra))];
Number_of_lower_bound_scenarios = size(Lower_bound_scenarios);
Number_of_lower_bound_scenarios=Number_of_lower_bound_scenarios(2);