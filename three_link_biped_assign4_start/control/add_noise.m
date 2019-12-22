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
    persistent NoiseType;
    persistent SNR;
    persistent Bias;
    persistent F_hip;
    if isempty(NoiseType)
        load('param_noise.mat', 'param_noise');
        NoiseType = param_noise(1);
        SNR       = param_noise(2);
        Bias      = param_noise(3);
        F_hip     = param_noise(4);
    end
  
    
    NSTEP_STABILIZATION = 2;
    [~, ~, ~, l1, ~, ~, ~] = set_parameters();
     B = eval_B();
    
    
    switch NoiseType
        case 0
            u_noise = u;       
        case 1
           if step_number > NSTEP_STABILIZATION 
           % Transform the noise force to noise torque
           u_noise = awgn(u, SNR) + Bias;  % Transform and add the noise torque 
                               % to noise control                               
           else
                u_noise = u;
           end
           
        case 2
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
            
end

