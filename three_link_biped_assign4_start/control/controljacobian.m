% VIRTUAL FORCES MAMENE

k_so = 1;
k_up = 1;
k_to = 1;
kp_f = 50;
swing_desired = pi/6;

% Lo jacobiano foot hip
J_fh = [l1*cos(q1) l2*cos(q2);
        l2*sin(q2) l1*sin(q1)];

% Force du ressort swing foot -> objectif
% Force au top pour faire marcher, depend aussi de theta: + negative vers
% l'haut, positive vers le bas
% check sign of q2

F_so = k_so * (-swing_desired+q(2));
F_top = k_up * (-q(2));


Q_so = J_fh' * [F_so; F_top];


% Force ressort au torso

F_tors = - k_to * q(3); 


dx_h =l1*cos(q1);
dz_h = -dq1*l1*sin(q1);