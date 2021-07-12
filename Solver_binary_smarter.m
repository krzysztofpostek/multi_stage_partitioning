% Solver binary - separate for each subset

% This is the binary solver
x = zeros(Number_of_arcs,Number_of_subsets);
Problem_optimum = 0;

for iterate_subset = 1:Number_of_subsets
    
    cvx_solver Gurobi

    cvx_begin
        variable x_var(Number_of_arcs,1) binary
        variable objective
        variable lambda_U(Number_of_arcs,1) nonnegative
        variable lambda_L(Number_of_arcs,1) nonnegative
        variable mhu(size(A,1),1) nonnegative

        minimize(objective)
        subject to

            % Objective function constraints

                x_var'*Distances + 0.5* ( lambda_U'*u - lambda_L'*l + mhu'*b(:,iterate_subset) ) <= objective;

                x_var.*Distances - lambda_U + lambda_L - A(:,:,iterate_subset)'*mhu == 0;


            % Feasibility constraint
                for iterate_vertex = 1:N

                    if(sum(OUT_arcs_that_stay == iterate_vertex) + sum(IN_arcs_that_stay == iterate_vertex) > 0) % Condition if there are any arcs going to a given vertex
                        sum(x_var(OUT_arcs_that_stay' == iterate_vertex)) >= sum(x_var(IN_arcs_that_stay' == iterate_vertex)) + (iterate_vertex == s) - (iterate_vertex == t);
                    end
                    
                end
    cvx_end
    
    x(:,iterate_subset) = x_var;
    Problem_optimum = max(Problem_optimum,cvx_optval);
    
end