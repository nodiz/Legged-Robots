function u = controlPD(q, dq, Kp, Kd, q_des_torso, spread)
%--------------------------------------------------------------------------
%   control : compute the control to apply (PD)
%
%   inputs:
%       o q               : angle of the joints
%       o dq              : velocity of the joints
%       o t               : time
%       o Kp              : Proportional K of the PD
%       o Kd              : Derivative K of the PD
%       o q_des_torso     : desired angle for the torso
%       o spread          : desired spread angle
%   outputs:
%       o u               : control vector
%--------------------------------------------------------------------------

% Intialization and paramters
u = zeros(2,1); 
MAX_TORQUE = 30;
[~, ~, dq_des_torso, ~, ~] = control_hyper_parameters();

% Error on torso angle and derivative
error_torso   = -q_des_torso  + q(3); 
error_d_torso = -dq_des_torso + dq(3);
% Error on spread angle and derivative
error_spread   = -q(2)  + q(1) - spread;
error_d_spread = -dq(2) + dq(1);

% PD controller
u(1) = Kp(1)*error_torso  + Kd(1)*error_d_torso;
u(2) = Kp(2)*error_spread + Kd(2)*error_d_spread;

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