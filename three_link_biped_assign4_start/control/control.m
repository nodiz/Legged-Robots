function u = control(q,dq, k, C, q_des_torso) %control(t, q, dq, q0, dq0, step_number)
% You may call control_hyper_parameters and desired_outputs in this

% function
% you don't necessarily need to use all the inputs to this control function
[~, ~, ~, l1, ~, ~, ~] = set_parameters();


th1 = pi -q(3)+q(1);
th2 = pi -q(3)+q(2);
var = (th2-th1)/2;


[~, z_hip, dx_hip,dz_hip]    = kin_hip(q, dq);
[~, ~, ~, v_target, ~] = control_hyper_parameters(1);
z_des                  = l1*cos(q(2));


J = [-(1/2)*l1*cos(var), (1/2)*l1*cos(var);
    (1/2)*l1*sin(var), -(1/2)*l1*sin(var);
    -1/2,               -1/2];


F = [-C(1)*(dx_hip-v_target);
     -k(1)*(z_hip-z_des) - C(2)*dz_hip;
     k(2)*(q(3)-q_des_torso) + C(3)*dq(3)];
 
 u = J'*F;
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