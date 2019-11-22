function u = control(q,dq) %control(t, q, dq, q0, dq0, step_number)
% You may call control_hyper_parameters and desired_outputs in this
% function
% you don't necessarily need to use all the inputs to this control function


u = zeros(2,1); 

[Kp,Kd, q1_des, dq1_des, q2_des, dq2_des, q3_des,dq3_des] = control_hyper_parameters(q,dq,q0,dq0);

u(1) = Kp(1)*(q1_des - q(1) - q3_des + q(3)) + Kd(2)*(dq1_des - dq(1) - dq3_des + dq(3));
u(2) = Kp(2)*(q2_des - q(2) - q3_des + q(3)) + Kd(2)*(dq2_des - dq(2) - dq3_des + dq(3));

end