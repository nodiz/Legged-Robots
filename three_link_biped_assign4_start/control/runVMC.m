function 
   [q0, dq0, ~, ~, num_steps] = control_hyper_parameters();
   for i_speed = 1:1
        tic
        x = opti_surVMC(i_speed);

        toc
        k = x(1:3);
        C = x(4:6);
        q_des_torso = x(7);
        x_des = x(8);
        save('solutionVMC_n'+string(i_speed), 'x');
        [sln, xhip_abs] = solve_eqnsVMC(q0,dq0,num_steps,k, C, q_des_torso, x_des, i_speed);

        delta_xhip_tot = xhip_abs(end)-xhip_abs(2);
        t = sln.TE{end};
        t_pre = sln.TE{1};
        v_moy = (delta_xhip_tot)/(t-t_pre);
        save('vmoyVMC'+string(i_speed), 'v_moy');
        disp("done")
    end

    %animate(sln);
end
