% Global solver

cvx_begin
    variable x(N,1) binary
    variable y(N,Number_of_subproblems) binary
    variable lambda(8+Max_number_of_splits,2*Number_of_subproblems) nonnegative
    variables F
    
    maximize(F)
    
    subject to
        
        for iterate_problem=1:Number_of_subproblems
            -(x+theta*y(:,iterate_problem))'*r_0 + lambda(:,2*iterate_problem-1)'*[p ; Extra_intercepts(:,iterate_problem)] <= -F;
            [P; Extra_hyperplanes(:,:,iterate_problem)]'*lambda(:,2*iterate_problem-1) == -0.5*Phi'*((x+theta*y(:,iterate_problem)).*r_0);
            
            (x+y(:,iterate_problem))'*c_0 + lambda(:,2*iterate_problem)'*[p ; Extra_intercepts(:,iterate_problem)] <= B;
            [P; Extra_hyperplanes(:,:,iterate_problem)]'*lambda(:,2*iterate_problem) == 0.5*Psi'*((x+y(:,iterate_problem)).*c_0);
            
            x+y(:,iterate_problem) <= ones(N,1);
        end   
cvx_end