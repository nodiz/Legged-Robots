% You can set any hyper parameters of the control function here; you may or
% may not want to use the step_number as the input of the function. 

function [Kp,Kd,q_des,dq_des, spread_t] = control_hyper_parameters(q,dq) %step_number)
spread_t = 40/360*2*pi;

Kp = [300;200];
Kd = [30;Kp(2)/12];


q_des = [pi/6, -pi/6, pi/12] ;
dq_des = [0,0,0];

end
