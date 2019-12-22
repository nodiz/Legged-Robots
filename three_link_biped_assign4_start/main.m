%--------------------------------------------------------------------------
%   main : main of the program, call it to see our results
%--------------------------------------------------------------------------

close all
clc

boolAnimate = 0;   % show video after simulation
boolAnalyze = 1;   % show analysis after simulation
% Save video slow down the animation a lot, do not activate if you dont
% want to save a video
boolSaveVideo = and(or(boolAnimate, boolAnalyze), 1); % save video/figures after simulation/analysis
boolSaveStabil = and(and(boolAnimate, boolSaveVideo), 1);

control = 'PD'; %'PD' or 'VMC' or 'DDPG'
speed = 3;      % 1 to 9: 1 is the slowest gait, 9 the fastest. (reuired for PD, VMC)

numSteps = 30;  % how many steps to simulate
stableSteps = 10; % after how many steps we suppose the system to be stable
showSteps = 10; % how many steps we want to show (video, analysis)
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