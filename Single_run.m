N=3;
Max_number_of_splits=5;
Nb_of_instances=50;
N_simulations=500;
Big_data_setter;
Big_simulated_results=zeros(N_simulations,4,Nb_of_instances,5);

Results_objectives_start=zeros(Nb_of_instances,5);
Results_objectives_end=zeros(Nb_of_instances,5);
Results_lowerbounds_start=zeros(Nb_of_instances,5);
Results_lowerbounds_end=zeros(Nb_of_instances,5);
Results_times=zeros(Nb_of_instances,5);

Results_objectives_start_withoutLDR=zeros(Nb_of_instances,5);
Results_objectives_end_withoutLDR=zeros(Nb_of_instances,5);
Results_lowerbounds_start_withoutLDR=zeros(Nb_of_instances,5);
Results_lowerbounds_end_withoutLDR=zeros(Nb_of_instances,5);
Results_times_withoutLDR=zeros(Nb_of_instances,5);

for iterate_instance=1:Nb_of_instances
    for T=6:2:10
        clearvars -except Big_simulated_results N_simulations Simulationmatrix c_xM c_bM cynM lM uM x_totM N Exact_lower_bounds Results_times_withoutLDR Results_lowerbounds_end_withoutLDR Results_lowerbounds_start_withoutLDR Results_objectives_end_withoutLDR Results_objectives_start_withoutLDR T Max_number_of_splits Results_objectives_end Results_objectives_start Results_lowerbounds_start Results_lowerbounds_end Results_times iterate_instance Nb_of_instances
        tic
        Data_setter;
        Data_preprocessing;
        
        %% Now comes the moment without LDR
        cvx_solver_settings('MIPGap',0.001);
        Global_solverX;
        x_static=x;
        y_static=y;
        Results_objectives_start_withoutLDR(iterate_instance,T/2) = cvx_optval;
        
        for iterate_splitting_round=1:Max_number_of_splits
            if(iterate_splitting_round==Max_number_of_splits)
                cvx_solver_settings('MIPGap',0.01);
                Global_solverX;
                Results_objectives_end_withoutLDR(iterate_instance,T/2) = cvx_optval;
                x_S=x;
                y_S=y;
                Extra_hyperplanes_S=Extra_hyperplanes;
                Extra_intercepts_S=Extra_intercepts;
                Number_of_subproblems_S=Number_of_subproblems;
            end
            Global_solver_relaxationX;
            SplittingX;
            if((iterate_splitting_round==1))
                cvx_solver_settings('MIPGap',0.001);
                Lower_boundX;
                Results_lowerbounds_start_withoutLDR(iterate_instance,T/2) = cvx_optval;
            end
            if(iterate_splitting_round==Max_number_of_splits)
                cvx_solver_settings('MIPGap',0.001);
                Lower_boundX;
                Results_lowerbounds_end_withoutLDR(iterate_instance,T/2) = cvx_optval;
            end
        end
        
        Results_times_withoutLDR(iterate_instance,T/2)=toc;
        
        %% Now comes the moment with LDR
        clearvars -except Big_simulated_results N_simulations Number_of_subproblems_S Simulationmatrix x_S y_S Extra_hyperplanes_S Extra_intercepts_S x_static y_static Exact_lower_bounds c_xM c_bM cynM lM uM x_totM I_1 N x_tot l u q cyn c_x c_b Results_times_withoutLDR Results_lowerbounds_end_withoutLDR Results_lowerbounds_start_withoutLDR Results_objectives_end_withoutLDR Results_objectives_start_withoutLDR T Max_number_of_splits Results_objectives_end Results_objectives_start Results_lowerbounds_start Results_lowerbounds_end Results_times iterate_instance Nb_of_instances
        tic
        Data_preprocessing;
        
        cvx_solver_settings('MIPGap',0.001);
        Global_solver;
        Results_objectives_start(iterate_instance,T/2) = cvx_optval;
        y_LDR=y;
        LDR_LDR=LDR;
        
        for iterate_splitting_round=1:Max_number_of_splits
            if(iterate_splitting_round==Max_number_of_splits)
                cvx_solver_settings('MIPGap',0.01);
                Global_solver;
                Results_objectives_end(iterate_instance,T/2) = cvx_optval;
                LDR_S_and_LDR=LDR;
                y_S_and_LDR=y;
                Extra_hyperplanes_S_and_LDR=Extra_hyperplanes;
                Extra_intercepts_S_and_LDR=Extra_intercepts;
                Number_of_subproblems_S_and_LDR=Number_of_subproblems;
                Timing_of_extra_hyperplanes_S_and_LDR=Timing_of_extra_hyperplanes;
            end
            Global_solver_relaxation;
            Splitting;
            if(iterate_splitting_round==1)
                cvx_solver_settings('MIPGap',0.001);
                Lower_bound;
                Results_lowerbounds_start(iterate_instance,T/2) = cvx_optval;
            end
            if(iterate_splitting_round==Max_number_of_splits)
                cvx_solver_settings('MIPGap',0.001);
                Lower_bound;
                Results_lowerbounds_end(iterate_instance,T/2) = cvx_optval;
            end
        end
        
        Results_times(iterate_instance,T/2)=toc;
        
        Simulation_total;
    end
    save('N3_50instances_with_500simulations5splits_corrected.mat');
end