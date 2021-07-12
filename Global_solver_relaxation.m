% Global solver relaxation

cvx_begin

    variable x(N,1)
    variable y(N,Number_of_subproblems)
    variable lambda(8+Max_number_of_splits,2*Number_of_subproblems) nonnegative
    dual variable z{2*Number_of_subproblems}
    dual variable v{2*Number_of_subproblems}
    variables F
    
    maximize(F)
    
    subject to
        
        for iterate_problem=1:Number_of_subproblems
            v{2*iterate_problem-1} : -(x+theta*y(:,iterate_problem))'*r_0 + lambda(:,2*iterate_problem-1)'*[p ; Extra_intercepts(:,iterate_problem)] <= -F;
            z{2*iterate_problem-1} : [P; Extra_hyperplanes(:,:,iterate_problem)]'*lambda(:,2*iterate_problem-1) == -0.5*Phi'*((x+theta*y(:,iterate_problem)).*r_0);
           
            v{2*iterate_problem} : (x+y(:,iterate_problem))'*c_0 + lambda(:,2*iterate_problem)'*[p ; Extra_intercepts(:,iterate_problem)] <= B;
            z{2*iterate_problem} : [P; Extra_hyperplanes(:,:,iterate_problem)]'*lambda(:,2*iterate_problem) == 0.5*Psi'*((x+y(:,iterate_problem)).*c_0);
            
            x+y(:,iterate_problem) <= ones(N,1);
        end
        
    x >= zeros(N,1);
    x <= ones(N,1);
    y >= zeros(N,Number_of_subproblems);
    y <= ones(N,Number_of_subproblems);
    
cvx_end