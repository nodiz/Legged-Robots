function [sln, x, v_moy] = optiPD(opti_type)
%--------------------------------------------------------------------------
%   optiPD : optimize the parameters for a PD controller
%
%   inputs:
%       o opti_type : choose the optimization algorithm
%   outputs:
%       o sln       : solution of the motion equation
%       o x         : parameters of the controller
%                     (Kp torso, Kp spread, Kd torso, Kd torso,
%                      desired torso angle, desired spread angle)
%       o v_moy     : mean velocity achieved
%--------------------------------------------------------------------------

   [q0, dq0, ~, ~, num_steps] = control_hyper_parameters();
    
	tic
	switch opti_type
        case "ms" % multi start
            x = optimize_ms();
        case "ps" % pattern search      
            x = optimize_ps();
        case "gs" % global search
            x = optimize_glob_search();
        case "ga" % genetic algorithm
            x = opti_ga();
        case "part" % particle swarm
            x = opti_part();
        case "sur" % surrogate
            x = opti_sur();
	end
    toc
    
    % Results of the optimization
	Kp = x(1:2);
	Kd = x(3:4);
    q_des_torso = x(5);
    spread = x(6);
    save('solution_n', 'x');
    
    % Solve the motion equation
    [sln, xhip_abs] = solve_eqns(q0,dq0,num_steps,Kp, Kd, ...
                                 q_des_torso, spread);

    % Compute the mean velocity
    delta_xhip_tot = xhip_abs(end)-xhip_abs(2);
    t = sln.TE{end};
    t_pre = sln.TE{1};
    v_moy = (delta_xhip_tot)/(t-t_pre);
    save('vmoy', 'v_moy');
    disp("done")
    
end
