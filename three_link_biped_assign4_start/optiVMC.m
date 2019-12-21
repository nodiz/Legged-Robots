function [sln, x, v_moy] = optiVMC()
%--------------------------------------------------------------------------
%   optiVMC : optimize the parameters for a VMC controller
%
%   inputs:
%       o -
%   outputs:
%       o sln       : solution of the motion equation
%       o x         : parameters of the controller 
%                     k for spring, C for amortizer
%                     (k swf, k q2, k q3, C speed, C swf, C q3,
%                      desired torso angle, desired spread angle)
%       o v_moy     : mean velocity achieved
%--------------------------------------------------------------------------

   [q0, dq0, ~, ~, num_steps] = control_hyper_parameters();

    tic
    x = opti_surVMC(); % surrogate algorithm
    toc
    
    % Results of the optimization
    k = x(1:3);
    C = x(4:6);
    q_des_torso = x(7);
    x_des = x(8);
    save('solutionVMC_n', 'x');
    
    % Solve the motion equation
    [sln, xhip_abs] = solve_eqnsVMC(q0, dq0, num_steps, k, C, ...
                                    q_des_torso, x_des);
    
    % Compute the mean velocity
    delta_xhip_tot = xhip_abs(end)-xhip_abs(2);
    t = sln.TE{end};
    t_pre = sln.TE{1};
    v_moy = (delta_xhip_tot)/(t-t_pre);
    save('vmoyVMC', 'v_moy');
    disp("done")

end
