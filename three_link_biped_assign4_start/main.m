control = 'PD'; %'PD' or 'VMC' or 'DDPG'
speed = 1; %1 to 9// 1 is the slowest gait, 9 the fastest.

[q0, dq0, ~, ~, num_steps] = control_hyper_parameters();

switch control
    case 'PD'
       load('control_params_PD.mat', 'control_params');
       x = control_params(speed,:);
       sln = solve_eqns(q0, dq0, num_steps, x(1:2), x(3:4),  x(5), x(6));
    case 'VMC'
       load('control_params_VMC.mat', 'control_params');
       x = control_params(speed,:);
       sln = solve_eqnsVMC(q0, dq0, num_steps, x(1:2), x(3:4),  x(5), x(6));
end

animate(sln);