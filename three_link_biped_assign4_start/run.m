function [sln,x, v_moy] = run(opti_type)
   [q0, dq0, ~, ~, num_steps] = control_hyper_parameters(1);
    
    tic
                x = optimize_k();
    for i = 1:7
     
        switch opti_type
            case "ps"       %pattern search
            case "gs"       %global search
                x = optimize_glob_search();
            case "ga"       %genetic algorithm
                x = opti_ga(i);
        end

        Kp = x(1:2);
        Kd = x(3:4);
        q_des_torso = x(5);
        spread = x(6);
        toc
        save('solution_n'+string(i), 'x');
        [sln, xhip_abs] = solve_eqns(q0,dq0,num_steps,Kp, Kd, q_des_torso, spread);

        delta_xhip_tot = xhip_abs(end)-xhip_abs(2);
        t = sln.TE{end};
        t_pre = sln.TE{1};
        v_moy = (delta_xhip_tot)/(t-t_pre);
        save('vmoy'+string(i), 'v_moy');
        disp("done")
    end
    %animate(sln);
end
