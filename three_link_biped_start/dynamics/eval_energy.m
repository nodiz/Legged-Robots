function [T, V] = eval_energy(q, dq)
[m1, m2, m3, l1, l2, l3, g] = set_parameters();

q1 = q(1);
q2 = q(2);
q3 = q(3);
dq1 = dq(1);
dq2 = dq(2);
dq3 = dq(3);

V1 = (cos(q1)*l1/2)*m1*g;
V2 = (cos(q1)*l1 - cos(q2)*l2/2)*m2*g;
V3 = (cos(q1)*l1 + cos(q3)*l3/2)*m3*g;

V = V1 + V2 + V3;


T1 = 1/2*dq1^2*(l1/2)^2*m1;
T2 = dq1^2*l1^2*m2/2 + dq2^2*l2^2*m2/8 - dq1*dq2*l1*l2*m2*cos(q1-q2)/2; %th�or�me des cosinus (angle aigu) 
T3 = dq1^2*l1^2*m3/2 + dq3^2*l3^2*m3/8 + dq1*dq3*l1*l3*m3*cos(q1-q3)/2; %th�or�me des cosinus (angle obtu) 

T = T1 + T2 + T3;
end