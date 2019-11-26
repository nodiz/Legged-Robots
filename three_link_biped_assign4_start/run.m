function p = run()
    q0 = [pi/6; -pi/6; 0];
    dq0 = [0;0;0];
    n_steps = 100;
    sln = solve_eqns(q0,dq0,n_steps);
    animate(sln);
