%--------------------------------------------------------------------------
%   saveAllVideos : solve and animate all the solution for all type of PD
%                  and VMC controller and save the results as videos (.avi)
%                   
%--------------------------------------------------------------------------

close all
clc

boolAnimate = 1;   % show video after simulation
boolAnalyze = 0;   % show analysis after simulation
% Save video slow down the animation a lot, do not activate if you dont
% want to save a video
boolSaveVideo = and(boolAnimate, 1); % save video after simulation
boolSaveStabil = and(and(boolAnimate, boolSaveVideo), 1);

for control = ["PD", "VMC"]
    for speed = 1:9

        numSteps = 30;  % how many steps to simulate
        stableSteps = 10; % after how many steps we suppose the system to be stable
        showSteps = 20; % how many steps we want to show (video, analysis)

        if boolSaveVideo
            name = strcat(control, '_', num2str(speed)); % name for video saving
            disp(name)
        end
        [q0, dq0, ~, ~, ~] = control_hyper_parameters();
        
        switch control
            case "PD"
                load('control_params_PD.mat', 'control_params');
                x = control_params(speed,:);
                sln = solve_eqnsPD(q0, dq0, numSteps, x(1:2), x(3:4),  x(5), x(6));
            case "VMC"
                load('control_params_VMC.mat', 'control_params');
                x = control_params(speed,:);
                sln = solve_eqnsVMC(q0, dq0, numSteps, x(1:3), x(4:6),  x(7), x(8), x(9));
            case "DDPG"
                disp('No DDPG implemented');

        end

        if boolAnimate
            if boolSaveVideo
%                 animate(sln, stableSteps, showSteps, name);
                if boolSaveStabil
                    animate(sln, 1, 5, strcat('start_', name));
                end
            else
                animate(sln, stableSteps, showSteps);
            end
        end
        if boolAnalyze
            analyze(sln, stableSteps, showSteps, name);
        end
    end
end