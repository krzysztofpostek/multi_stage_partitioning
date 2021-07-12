%%% This file conducts the choosing of the time period to split

Number_of_scenarios_single_problem=size(Critical_scenarios_single_problem);
Number_of_scenarios_single_problem=Number_of_scenarios_single_problem(2);

if(Number_of_scenarios_single_problem > 1)
    Dispersions=zeros(min(Highest_splitted_period(iterate_problem)+Max_next_split,T)+1 - Highest_splitted_period(iterate_problem),1);
    
    for t=Highest_splitted_period(iterate_problem):min(Highest_splitted_period(iterate_problem)+Max_next_split,T)
        Dispersions(t+1-Highest_splitted_period(iterate_problem))=var(Critical_scenarios_single_problem(t,:)');
    end
    
    max_dispersion=max(Dispersions);
    for i=1:length(Dispersions)
        if(Dispersions(i)==max_dispersion)
            max_dispersion_index=i;
        end
    end
    
    if(max_dispersion < 10^-4)
        t=Highest_splitted_period(iterate_problem);
        while((max_dispersion < 10^-4) & (t<= T))
                    max_dispersion=var(Critical_scenarios_single_problem(t,:)');
                    splitting_T=t;
                    t=t+1;
        end
    else
        splitting_T=Highest_splitted_period(iterate_problem)+max_dispersion_index-1;
    end
        
end