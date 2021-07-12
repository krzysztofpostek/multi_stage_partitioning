
    cvx_solver Gurobi;
    N_range = [20:5:50];
    B_range = [3 6];

    Nb_of_problem_instances = 10;
    %Initial_table = zeros(Nb_of_problem_instances,length(N_range));
    %Final_table = zeros(Nb_of_problem_instances,length(N_range));
    %Lower_bound_table = zeros(Nb_of_problem_instances,length(N_range));
    %Verification_table = zeros(Nb_of_problem_instances,length(N_range));

    %Time_table = zeros(Nb_of_problem_instances,length(N_range));

    for iterate_instance = 1:40
        for iterate_B = 1:2
            for iterate_N = 1:7
                
                if(Final_table(iterate_instance,iterate_N,iterate_B) <= 1 )

                        % Refined solving
                        found = 0;

                        while(found  == 0)

                            Data_setting;
                            cvx_clear;
                            cvx_solver_settings('TimeLimit',10);
                            cvx_clear;
                            TimeMax = 90;
                            timerID = tic;
                            Initialize_variables;
                            Solver_binary_smarter;

                            if((cvx_optval < Inf) && (cvx_optval > 0))
                                found =1;
                            end

                        end

                        Initial_table(iterate_instance,iterate_N,iterate_B) = Problem_optimum;
                        Final_table(iterate_instance,iterate_N,iterate_B) = Problem_optimum;


                        while(toc(timerID) < TimeMax)

                                Solver_binary_smarter;
                                Final_table(iterate_instance,iterate_N,iterate_B) = min(Problem_optimum,Final_table(iterate_instance,iterate_N,iterate_B));
                                finding_worst_case_scenarios_Dick;
                                splitting;

                        end

                        cvx_clear;
                        cvx_solver_settings('TimeLimit',60);
                        Solver_binary_variables;
                        Time_table(iterate_instance,iterate_N,iterate_B) = toc(timerID);

                        Verification;

                        if(count == 10^4)
                            Verification_table(iterate_instance,iterate_N,iterate_B) = 1;
                        end

                        Final_table(iterate_instance,iterate_N,iterate_B) = min(Problem_optimum,Final_table(iterate_instance,iterate_N,iterate_B));

                        if(Final_table(iterate_instance,iterate_N,iterate_B) == 0)
                            break;
                        end

                        Lower_bounds;
                        Lower_bound_table(iterate_instance,iterate_N,iterate_B) = cvx_optval;

                        %save(strcat(['Results.mat']));
                    
                end

            end
        end

    end