% You can set any hyper parameters of the control function here; you may or
% may not want to use the step_number as the input of the function. 

function [q0, dq0, dq_des_torso, v_target, num_steps] = control_hyper_parameters() %step_number)


q0 = [pi/10; -pi/10; 0];
dq0 = [0;0;0];
dq_des_torso = 0;
v_target = 1;
num_steps = 50;

end
