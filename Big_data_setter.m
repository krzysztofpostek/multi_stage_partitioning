% Big_data_setter
c_xM=[];
c_bM=[];
cynM=[];
lM=[];
uM=[];
x_totM=[];

for iterate_instance=1:Nb_of_instances
    
    c_xM=[c_xM 5*rand(1)]; % setting the x-order costs
    c_bM=[c_bM 10*rand(1)]; % setting the inventory holding costs
    cynM=[cynM sort((c_xM(iterate_instance) + (10-c_xM(iterate_instance))*rand(N,1)))]; % setting the binary lot costs

    lM=[lM [1; 25*rand(10-1,1)]];  % lower bound for uncertain demand in periods 2,...,T
    uM=[uM [1; 75+25*rand(10-1,1)]]; % upper bound for uncertain demand in periods 2,...,T

    x_totM=[x_totM cumsum( 100*rand(10-1,1) )];  % total  cumulative ordering limits
end

Simulationmatrix=rand(10,N_simulations);