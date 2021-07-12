% Splitting the uncertainty subsets

New_number_of_problems = Number_of_subsets;
margin = 0.05;

for iterate_subset = 1:Number_of_subsets
    
    if(Worst_case_values(iterate_subset) >= Problem_optimum-margin)
        
        SH_normal = Worst_case_scenarios(:,2*iterate_subset) -  Worst_case_scenarios(:,2*iterate_subset-1);
        SH_intercept = SH_normal'*(Worst_case_scenarios(:,2*iterate_subset) +  Worst_case_scenarios(:,2*iterate_subset-1))/2;
        
        A(Number_of_extra_constraints(iterate_subset)+1,:,iterate_subset) = SH_normal';
        b(Number_of_extra_constraints(iterate_subset)+1,iterate_subset) = SH_intercept;
        
        New_number_of_problems = New_number_of_problems + 1;
        
        A(1:Number_of_extra_constraints(iterate_subset),:,New_number_of_problems) = A(1:Number_of_extra_constraints(iterate_subset),:,iterate_subset);
        A(Number_of_extra_constraints(iterate_subset)+1,:,New_number_of_problems) = -SH_normal';
        
        b(1:Number_of_extra_constraints(iterate_subset),New_number_of_problems) = b(1:Number_of_extra_constraints(iterate_subset),iterate_subset);
        b(Number_of_extra_constraints(iterate_subset)+1,New_number_of_problems) = -SH_intercept;
        
        Number_of_extra_constraints(iterate_subset) = Number_of_extra_constraints(iterate_subset) + 1;
        Number_of_extra_constraints(New_number_of_problems) = Number_of_extra_constraints(iterate_subset);
    end
    
end

Number_of_subsets = New_number_of_problems;