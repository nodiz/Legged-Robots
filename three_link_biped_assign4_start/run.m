function sln = run()
   [q0, dq0,~, ~, ~, num_steps] = control_hyper_parameters();
    
    
    x = optimize_k();
    Kp = x(1:2)
    Kd = x(3:4)
    q_des_torso = x(5)
    
    [sln, ~] = solve_eqns(q0,dq0,num_steps,Kp, Kd, q_des_torso);
    animate(sln);

