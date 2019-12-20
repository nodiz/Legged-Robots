function stop = outfun(x,optimValues,state)
stop = 0;
if strcmp(state, 'init')
    stop = 0;
else
    [q0, dq0, ~, v_target, num_steps] = control_hyper_parameters();
    [sln, xhip_abs] = solve_eqnsVMC(q0,dq0,num_steps,x(1:3), x(4:6), x(7), x(8));

    delta_xhip_tot = xhip_abs(end)-xhip_abs(2);
    t = sln.TE{end};
    t_pre = sln.TE{1};
    v_moy = (delta_xhip_tot)/(t-t_pre);

    if abs(v_moy-v_target)<0.005 && optimValues < 1
        stop = 1;
    end
end


end

