function u = control2(q, dq,t)
% You may call control_hyper_parameters and desired_outputs in this
% function
% you don't necessarily need to use all the inputs to this control function
freq = 20;
u = zeros(2,1); 


[Kp,Kd, q_des, dq_des, spread_t] = control_hyper_parameters(q,dq);

error_torso = -q_des(3) + q(3);

t_current = mod(t,1/freq);
spread_c = q(1)-q(2);
%error_spread = spread_c - spread_t*(-1+2*t_current*freq);
error_spread = -q(2)+q(1)+spread_t;


u(1) = Kp(1)*(error_torso) + Kd(1)*(-dq_des(3) + dq(3));
u(2) = Kp(2)*(error_spread);

% u(2) = Kp(2)*(-q(2)+q(1)+spread) + Kd(2)*(dq_des(2)-dq(2) + dq_des(1)-dq(1));


end