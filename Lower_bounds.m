% Lower bound computation

Worst_case_scenarios = Worst_case_scenarios(:,1:2:size(Worst_case_scenarios,2)-1);


cvx_begin
    variable x(Number_of_arcs,size(Worst_case_scenarios,2)) binary
    variable objective
    
    minimize(objective)
    subject to
    
        % Objective function constraints
        
        for iterate_scenario = 1:size(Worst_case_scenarios,2)
            x(:,iterate_scenario)'*Distances + 0.5* ( x(:,iterate_scenario)'*(Distances.*Worst_case_scenarios(:,iterate_scenario)) ) <= objective;            
        end
        
        % Feasibility constraint
    
        for iterate_scenario = 1:size(Worst_case_scenarios,2)
            for iterate_vertex = 1:N
                
                if(sum(OUT_arcs_that_stay == iterate_vertex)+sum(IN_arcs_that_stay == iterate_vertex) > 0) % Condition if there are any arcs going to a given vertex
                    sum(x(OUT_arcs_that_stay' == iterate_vertex,iterate_scenario)) >= sum(x(IN_arcs_that_stay' == iterate_vertex,iterate_scenario)) + (iterate_vertex == s) - (iterate_vertex == t);
                end
                
            end
        end
        
        

cvx_end

