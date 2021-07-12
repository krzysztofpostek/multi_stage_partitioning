% Simulation global file 

% Preparation of data
Results_static=[];
Results_LDR=[];
Results_S=[];
Results_S_and_LDR=[];

for iterate_simulation=1:N_simulations
    demand_realized=l+Simulationmatrix(1:T,iterate_simulation).*(u-l);
    
    % Static solution
    obj=(T-1)*c_b*I_1 + Objective_x'*x_static +  Objective_y_holding_cost'*y_static + sum(max(kron(ones(1,T-1),cumsum([0; cyn(1:N-1)])) + q*kron(ones(1,T-1),cyn).*(kron(ones(N,1),y_static')-kron(ones(1,T-1),[0:N-1]')) )) + Objective_xi'*demand_realized;
    Results_static=[Results_static; obj];
    
    
    % Only splitting solution
    Allowed_or_not=ones(1,Number_of_subproblems_S);
    
    for variant=1:Number_of_subproblems_S
           if(prod(double(Extra_hyperplanes_S(:,:,variant)*demand_realized <= Extra_intercepts_S(:,variant)))<1)
                 Allowed_or_not(variant)=0;
           end
    end
    
    variant=max(Allowed_or_not.*[1:Number_of_subproblems_S]);
    obj=(T-1)*c_b*I_1 + Objective_x'*x_S(:,variant) +  Objective_y_holding_cost'*y_S(:,variant) + sum(max(kron(ones(1,T-1),cumsum([0; cyn(1:N-1)])) + q*kron(ones(1,T-1),cyn).*(kron(ones(N,1),y_S(:,variant)')-kron(ones(1,T-1),[0:N-1]')) ))  +Objective_xi'*demand_realized;
    Results_S = [Results_S; obj];
    
    % Only linear decision_rules_solution
    obj=(T-1)*c_b*I_1 +  Objective_y_holding_cost'*y_LDR + sum(max(kron(ones(1,T-1),cumsum([0; cyn(1:N-1)])) + q*kron(ones(1,T-1),cyn).*(kron(ones(N,1),y_LDR')-kron(ones(1,T-1),[0:N-1]')) )) +(Objective_xi+sum( (Matrix_LDR_objective_multipliers.*LDR_LDR),2 ) )'*demand_realized;
    Results_LDR = [Results_LDR; obj];
    
    % Combined solution
    Allowed_or_not=ones(1,Number_of_subproblems_S_and_LDR);
    
    for variant=1:Number_of_subproblems_S_and_LDR
           if(prod(double(Extra_hyperplanes_S_and_LDR(:,:,variant)*demand_realized <= Extra_intercepts_S_and_LDR(:,variant)))<1)
                 Allowed_or_not(variant)=0;
           end
    end
    
    variant=max(Allowed_or_not.*[1:Number_of_subproblems_S_and_LDR]);
    obj=(T-1)*c_b*I_1 + Objective_y_holding_cost'*y_S_and_LDR(:,variant) + sum(max(kron(ones(1,T-1),cumsum([0; cyn(1:N-1)])) + q*kron(ones(1,T-1),cyn).*(kron(ones(N,1),y_S_and_LDR(:,variant)')-kron(ones(1,T-1),[0:N-1]')) ))  +(Objective_xi+sum( (Matrix_LDR_objective_multipliers.*LDR_S_and_LDR(:,:,variant)),2 ) )'*demand_realized;
    Results_S_and_LDR = [Results_S_and_LDR; obj];
end

Big_simulated_results(:,:,iterate_instance,T/2)=[Results_static Results_LDR Results_S Results_S_and_LDR];