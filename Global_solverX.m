cvx_begin
    variable x(T-1,Number_of_subproblems) nonnegative
    variable y((T-1),Number_of_subproblems) integer
    variable lambda(2*T+Max_number_of_splits,T*Number_of_subproblems) nonnegative
    variable Objective_y_ordering_cost(T-1,Number_of_subproblems)
    variable cost
    
    minimize cost
    subject to
    % Constraints
    for iterate_problem=1:Number_of_subproblems
        
        % Objective function
        (T-1)*c_b*I_1 + Objective_x'*x(:,iterate_problem) + Objective_y_holding_cost'*y(:,iterate_problem) + sum(Objective_y_ordering_cost(:,iterate_problem)) + sum([p; Extra_intercepts(:,iterate_problem)].*lambda(:,T*(iterate_problem-1)+1))<= cost;
        [P ; Extra_hyperplanes(:,:,iterate_problem)]'*lambda(:,T*(iterate_problem-1)+1) >= Objective_xi;
        
        % The y ordering cost
        for t=1:T-1
            max(cumsum([0; cyn(1:N-1)]) + q*cyn.*(y(t,iterate_problem)-[0:N-1]') ) <= Objective_y_ordering_cost(t,iterate_problem);
        end
        
        % Nonnegativity of the inventory state
        for t=1:T-1
            -sum(x(1:t,iterate_problem))-I_1-sum(y(1:t,iterate_problem)*q)  + sum(lambda(:,T*(iterate_problem-1)+1+t).*[p ;Extra_intercepts(:,iterate_problem)]) <=0;
            [P ; Extra_hyperplanes(:,:,iterate_problem)]'*lambda(:,T*(iterate_problem-1)+1+t) >= [ones(t+1,1) ; zeros(T-t-1,1)];
        end
        
        % Total on x
        cumsum(x(:,iterate_problem)) <= x_tot;
    end
    
    % Equality constraints
    for iterate_equality_constraint=1:Number_of_equality_constraints
        x(timing_of_variables_x<=Equality_constraints(iterate_equality_constraint,3),Equality_constraints(iterate_equality_constraint,1)) == x(timing_of_variables_x<=Equality_constraints(iterate_equality_constraint,3),Equality_constraints(iterate_equality_constraint,2));
        y(timing_of_variables_y<=Equality_constraints(iterate_equality_constraint,3),Equality_constraints(iterate_equality_constraint,1)) == y(timing_of_variables_y<=Equality_constraints(iterate_equality_constraint,3),Equality_constraints(iterate_equality_constraint,2));
    end
    
    y >= zeros((T-1),Number_of_subproblems);
    y <= N*ones((T-1),Number_of_subproblems);
cvx_end
