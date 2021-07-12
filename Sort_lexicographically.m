function [Msorted]=Sort_lexicographically(M)
    dimsM=size(M);
    
    Msorted=M;
    for koniec=dimsM(2):-1:2
        for i=1:koniec-1
            if(logical(Compare_lexicographically(Msorted(:,i),Msorted(:,i+1))))
                buf=Msorted(:,i+1);
                Msorted(:,i+1)=Msorted(:,i);
                Msorted(:,i)=buf;
            end            
        end
    end
end