% This is the binary solver

cvx_begin
    variable x(Number_of_arcs,Number_of_subsets) binary
    variable objective
    variable lambda_U(Number_of_arcs,Number_of_subsets) nonnegative
    variable mhu(max(Number_of_extra_constraints),Number_of_subsets) nonnegative
    
    minimize(objective)
    subject to
    
        % Objective function constraints
        
        for iterate_subset = 1:Number_of_subsets
            
            x(:,iterate_subset)'*Distances + ( lambda_U(:,iterate_subset)'*u + mhu(:,iterate_subset)'*b(:,iterate_subset) ) <= objective;
            
            0.5*x(:,iterate_subset).*Distances - lambda_U(:,iterate_subset) - A(:,:,iterate_subset)'*mhu(:,iterate_subset) <= 0;
            
        end
        
        % Feasibility constraint
    
        for iterate_subset = 1:Number_of_subsets
            for iterate_vertex = 1:N
                
                if(sum(OUT_arcs_that_stay == iterate_vertex)+sum(IN_arcs_that_stay == iterate_vertex) > 0) % Condition if there are any arcs going to a given vertex
                    sum(x(OUT_arcs_that_stay' == iterate_vertex,iterate_subset)) >= sum(x(IN_arcs_that_stay' == iterate_vertex,iterate_subset)) + (iterate_vertex == s) - (iterate_vertex == t);
                end
                
            end
        end

cvx_end

Problem_optimum = cvx_optval;