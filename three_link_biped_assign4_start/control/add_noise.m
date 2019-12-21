function u_noise = add_noise(u, q, step_number)
%--------------------------------------------------------------------------
%   add_noise : add a noise force acting on the hip to the control
%
%   inputs:
%       o u           : control output without noise
%       o q           : angle position
%       o step_number : number of steps done
%   outputs:
%       o u_noise     : control output with noise added
%--------------------------------------------------------------------------
    
    F_hip = 0; % Intensity of the force that we want to apply
    
    % Transformation matrices and needed parameters
    NSTEP_STABILIZATION = 2;
    [~, ~, ~, l1, ~, ~, ~] = set_parameters();
    B = eval_B();
    J = [-l1*cos(q(1)), 0, 0];
    
    % we don't want to put noise before stabilization
    if step_number > NSTEP_STABILIZATION 
       T = J'*F_hip; % Transform the noise force to noise torque
       u_noise = u + B'*T; % Transform and add the noise torque 
                           % to noise control
    else
        u_noise = u;
    end
   
end

