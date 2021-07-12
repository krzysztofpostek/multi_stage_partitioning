Nb_of_instances=50;
N_simulations=500;
Risk_table=2*(rand(4,N_simulations)-0.5);
Simulation_results=zeros(N_simulations,2,Nb_of_instances,6);
Results_objectives_start=zeros(Nb_of_instances,6);
Results_objectives_end=zeros(Nb_of_instances,6);
Results_lowerbounds_start=zeros(Nb_of_instances,6);
Results_lowerbounds_end=zeros(Nb_of_instances,6);
Results_times=zeros(Nb_of_instances,6);

for iterate_instance=1:Nb_of_instances
    for N=5:5:30
    Max_number_of_splits=floor(10-floor(N/11)*2);
        clearvars -except Simulation_results Risk_table N_simulations Nb_of_instances N Results_objectives_start Results_objectives_end Results_lowerbounds_start Results_lowerbounds_end Results_times iterate_instance Max_number_of_splits N
        tic
        Data_setter;
        
        for iterate_splitting_round=1:Max_number_of_splits
            if((iterate_splitting_round==1))
                cvx_solver_settings('MIPGap',0.0001)
                Global_solver;
                Results_objectives_start(iterate_instance,N/5) = cvx_optval;
                x_static=x;
                y_static=y;
            end
            if((iterate_splitting_round==Max_number_of_splits))
                cvx_solver_settings('MIPGap',0.005)
                Global_solver;
                Results_objectives_end(iterate_instance,N/5) = cvx_optval;
                x_S=x;
                y_S=y;
                Extra_hyperplanes_S = Extra_hyperplanes;
                Extra_intercepts_S = Extra_intercepts;
                Number_of_subproblems_S = Number_of_subproblems;
            end
            Global_solver_relaxation;
            Splitting;
            if((iterate_splitting_round==1))
                cvx_solver_settings('MIPGap',0.0001)
                Lower_bound;
                Results_lowerbounds_start(iterate_instance,N/5) = cvx_optval;
            end
            if((iterate_splitting_round==Max_number_of_splits))
                cvx_solver_settings('MIPGap',0.005)
                Lower_bound;
                Results_lowerbounds_end(iterate_instance,N/5) = cvx_optval;
            end
        end
        
        Results_times(iterate_instance,N/5)=toc;
        Simulation;
    end
    save('10_8_6_splits50instancesSprec0001Eprec005.mat')
end