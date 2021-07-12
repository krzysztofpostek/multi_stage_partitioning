Critical_scenarios_for_subproblem = unique(0.0001*floor(Critical_scenarios_for_subproblem*10000)','rows')';

Number_of_scenarios_single_problem_for_splitting=size(Critical_scenarios_for_subproblem);
Number_of_scenarios_single_problem_for_splitting=Number_of_scenarios_single_problem_for_splitting(2);


if(Number_of_scenarios_single_problem_for_splitting > 1)
    slope=Critical_scenarios_for_subproblem(:,1)-Critical_scenarios_for_subproblem(:,2);
    intercept=slope'*(Critical_scenarios_for_subproblem(:,1)+Critical_scenarios_for_subproblem(:,2))/2;
    Extra_hyperplanes(Number_of_splits(iterate_problem)+1,:,iterate_problem)=slope;
    Extra_hyperplanes(1:Number_of_splits(iterate_problem)+1,:,Number_of_subproblems+1)=Extra_hyperplanes(1:Number_of_splits(iterate_problem)+1,:,iterate_problem);
    Extra_hyperplanes(Number_of_splits(iterate_problem)+1,:,Number_of_subproblems+1)=-slope;
    Extra_intercepts(Number_of_splits(iterate_problem)+1,iterate_problem)=intercept;
    Extra_intercepts(1:Number_of_splits(iterate_problem)+1,Number_of_subproblems+1) = Extra_intercepts(1:Number_of_splits(iterate_problem)+1,iterate_problem);
    Extra_intercepts(Number_of_splits(iterate_problem)+1,Number_of_subproblems+1) = -intercept;
    
    Number_of_splits(iterate_problem)=Number_of_splits(iterate_problem)+1;
    Number_of_splits(Number_of_subproblems+1)=Number_of_splits(iterate_problem);
    Number_of_subproblems=Number_of_subproblems+1;
end