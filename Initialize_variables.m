% Initialize variables used in solving

    Number_of_subsets = 1;

    A = ones(1,length(Arcs_that_stay));
    b = B;
    u = ones(Number_of_arcs,1);
    l = zeros(Number_of_arcs,1);
    Number_of_extra_constraints = 1;