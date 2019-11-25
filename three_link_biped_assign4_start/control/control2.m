function u = control2(q, dq)
% You may call control_hyper_parameters and desired_outputs in this
% function
% you don't necessarily need to use all the inputs to this control function

u = zeros(2,1); 

[Kp,Kd, q_des, dq_des, spread] = control_hyper_parameters(q,dq);

u(1) = Kp(1)*(-q_des(3) + q(3)) + Kd(1)*(-dq_des(3) + dq(3));
u(2) = Kp(2)*(-q(2)+q(1)+spread) + Kd(2)*(dq_des(2)-dq(2) + dq_des(1)-dq(1));

end