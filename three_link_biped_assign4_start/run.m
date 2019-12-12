function [sln,x, v_moy] = run()
   [q0, dq0,~, ~, num_steps] = control_hyper_parameters();
    
    tic
    x = optimize_k();
    Kp = x(1:2)
    Kd = x(3:4)
    q_des_torso = x(5)
    spread = x(6)
    toc
    
    [sln, r0] = solve_eqns(q0,dq0,num_steps,Kp, Kd, q_des_torso, spread);
    q = sln.YE{end}(1:3);
    [x_h,~]  = kin_hip2(q);
    t = sln.TE{end}
    v_moy = (r0(end)-x_h)/t;
    animate(sln);

