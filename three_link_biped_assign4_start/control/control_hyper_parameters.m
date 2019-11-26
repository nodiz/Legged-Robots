% You can set any hyper parameters of the control function here; you may or
% may not want to use the step_number as the input of the function. 

function [Kd,Kp,q_des,dq_des, spread_t] = control_hyper_parameters(q,dq) %step_number)
spread_t = 30/360*2*pi;

Kd = [0.1,0.7];
Kp = [30;500];


q_des = [pi/6, -pi/6, pi/12] ;
dq_des = [0,0,0];

end
