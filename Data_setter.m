% Data setting file

c_0= 10*rand(N,1);

Phi=zeros(N,4);
for i=1:N
    Phi(i,:)=rand(1,4);
    Phi(i,:)=Phi(i,:)/sum(Phi(i,:));
end

Psi=zeros(N,4);
for i=1:N
    Psi(i,:)=rand(1,4);
    Psi(i,:)=Psi(i,:)/sum(Psi(i,:));
end

r_0=c_0/5;
B=sum(c_0)/2;
l=ones(4,1);
u=ones(4,1);

P=[eye(4);-eye(4)];
p=[u ; l];

theta=0.8;
Number_of_subproblems=1;
Extra_hyperplanes=zeros(Max_number_of_splits,4,1);
Extra_intercepts=zeros(Max_number_of_splits,1);
Number_of_splits=0;
Lower_bound_scenarios=[];
Number_of_lower_bound_scenarios=0;
Max_allowed_scenarios_extra=1;