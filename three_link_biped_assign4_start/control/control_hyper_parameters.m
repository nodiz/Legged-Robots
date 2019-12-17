% You can set any hyper parameters of the control function here; you may or
% may not want to use the step_number as the input of the function. 

function [q0, dq0, dq_des_torso, v_target, num_steps] = control_hyper_parameters(i) %step_number)

q0  = [0.28; -0.22; -0.023];
%dq0 = [0;0;0];
dq0 = [1.87;1.98;-0.44];

%q0 = [0.1; -0.1; 0];
%dq0 = [0.1;0.1;0];
dq_des_torso = 0;
%v_target_array = [0.3, 0.35,0.4,0.45,0.5, 0.65,0.70,0.75]; 

v_target = 0.5;
%v_target_array(i);
num_steps = 30;

end
