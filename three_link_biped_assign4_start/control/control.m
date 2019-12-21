function u = control(q,dq, k, C, q_des_torso, x_des)
%--------------------------------------------------------------------------
%   control : compute the control to apply (VMC)
%
%   inputs:
%       o q               : angle of the joints
%       o dq              : velocity of the joints
%       o k               : spring factors
%       o C               : dumping factors
%       o q_des_torso     : desired angle for the torso
%       o x_des           : desired x
%   outputs:
%       o u               : control vector
%--------------------------------------------------------------------------

% angles must be between 0 and 2pi
if q(3) >0
    q(3) = mod(q(3), 2*pi);
end
if q(3) <0
     q(3) = mod(q(3), -2*pi);
end
if q(3) >pi
    q(3) = q(3)-2*pi;
end
if q(3) < -pi
    q(3) = q(3)+2*pi;
end

% Call parameters and matrices
MAX_TORQUE = 30;
[~, ~, ~, l1, ~, ~, ~] = set_parameters();
[~, ~, ~, v_target, ~] = control_hyper_parameters();
B = eval_B();

% Compute position and velocities of hip and swf
[~, ~, dx_hip,~]    = kin_hip(q, dq);
[x_swf, ~, dx_swf, ~] = kin_swf(q, dq);

% Jacobian matrix
J = [l1*cos(q(1)), 0, 0;            %rabbit hip
    l1*cos(q(1)), -l1*cos(q(2)), 0; %xswf
    -l1*sin(q(1)), l1*sin(q(2)), 0; %zwf
    0, 0, 1];                       %torso

% Forces that we want to apply
F = [C(1)*(dx_hip-v_target);                 %rabbit on hip
     k(1)*(x_des - x_swf) + C(2)*(-dx_swf);  %xswf
     k(2)*sin(q(2));
     -k(3)*(q(3)-q_des_torso) - C(3)*dq(3)]; %spring on torso

% Transform forces in torques
T = J'*F;
% Transform toques to control input
u = B'*T;
 
% Limit the torques
if u(1) > 0
    u(1) = min(MAX_TORQUE,u(1));
else
    u(1) = max(-MAX_TORQUE,u(1));
end

if u(2) > 0
    u(2) = min(MAX_TORQUE,u(2));
else
    u(2) = max(-MAX_TORQUE,u(2));
end

end