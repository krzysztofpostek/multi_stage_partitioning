
    I_1=0;  % initial inventory level

    c_x=c_xM(iterate_instance); % setting the x-order costs
    c_b=c_bM(iterate_instance); % setting the inventory holding costs
    q=100/N; % setting the binary lot sizes
    cyn=cynM(:,iterate_instance); % setting the binary lot costs

    l=lM(1:T,iterate_instance);  % lower bound for uncertain demand in periods 2,...,T
    u=uM(1:T,iterate_instance); % upper bound for uncertain demand in periods 2,...,T

    x_tot=x_totM(1:T-1,iterate_instance);  % total  cumulative ordering limits