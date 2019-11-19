% You can set any hyper parameters of the control function here; you may or
% may not want to use the step_number as the input of the function. 
<<<<<<< Updated upstream
function [Kd,Kp,q3_des, dq3_des] = control_hyper_parameters() %step_number)

Kd = 0; 
Kp = 1;

q3_des = 0;
dq3_des = 0.1;
=======
function [Kd,Kp] = control_hyper_parameters()
>>>>>>> Stashed changes

    Kd = 0.1;
    Kp = 5;
end
