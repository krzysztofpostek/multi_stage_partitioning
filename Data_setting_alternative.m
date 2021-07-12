
% Data setting

    N = N_range(iterate_N);
    B = B_range(iterate_B);

    Points_coordinates = 10*rand(N,2);
    Distances = zeros(N*(N-1), 1);
    Number_of_arcs = N * (N-1);
    Arcs_that_stay = 1:N*(N-1);
    
    OUT_arcs_that_stay = zeros(N*(N-1),1);
    IN_arcs_that_stay = zeros(N*(N-1),1);
    
    iterate_thingy = 1;
    for i = 1:N
        for j = 1:i-1
            OUT_arcs_that_stay(iterate_thingy) = i;
            IN_arcs_that_stay(iterate_thingy) = j;
            iterate_thingy = iterate_thingy + 1;
        end
        
        for j = i+1:N
            OUT_arcs_that_stay(iterate_thingy) = i;
            IN_arcs_that_stay(iterate_thingy) = j;
            iterate_thingy = iterate_thingy + 1;
        end
    end
    
    for iterate_arc = 1:Number_of_arcs
        Distances(iterate_arc) = norm(Points_coordinates(OUT_arcs_that_stay(iterate_arc),:) - Points_coordinates(IN_arcs_that_stay(iterate_arc),:));
    end
    
    Ends_of_path = Arcs_that_stay(find(Distances >= max(Distances)));
    s = OUT_arcs_that_stay(Ends_of_path(1));
    t = IN_arcs_that_stay(Ends_of_path(1));

    Arcs_that_stay = Arcs_that_stay(Distances < quantile(Distances,0.3));
    Distances = Distances(Distances < quantile(Distances,0.3));
    Number_of_arcs = length(Distances);

    OUT_arcs_that_stay = ceil(Arcs_that_stay/(N-1));
    IN_arcs_that_stay = mod(Arcs_that_stay,N-1) + 1;
    IN_arcs_that_stay = IN_arcs_that_stay + 1*(IN_arcs_that_stay >= OUT_arcs_that_stay);
    
    clear Ends_of_path;

    