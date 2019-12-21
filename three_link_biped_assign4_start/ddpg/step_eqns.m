function dy = step_eqns(t, y, u)
% y1 = q1, y2 = q2, y3 = q3, y4 = dq1, y5 = dq2, y6 = dq3
% dy derive y 

n = 6;  
q = y(1:n/2);
dq = y(n/2+1:n);
dy = zeros(n, 1);

% write down the equations for dy:
M = eval_M(q);
G = eval_G(q);
C = eval_C(q,dq);
B = eval_B();

dy(1:n/2) = dq;     % dq
b = B*u-G-C*dq;     % b
dy(n/2+1:n) = M\b;  % ddq

end