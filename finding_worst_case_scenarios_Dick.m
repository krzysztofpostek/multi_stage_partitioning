% Finding the worst_case scenarios
% Finding the second scenario

Worst_case_scenarios = zeros(Number_of_arcs,2*Number_of_subsets);
Worst_case_values = zeros(1,Number_of_subsets);

for iterate_subset = 1:Number_of_subsets
    
    % Finding the worst_case scenario
    
    cvx_begin
        variable zeta(Number_of_arcs,1)
        maximize(zeta'*(x(:,iterate_subset).*Distances))
        
        subject to
        
            zeta <= u;
            zeta >= l;
            A(:,:,iterate_subset)*zeta <= b(:,iterate_subset);
    
    cvx_end
    
    Worst_case_scenarios(:,2*iterate_subset - 1) = zeta;
    Worst_case_values(iterate_subset) = x(:,iterate_subset)'*Distances + 0.5*cvx_optval;
    
    % Finding the opposite scenario
    
    % Solve the problem with at most theta share of the arcs in the optimal
    % solution used
    
    if( Worst_case_values(iterate_subset) > Problem_optimum - 0.05)

        Arcs_indices = [1:Number_of_arcs]';
        Elements_of_the_optimal_path = Arcs_indices(x(:,iterate_subset) == 1);

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

                % Constraint that at most theta of the elements of the optimal
                % path are allowed to stay

                    sum(x_var(Elements_of_the_optimal_path)) <= floor(theta*length(Elements_of_the_optimal_path));

        cvx_end

        % Searching for the corresponding worst_case scenario
        
        if(cvx_optval < Inf)
            
            cvx_begin
                variable zeta(Number_of_arcs,1)
                maximize(zeta'*(x_var.*Distances))

                subject to

                    zeta <= u;
                    zeta >= l;
                    A(:,:,iterate_subset)*zeta <= b(:,iterate_subset);

            cvx_end
        
        else
            
                cvx_begin

                    variable zeta(Number_of_arcs,1)
                    minimize(zeta'*((x(:,iterate_subset)).*Distances))

                    subject to

                        zeta <= u;
                        zeta >= l;
                        A(:,:,iterate_subset)*zeta <= b(:,iterate_subset);

                cvx_end
                
        end

        Worst_case_scenarios(:,2*iterate_subset) = zeta;
    
    end

end

Problem_optimum  = max(Worst_case_values);