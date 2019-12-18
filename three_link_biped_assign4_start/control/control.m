function u = control(q,dq, k, C, q_des_torso, x_des) %control(t, q, dq, q0, dq0, step_number)
% You may call control_hyper_parameters and desired_outputs in this

% function
% you don't necessarily need to use all the inputs to this control function
[~, ~, ~, l1, ~, ~, ~] = set_parameters();
B = eval_B();
% 
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

[~, ~, dx_hip,~]    = kin_hip(q, dq);
[x_swf, ~, dx_swf, ~] = kin_swf(q, dq);
[~, ~, ~, v_target, ~] = control_hyper_parameters(1);
z_des                  = l1*cos(deg2rad(0));


J = [l1*cos(q(1)), 0, 0; %rabbit hip
    l1*cos(q(1)), -l1*cos(q(2)), 0; %xswf
    -l1*sin(q(1)), l1*sin(q(2)), 0; %zwf
    0, 0, 1]; %torso


F = [ -C(1)*(dx_hip-v_target); %rabbit on hip
      k(1)*(x_des - x_swf) + C(2)*(-dx_swf);%xswf
      k(2)*sin(q(2));
       -k(3)*(q(3)-q_des_torso) - C(3)*dq(3)]; %spring on torso

 
 T = J'*F;
 
 u = B'*T;
 
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