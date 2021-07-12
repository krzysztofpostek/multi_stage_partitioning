% Simulation_file

Short_results=[];
for iterate_simulation=1:N_simulations
    risk_realized=Risk_table(:,iterate_simulation);
    Allowed_or_not=ones(1,Number_of_subproblems_S);
    for variant=1:Number_of_subproblems_S
        if(prod(Extra_hyperplanes_S(:,:,variant)*risk_realized- Extra_intercepts_S(:,variant) <= 0 ) < 1)
            Allowed_or_not(variant)=0;
        end
    end
    variant=max(Allowed_or_not.*[1:Number_of_subproblems_S]);
    
    obj_static=(x_static+theta*y_static)'*r_0+0.5*(Phi'*((x_static+theta*y_static).*r_0))'*risk_realized;
    obj_S=(x_S+theta*y_S(:,variant))'*r_0+0.5*(Phi'*((x_S+theta*y_S(:,variant)).*r_0))'*risk_realized;
    
    Short_results=[Short_results ; obj_static obj_S];
end
Simulation_results(:,:,iterate_instance,N/5) = Short_results;