%--------------------------------------------------------------------------
%   TestMaxNoise : Find the maximum noise that we can apply to a controller
%--------------------------------------------------------------------------

% Set the path 
addpath('./kinematics', './control', './dynamics', './set_parameters/', ...
        './solve_eqns/', './visualize', './analysis', './optimization/')

% Selection noise and controller to test
Bias = 0;
SNR = 100;
F_hip = 0;

% Controller to test and for which settings
control = 'PD';
numSteps = 30;
speed = 4;

for Noise_Type = 1:2
    param_noise = [NoiseType, SNR, Bias, F_hip];
    
    switch control
        case 'PD'
            load('control_params_PD.mat', 'control_params');
            x = control_params(speed,:);
            sln = solve_eqnsPD(q0, dq0, numSteps, x(1:2), x(3:4),  x(5), x(6));
            animate(sln);
        case 'VMC'
            load('control_params_VMC.mat', 'control_params');
            x = control_params(speed,:);
            sln = solve_eqnsVMC(q0, dq0, num_steps, x(1:3), x(4:6),  x(7), x(8), x(9));
            animate(sln);
        case 'DDPG'
            disp('No DDPG implemented');
    end
    
    [~, z_h, ~, ~] = kin_hip(sln.Y(:, 1:3)', sln.Y(:, 4:6)');

end
