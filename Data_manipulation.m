%%% Script for working with the data
Improvements=-(Results_objectives_end - Results_objectives_start)./Results_objectives_start*100;

Initial_optimality_gap=(Results_objectives_start - Results_lowerbounds_start)./(Results_objectives_start + Results_lowerbounds_start)*100/0.5;

Final_optimality_gap=(Results_objectives_end - Results_lowerbounds_end)./(Results_objectives_end + Results_lowerbounds_end)*100/2;

Improvements_LDR_over_static=-(Results_objectives_end - Results_objectives_start)./Results_objectives_start*100;
Improvements_S_over_static=-(Results_objectives_end - Results_objectives_start)./Results_objectives_start*100;
Improvements_S_and_LDR_over_static=-(Results_objectives_end - Results_objectives_start)./Results_objectives_start*100;