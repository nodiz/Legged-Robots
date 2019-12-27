%function used test the critical perturbation that can be tolerated by the
%robot.


clear all
clc

addpath('./kinematics', './control', './dynamics', './set_parameters/', ...
        './solve_eqns/', './visualize', './analysis', './optimization/')

control = 'PD'; %choose 'PD', 'VMC', 'DDPG'
numSteps = 30;


FORCE_INIT = 0; %chose initial test force (can be negative)
DELTA_F = 1;      %chose force increment (can be negative)

NoiseBool = 1;

[q0, dq0, ~, ~, ~] = control_hyper_parameters();


for speed = 1:9  %%set 1:1 for DDPG
    F_hip = FORCE_INIT;
    NoFall = 1;

    clear add_noise
    param_noise = [NoiseBool, F_hip];
    save('param_noise.mat', 'param_noise');

    while NoFall
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
        interYE = cat(1,sln.YE{:}); 
        [~, z_h, ~, ~] = kin_hip((interYE(:, 1:3)'), interYE(:, 4:6)');

        if isempty(find(z_h<0, 1)) %if biped did not fall 
            
            F_hip = F_hip + DELTA_F;
            clear add_noise
            param_noise = [NoiseBool, F_hip];
            save('param_noise.mat', 'param_noise');

        else    %robot fell
            
            save('MaxF' + string(speed), 'F_hip');  %save result
            NoFall = 0;
        end
    end
end


    
    
    
    
