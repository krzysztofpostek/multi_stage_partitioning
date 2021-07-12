%%% Script for working with the data

Improvements=zeros(Nb_of_instances,5);

for iterate_T=1:5
    for iterate_instance=1:Nb_of_instances
        Improvements(iterate_instance,iterate_T) = (-Results_objectives(8,iterate_instance,iterate_T) + Results_objectives_without_LDR(iterate_instance,iterate_T))/Results_objectives_without_LDR(iterate_instance,iterate_T)*100;
    end
end

Initial_optimality_gap=zeros(Nb_of_instances,5);

for iterate_T=1:5
    for iterate_instance=1:Nb_of_instances
        Initial_optimality_gap(iterate_instance,iterate_T) = (Results_objectives_without_LDR(iterate_instance,iterate_T) - max(Results_lowerbounds(1,iterate_instance,iterate_T),Results_exact_lowerbounds(iterate_instance ,iterate_T) ))/2/(Results_objectives_without_LDR(iterate_instance,iterate_T) + max(Results_lowerbounds(1,iterate_instance,iterate_T),Results_exact_lowerbounds(iterate_instance ,iterate_T) ))*100;
    end
end

Final_optimality_gap=zeros(Nb_of_instances,5);

for iterate_T=1:5
    for iterate_instance=1:Nb_of_instances
        Final_optimality_gap(iterate_instance,iterate_T) = (Results_objectives(8,iterate_instance,iterate_T) - Results_lowerbounds(8,iterate_instance,iterate_T))/2/(Results_objectives(8,iterate_instance,iterate_T) + Results_lowerbounds(8,iterate_instance,iterate_T))*100;
    end
end