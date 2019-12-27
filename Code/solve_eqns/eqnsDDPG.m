function dy = eqnsDDPG(t, y, step_n)
% n this is the dimension of the ODE, note that n is 2*DOF, why? 
% y1 = q1, y2 = q2, y3 = q3, y4 = dq1, y5 = dq2, y6 = dq3
% dy derive y 

n = 6;  
q = y(1:n/2);
dq = y(n/2+1:n);

u = evaluatePolicyCool([q;dq;0;0])';
u = add_noise(u, q, step_n);

dy = zeros(n, 1);

% write down the equations for dy:
M = eval_M(q);
G = eval_G(q);
C = eval_C(q,dq);
B = eval_B();


dy(1:n/2) = dq;
b =B*u-G-C*dq;
dy(n/2+1:n) = M\b; %ddq

global u_vect;
global dq_vect;
global t_vect;

t_vect = [t_vect, t];
u_vect = [u_vect, u];
dq_vect = [dq_vect, dq];


end