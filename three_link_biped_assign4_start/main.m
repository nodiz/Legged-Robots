%--------------------------------------------------------------------------
%   main : main of the program, call it to see our results
%--------------------------------------------------------------------------
clc
clear all
% set path
addpath('./kinematics', './control', './dynamics', './set_parameters/', ...
        './solve_eqns/', './visualize', './analysis', './optimization/', './Noise')


% --------- PARAMETERS TO CHOOSE ---------

control     = 'PD'; %'PD' or 'VMC' or 'DDPG'
speed       = 9;      %1 to 9: 1 is the slowest gait, 9 the fastest. //Not for DDPG (only fastest agent available)
numSteps    = 30;  % how many steps to simulate

%Noise
NoiseBool = 0;  %0: noise off, 1: horizontal force on hip
F_hip       = 10; %constant force on the hip, if NoiseBool enables

%Analysis and Video
stableSteps = 1; % after how many steps we suppose the system to be stable
showSteps   = 30; % how many steps we want to show (video, analysis)
boolAnimate = 1;   % show video after simulation
boolAnalyze = 0;   % show analysis after simulation
% Save video slow down the animation a lot, do not activate if you dont
% want to save a video
boolSaveVideo = and(or(boolAnimate, boolAnalyze), 0); % save video/figures after simulation/analysis
boolSaveStabil = and(and(boolAnimate, boolSaveVideo), 1);

%-----------------------------------------------


param_noise = [NoiseBool, F_hip];
save('param_noise.mat', 'param_noise');

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
       sln = solve_eqnsVMC(q0, dq0, numSteps, x(1:3), x(4:6),  x(7), x(8), x(9));
    case 'DDPG'
        sln = solve_eqnsDDPG(q0, dq0, numSteps);
        
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