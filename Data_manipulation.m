%%% Script for working with the data

Improvements=mean((Results_objectives_end(1:25,:)-Results_objectives_start(1:25,:))./Results_objectives_start(1:25,:))*100;

Initial_optimality_gap= 0.5*100*mean((Results_lowerbounds_start-Results_objectives_start)./(Results_lowerbounds_start+Results_objectives_start));

Final_optimality_gap= 0.5*100*mean((Results_lowerbounds_end-Results_objectives_end)./(Results_lowerbounds_end+Results_objectives_end));

Mean_time=mean(Results_times);

Average_case_improvement=(Simulation_results(:,2,:,:) - Simulation_results(:,1,:,:))./Simulation_results(:,1,:,:)*100;
Average_case_improvement= mean(Average_case_improvement,1);
Average_case_improvement= mean(Average_case_improvement,3);
Average_case_improvement=reshape(Average_case_improvement,[6 1]);

Results_bigtable=[Improvements' Initial_optimality_gap' Final_optimality_gap' Average_case_improvement Mean_time']