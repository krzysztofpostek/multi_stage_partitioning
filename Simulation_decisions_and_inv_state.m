% Simulation global file 

% Preparation of data
Results_static=[];
Results_LDR=[];
Results_S=[];
Results_S_and_LDR=[];
Decisions=[];
Inventory_state=[];

for iterate_simulation=1:N_simulations
    demand_realized=l+Simulationmatrix(1:T,iterate_simulation).*(u-l);
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
    Decisions=[Decisions ; demand_realized'*LDR_S_and_LDR(:,:,variant)];
    for t=1:T-1
        Inventory_state(iterate_simulation,t) = -I_1-sum(y_S_and_LDR(1:t,variant)*q) +  ([ones(t+1,1) ; zeros(T-t-1,1)] -sum(LDR_S_and_LDR(:,1:t,variant),2))'*demand_realized;
    end
end

Big_simulated_results(:,:,iterate_instance,T/2)=[Results_static Results_LDR Results_S Results_S_and_LDR];


for iterate_simulation=1:N_simulations
    demand_realized=l+Simulationmatrix(1:T,iterate_simulation).*(u-l);
    % Combined solution
    Allowed_or_not=ones(T,Number_of_subproblems_S_and_LDR);
    
    for variant=1:Number_of_subproblems_S_and_LDR
        for t=1:T
           if(prod(double(Extra_hyperplanes_S_and_LDR(Timing_of_extra_hyperplanes(:,variant) <= t,:,variant)*demand_realized <= Extra_intercepts_S_and_LDR(Timing_of_extra_hyperplanes(:,variant) <= t,variant)))<1)
                 Allowed_or_not(t,variant)=0;
           end
        end
    end
end