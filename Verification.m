x=binvar(N,1);
y=binvar(N,1);
zeta=sdpvar(4,1);
sdpvar F

Z=[zeta <= 1, zeta >= -1, uncertain(zeta)];
Conditions=[x+y <= ones(N,1), -(r_0.*(x+theta*y))'*(ones(N,1)+0.5*Phi*zeta) <= -F, (c_0.*(x+y))'*(ones(N,1)+0.5*Psi*zeta) <= B];
obj=-F;

sol=solvesdp(Conditions+Z,obj)


cvx_begin
    variable zeta(4,1)
        
    minimize((r_0.*(double(x)+theta*double(y)))'*(ones(N,1)+0.5*Phi*zeta))
    subject to
        zeta <= ones(4,1);
        zeta >= -ones(4,1);

cvx_end