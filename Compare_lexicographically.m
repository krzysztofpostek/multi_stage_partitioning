function [x_more_than_y]=Compare_lexicographically(a,b)

    found=0;
    position=1;
    difference=a-b;

    while((found ==0)&&(position<=length(a)))
        if(difference(position)>0)
            x_more_than_y=1;
            found=1;
        else
            if(difference(position)<0)
                x_more_than_y=0;
                found=1;
            end
        end
        position=position+1;
    end

    if(found==0)
        x_more_than_y=0;
    end

end