
% This is a file that plots the paths
figure(1);
clf;
hold on;

scatter(Points_coordinates(:,1),Points_coordinates(:,2),'o');
xlim([0 10]);
ylim([0 10]);

    for iterate_arc = 1:Number_of_arcs
        
        Arc_index = iterate_arc;
        
        plot([Points_coordinates(OUT_arcs_that_stay(Arc_index),1); Points_coordinates(IN_arcs_that_stay(Arc_index),1)] , [Points_coordinates(OUT_arcs_that_stay(Arc_index),2); Points_coordinates(IN_arcs_that_stay(Arc_index),2)],'LineWidth',0.5);
        
    end

for iterate_path = 1:size(x_draw,2)
    
    Arcs_to_plot = Arcs_that_stay(x_draw(:,iterate_path) > 0);
    
    for iterate_arc = 1:length(Arcs_to_plot)
        
        Arc_index = find( Arcs_that_stay == Arcs_to_plot(iterate_arc));
        
        plot([Points_coordinates(OUT_arcs_that_stay(Arc_index),1); Points_coordinates(IN_arcs_that_stay(Arc_index),1)] , [Points_coordinates(OUT_arcs_that_stay(Arc_index),2); Points_coordinates(IN_arcs_that_stay(Arc_index),2)],'k','LineWidth',2);
        
    end
    
end

hold off;

%[OUT_arcs_that_stay(x ==1)' IN_arcs_that_stay(x==1)'];