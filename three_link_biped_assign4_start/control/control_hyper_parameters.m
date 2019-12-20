% You can set any hyper parameters of the control function here; you may or
% may not want to use the step_number as the input of the function. 

function [q0, dq0, dq_des_torso, v_target, num_steps] = control_hyper_parameters(i) %step_number)
v_target = [];
q0  = [0.28; -0.22; -0.023];
dq0 = [1.87;1.98;-0.44];

dq_des_torso = 0;

if nargin > 0
    v_target_array = 1.5; 
    v_target = v_target_array(i);
end

num_steps = 30;

end
