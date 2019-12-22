%--------------------------------------------------------------------------
%   main : main of the program, call it to see our results
%--------------------------------------------------------------------------
clc
clear all
%PATH
addpath('./kinematics', './control', './dynamics', './set_parameters/', ...
        './solve_eqns/', './visualize', './analysis', './optimization/')



control = 'PD'; %'PD' or 'VMC' or 'DDPG'
speed = 7;      %1 to 9: 1 is the slowest gait, 9 the fastest.

NoiseType = 2;  %0: noise off, 1: noise on torques, 2: horizontal force on hip
% params if noise type is 1:
SNR       = 99; %SNR for White Gaussian Noise
Bias      = 0;  %noise mean

%params if noise type is 2:
F_hip     = 100; %constant force on the hip

param_noise = [NoiseType, SNR, Bias, F_hip];
save('param_noise.mat', 'param_noise');


boolAnimate = 1;   % show video after simulation
boolAnalyze = 0;   % show analysis after simulation
% Save video slow down the animation a lot, do not activate if you dont
% want to save a video
boolSaveVideo = and(or(boolAnimate, boolAnalyze), 1); % save video/figures after simulation/analysis
boolSaveStabil = and(and(boolAnimate, boolSaveVideo), 1);

numSteps = 30;  % how many steps to simulate
stableSteps = 1; % after how many steps we suppose the system to be stable
showSteps = 30; % how many steps we want to show (video, analysis)
if boolSaveVideo
    name = [control, '_', num2str(speed)]; % name for video saving
end
[q0, dq0, ~, ~, ~] = control_hyper_parameters();

switch control
    case 'PD'
        load('control_params_PD.mat', 'control_params');
        x = control_params(speed,:);
        sln = solve_eqnsPD(q0, dq0, numSteps, x(1:2), x(3:4),  x(5), x(6));
    case 'VMC'
       load('control_params_VMC.mat', 'control_params');
       x = control_params(speed,:);
       sln = solve_eqnsVMC(q0, dq0, num_steps, x(1:3), x(4:6),  x(7), x(8), x(9));
    case 'DDPG'
        disp('No DDPG implemented');
        
end

if boolAnimate
    if boolSaveVideo
        animate(sln, stableSteps, showSteps, name);
    else
        animate(sln, stableSteps, showSteps);
    end
end
if boolAnalyze
    if boolSaveVideo
        analyze(sln, stableSteps, showSteps, name);
    else 
        analyze(sln, stableSteps, showSteps);
    end
end