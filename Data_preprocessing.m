% Data_preprocessing


timing_of_variables_x=[1:(T-1)]';
timing_of_variables_y=[2:T]';

Objective_x=c_x+c_b*(T-[1:T-1]');
Objective_y_holding_cost=zeros((T-1),1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filling for y's

    for t=1:T-1
        Objective_y_holding_cost(t)=c_b*(T-t)*q;
    end

% filling for uncertain parameter
Objective_xi=zeros(T,1);

for t=1:T
    Objective_xi(t)=-(T+1-max(t,2))*c_b;
end

P=[eye(T) ; -eye(T)];
p=[u; -l];

Matrix_LDR_objective_multipliers=kron(ones(T,1),c_x+c_b*(T-[1:T-1]));

Extra_hyperplanes=zeros(Max_number_of_splits,T,1);
Extra_intercepts=zeros(Max_number_of_splits,1);
Number_of_subproblems=1;
Number_of_equality_constraints=0;
Equality_constraints=[];
Max_next_split=2;
Highest_splitted_period=1;
Number_of_splits=0;
Lower_bound_scenarios=[];
Number_of_lower_bound_scenarios=0;
Max_allowed_scenarios_extra=3;
Timing_of_extra_hyperplanes=zeros(Max_number_of_splits,1);