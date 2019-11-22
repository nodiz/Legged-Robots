% You can set any hyper parameters of the control function here; you may or
% may not want to use the step_number as the input of the function. 

function [Kd,Kp,q1_des,dq1_des,q2_des, dq2_des,q3_des, dq3_des] = control_hyper_parameters(q,dq,q0,dq0) %step_number)

Kd = zeros(1,2);
Kp = zeros(1,2);

Kd(1) = 0.1;
Kd(2) = 0.1;
Kp(1) = 50;
Kp(2) = 50;

q1_des = -pi/6;
dq1_des = 0;
q2_des = pi/6;
dq2_des = 0;
q3_des = pi/13;
dq3_des = 0;

end
