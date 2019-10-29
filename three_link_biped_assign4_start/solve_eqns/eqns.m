function dy = eqns(t, y)
% n this is the dimension of the ODE, note that n is 2*DOF, why? 
% y1 = q1, y2 = q2, y3 = q3, y4 = dq1, y5 = dq2, y6 = dq3
n = 6;  

q = y(1:n/2);
dq = y(n/2+1:n);


u = control(q, dq); % for the moment we set the control outputs to zero

<<<<<<< Updated upstream
 
=======
n = 6;
>>>>>>> Stashed changes
dy = zeros(n, 1);

% write down the equations for dy:
dy(1:n/2) = diff(y(:,1),t) 
dy(n/2+1:n) = diff(y(:,2),t) 

M = eval_M(q);
G = eval_G(q);
C = eval_C(q,dq);
B = eval_B();


dy(1:n/2) = dq;
b = B*u-G-C*dq;
dy(n/2+1:n) = M\b;



end