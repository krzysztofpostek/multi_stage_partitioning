% Splitting
k=Number_of_subproblems;

for iterate_problem=1:k
   Critical_scenarios_for_subproblem=[];
   
   for iterate_constraint=1:2
       if(v{(iterate_problem-1)*2+iterate_constraint} > 10^-4)
           Critical_scenarios_for_subproblem = [Critical_scenarios_for_subproblem z{(iterate_problem-1)*2+iterate_constraint}/v{(iterate_problem-1)*2+iterate_constraint}];
       end
   end
   
   Splitting_a_single_problem;
   Adding_the_lower_bound_scenarios;
end