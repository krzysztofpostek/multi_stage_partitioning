% Creating the table with results

Results_bigtable=zeros(5,9);

% Mean improvements for the LDR
Results_bigtable(:,1)=mean((Results_objectives_start_withoutLDR - Results_objectives_start)./Results_objectives_start_withoutLDR)' *100;

% Mean improvements for the S
Results_bigtable(:,2)=mean((Results_objectives_start_withoutLDR - Results_objectives_end_withoutLDR)./Results_objectives_start_withoutLDR)' *100;

% Mean improvements for the S+LDR
Results_bigtable(:,3)=mean((Results_objectives_start_withoutLDR - Results_objectives_end)./Results_objectives_start_withoutLDR)' *100;

% Gaps
Results_bigtable(:,4)=mean((Results_objectives_start_withoutLDR - Results_lowerbounds_start_withoutLDR)./(Results_objectives_start_withoutLDR + Results_lowerbounds_start_withoutLDR)/0.5)'*100;
Results_bigtable(:,5)=mean((Results_objectives_start - max(Results_lowerbounds_start_withoutLDR,Results_lowerbounds_start))./(Results_objectives_start + max(Results_lowerbounds_start_withoutLDR,Results_lowerbounds_start))/0.5)'*100;
Results_bigtable(:,6)=mean((Results_objectives_end_withoutLDR - max(Results_lowerbounds_start_withoutLDR,Results_lowerbounds_end_withoutLDR))./(Results_objectives_end_withoutLDR + max(Results_lowerbounds_start_withoutLDR,Results_lowerbounds_end_withoutLDR))/0.5)'*100;
Results_bigtable(:,7)=mean((Results_objectives_end - max(Results_lowerbounds_start_withoutLDR,Results_lowerbounds_end))./(Results_objectives_end + max(Results_lowerbounds_start_withoutLDR,Results_lowerbounds_end))/0.5)'*100;

Results_bigtable(:,8)=mean(Results_times_withoutLDR)';
Results_bigtable(:,9)=mean(Results_times)';