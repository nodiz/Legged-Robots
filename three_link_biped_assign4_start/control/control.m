function u = control(q,dq) %control(t, q, dq, q0, dq0, step_number)
% You may call control_hyper_parameters and desired_outputs in this
% function
% you don't necessarily need to use all the inputs to this control function

<<<<<<< Updated upstream
u = zeros(2,1); 

[Kp,Kd,q3_des,dq3_des] = control_hyper_parameters;

u(1) = -Kp*(q3_des-q(3))+Kd*(dq3_des - dq(3));
disp(u(1))

=======
    [Kd, Kp] = control_hyper_parameters();
    u = - Kd*(dq0-dq) - Kp*(q0-q);
    
>>>>>>> Stashed changes
end