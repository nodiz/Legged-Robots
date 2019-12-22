%--------------------------------------------------------------------------
%   main : main of the program, call it to see our results
%--------------------------------------------------------------------------

close all 
clc

boolAnimate = 0;
boolAnalyze = 1;

control = 'VMC'; %'PD' or 'VMC' or 'DDPG'
speed = 9;      % 1 to 9: 1 is the slowest gait, 9 the fastest. (required for VMC)

numSteps = 50; 

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
    animate(sln);
end
if boolAnalyze
    analyze(sln);
end