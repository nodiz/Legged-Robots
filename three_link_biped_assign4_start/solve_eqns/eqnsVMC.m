function dy = eqnsVMC(t, y, k, C,  q_des_torso, x_des, i_speed, step_number)
% n this is the dimension of the ODE, note that n is 2*DOF, why? 
% y1 = q1, y2 = q2, y3 = q3, y4 = dq1, y5 = dq2, y6 = dq3
% dy derive y 

n = 6;  
q = y(1:n/2);
dq = y(n/2+1:n);
u = control(q,dq, k, C, q_des_torso, x_des, i_speed);
u = add_noise(u, q, step_number);
%u = control2(q, dq, t, Kp, Kd,  q_des_torso, spread);
dy = zeros(n, 1);

% write down the equations for dy:
M = eval_M(q);
G = eval_G(q);
C = eval_C(q,dq);
B = eval_B();


dy(1:n/2) = dq;
b =B*u-G-C*dq;
dy(n/2+1:n) = M\b; %ddq


end
