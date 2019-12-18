function [sln,x, v_moy] = runVMC()
   [q0, dq0, ~, ~, num_steps] = control_hyper_parameters(1);
    

    tic
    x = opti_gaVMC();

    toc
    k = x(1:2);
    C = x(3:5);
    q_des_torso = x(6);
    
    %('solution_n'+string(i), 'x');
    [sln, xhip_abs] = solve_eqnsVMC(q0,dq0,num_steps,k, C, q_des_torso, x_des);

    delta_xhip_tot = xhip_abs(end)-xhip_abs(2);
    t = sln.TE{end};
    t_pre = sln.TE{1};
    v_moy = (delta_xhip_tot)/(t-t_pre);
    %save('vmoy'+string(i), 'v_moy');
    disp("done")

    %animate(sln);
end
