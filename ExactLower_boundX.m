if(T==2)
    Matrix01=[0 0;0 1]';
elseif(T==4)
    Matrix01=[0 0 0 0;0 1 0 0;0 0 1 0;0 0 0 1;0  1 1 0;0 1 0 1;0 0 1 1;0 1 1 1]';
end

ExactLower_bound_scenarios = kron(ones(1,2^(T-1)),l) + Matrix01.*kron(ones(1,2^(T-1)),u-l);
ExactLower_bound_scenarios=Sort_lexicographically(floor(ExactLower_bound_scenarios*10^4)/10^4);
ExactNumber_of_lower_bound_scenarios=2^(T-1);

ExactLower_bound_equality_constraints=[];

    for i=1:ExactNumber_of_lower_bound_scenarios-1
        for t=1:T
            if(prod(double(ExactLower_bound_scenarios(1:t,i)==ExactLower_bound_scenarios(1:t,i+1)))>0)
                ExactLittle_less_t=t;
            end
        end
        ExactLower_bound_equality_constraints=[ExactLower_bound_equality_constraints ExactLittle_less_t];
    end

cvx_begin
    variable x(T-1,ExactNumber_of_lower_bound_scenarios) 
    variable y((T-1)*N,ExactNumber_of_lower_bound_scenarios) binary
    variable cost
    
    minimize(cost)
    subject to
    % Constraints
    
    for Exactiterate_problem=1:ExactNumber_of_lower_bound_scenarios
        
        % Objective function
        (T-1)*c_b*I_1 + Objective_x'*x(:,Exactiterate_problem) + Objective_y'*y(:,Exactiterate_problem) + Objective_xi'*ExactLower_bound_scenarios(:,Exactiterate_problem) <= cost;
        
        % Nonnegativity of the inventory state
        for t=1:T-1
            -sum(x(1:t,Exactiterate_problem))-I_1-sum(y(1:t*N,Exactiterate_problem).*q(1:t*N)) + [ones(t+1,1); zeros(T-1-t,1)]'*ExactLower_bound_scenarios(:,Exactiterate_problem) <=0;
        end
        
        % Total on x
        cumsum(x(:,Exactiterate_problem)) <= x_tot;
    end
    
    % Equality constraints
    for i=1:ExactNumber_of_lower_bound_scenarios-1
        x(1:min(ExactLower_bound_equality_constraints(i),T-1),i)==x(1:min(ExactLower_bound_equality_constraints(i),T-1),i+1);
        if(ExactLower_bound_equality_constraints(i)>1)
            y(1:(ExactLower_bound_equality_constraints(i)-1)*N,i) == y(1:(ExactLower_bound_equality_constraints(i)-1)*N,i+1);
        end
    end
    
    y <= ones((T-1)*N,ExactNumber_of_lower_bound_scenarios);
    y >= zeros((T-1)*N,ExactNumber_of_lower_bound_scenarios);
    x >= zeros(T-1,ExactNumber_of_lower_bound_scenarios);    
cvx_end