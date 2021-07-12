cvx_begin
    variable x(N,1) binary
    variable y(N,Number_of_lower_bound_scenarios) binary
    variable lambda(8+Max_number_of_splits,2*Number_of_lower_bound_scenarios) nonnegative
    variables F
    
    maximize(F)
    
    subject to
        
        for iterate_scenario=1:Number_of_lower_bound_scenarios
            -(x+theta*y(:,iterate_scenario))'*r_0 -(0.5*Phi'*((x+theta*y(:,iterate_scenario)).*r_0))'*Lower_bound_scenarios(:,iterate_scenario) <=-F;
            
            (x+y(:,iterate_scenario))'*c_0 + (0.5*Psi'*((x+y(:,iterate_scenario)).*c_0))'*Lower_bound_scenarios(:,iterate_scenario) <= B;
            
            x+y(:,iterate_scenario) <= ones(N,1);
        end
    
cvx_end