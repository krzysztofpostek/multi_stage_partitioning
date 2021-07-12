% Finding the worst_case scenarios

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
    
    cvx_begin
    
        variable zeta(Number_of_arcs,1)
        minimize(zeta'*((x(:,iterate_subset)).*Distances))
        
        subject to
        
            zeta <= u;
            zeta >= l;
            A(:,:,iterate_subset)*zeta <= b(:,iterate_subset);
    
    cvx_end
    
    Worst_case_scenarios(:,2*iterate_subset) = zeta;
end