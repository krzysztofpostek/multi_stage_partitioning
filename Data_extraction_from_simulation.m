Simulated_improvement_means=zeros(N_simulations,4,T,N);

    for iter_T=1:5
        for iter_instance=1:20
            Simulated_improvement_means(:,1,iter_instance,iter_T) = (Big_simulated_results(:,1,iter_instance,iter_T)-Big_simulated_results(:,1,iter_instance,iter_T))./Big_simulated_results(:,1,iter_instance,iter_T);
            Simulated_improvement_means(:,2,iter_instance,iter_T) = (Big_simulated_results(:,2,iter_instance,iter_T)-Big_simulated_results(:,1,iter_instance,iter_T))./Big_simulated_results(:,1,iter_instance,iter_T);
            Simulated_improvement_means(:,3,iter_instance,iter_T) = (Big_simulated_results(:,3,iter_instance,iter_T)-Big_simulated_results(:,1,iter_instance,iter_T))./Big_simulated_results(:,1,iter_instance,iter_T);
            Simulated_improvement_means(:,4,iter_instance,iter_T) = (Big_simulated_results(:,4,iter_instance,iter_T)-Big_simulated_results(:,1,iter_instance,iter_T))./Big_simulated_results(:,1,iter_instance,iter_T);
        end
    end

Simulated_improvement_means=mean(Simulated_improvement_means,1);
Simulated_improvement_means=mean(Simulated_improvement_means,3)*100;

Simulated_improvement_means=-reshape(Simulated_improvement_means,[4 5])';

Simulated_improvement_stddev=zeros(N_simulations,4,T,N);

    for iter_T=1:5
        for iter_instance=1:20
            Simulated_improvement_stddev(:,1,iter_instance,iter_T) = (Big_simulated_results(:,1,iter_instance,iter_T));
            Simulated_improvement_stddev(:,2,iter_instance,iter_T) = (Big_simulated_results(:,2,iter_instance,iter_T));
            Simulated_improvement_stddev(:,3,iter_instance,iter_T) = (Big_simulated_results(:,3,iter_instance,iter_T));
            Simulated_improvement_stddev(:,4,iter_instance,iter_T) = (Big_simulated_results(:,4,iter_instance,iter_T));
        end
    end

Simulated_improvement_stddev=std(Simulated_improvement_stddev,1);
Simulated_improvement_stddev=mean(Simulated_improvement_stddev,3)*100;

Simulated_improvement_stddev=reshape(Simulated_improvement_stddev,[4 5])';

Simulated_improvement_stddev_relative=(kron(ones(1,4),Simulated_improvement_stddev(:,1)) - Simulated_improvement_stddev)./kron(ones(1,4),Simulated_improvement_stddev(:,1))*100;
