function u = control2(q, dq, t, Kp, Kd, q_des_torso)
% You may call control_hyper_parameters and desired_outputs in this
% function
% you don't necessarily need to use all the inputs to this control function
% freq = 20;
u = zeros(2,1); 

[~, ~, dq_des_torso, spread_t, ~, ~] = control_hyper_parameters();

error_torso   = -q_des_torso  + q(3);
error_d_torso = -dq_des_torso + dq(3);

error_spread   = -q(2)  + q(1) - spread_t;
error_d_spread = -dq(2) + dq(1);


u(1) = Kp(1)*error_torso  + Kd(1)*error_d_torso;
u(2) = Kp(2)*error_spread + Kd(2)*error_d_spread;

% limiting torques
if u(1) > 0
    u(1) = min(30,u(1));
else
    u(1) = max(-30,u(1));
end

if u(2) > 0
    u(2) = min(30,u(2));
else
    u(2) = max(-30,u(2));
end

end