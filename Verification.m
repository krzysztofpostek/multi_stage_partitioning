% Verification of the solution

N_verify_scenarios = 10^4;
count = 0;

for i=1:N_verify_scenarios
    
    %scenario = zeros(1,Number_of_arcs); 
    %scenario(randsample(Number_of_arcs,B)) = 1;
    scenario = rand(1,Number_of_arcs);
    scenario = scenario/sum(scenario)*B;
    
    count = count + ( sum(prod(sum(A.*repmat(scenario,[size(A,1) 1 size(A,3)]),2) <= reshape(b,[size(b,1) 1 size(b,2)])+0.01,1)) > 0);
    
    if( sum(prod(sum(A.*repmat(scenario,[size(A,1) 1 size(A,3)]),2) <= reshape(b,[size(b,1) 1 size(b,2)]) + 0.01,1)) == 0)
        break;
    end
    
end
