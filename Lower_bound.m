Lower_bound_scenarios=Sort_lexicographically(floor(Lower_bound_scenarios*10^4)/10^4);
Lower_bound_equality_constraints=[];

    for i=1:Number_of_lower_bound_scenarios-1
        Little_less_t=1;
        for t=1:T
            if(prod(double(Lower_bound_scenarios(1:t,i)==Lower_bound_scenarios(1:t,i+1)))>0)
                Little_less_t=t;
            end
        end
        Lower_bound_equality_constraints=[Lower_bound_equality_constraints Little_less_t];
    end

cvx_begin
    variable x(T-1,Number_of_lower_bound_scenarios) 
    variable y((T-1),Number_of_lower_bound_scenarios) integer
    variable Objective_y_ordering_cost(T-1,Number_of_lower_bound_scenarios)
    variable cost
    
    minimize(cost)
    subject to
    % Constraints
    
    for iterate_problem=1:Number_of_lower_bound_scenarios
        
        % Objective function
        (T-1)*c_b*I_1 + Objective_x'*x(:,iterate_problem) + Objective_y_holding_cost'*y(:,iterate_problem) + sum(Objective_y_ordering_cost(:,iterate_problem)) + Objective_xi'*Lower_bound_scenarios(:,iterate_problem) <= cost;
        
        % The y ordering cost
        for t=1:T-1
            max(cumsum([0; cyn(1:N-1)]) + q*cyn.*(y(t,iterate_problem)-[0:N-1]') ) <= Objective_y_ordering_cost(t,iterate_problem);
        end
        
        % Nonnegativity of the inventory state
        for t=1:T-1
            -sum(x(1:t,iterate_problem))-I_1-sum(y(1:t,iterate_problem)*q) + [ones(t+1,1); zeros(T-1-t,1)]'*Lower_bound_scenarios(:,iterate_problem) <=0;
        end
        
        % Total on x
        cumsum(x(:,iterate_problem)) <= x_tot;
    end
    
    % Equality constraints
    for i=1:Number_of_lower_bound_scenarios-1
        x(1:min(Lower_bound_equality_constraints(i),T-1),i)==x(1:min(Lower_bound_equality_constraints(i),T-1),i+1);
        if(Lower_bound_equality_constraints(i)>1)
            y(1:(Lower_bound_equality_constraints(i)-1),i) == y(1:(Lower_bound_equality_constraints(i)-1),i+1);
        end
    end
    
    y <= N*ones((T-1),Number_of_lower_bound_scenarios);
    y >= zeros((T-1),Number_of_lower_bound_scenarios);
    x >= zeros(T-1,Number_of_lower_bound_scenarios);    
cvx_end