function u_noise = add_noise(u, q, step_number)
    F_hip = 0;
    [~, ~, ~, l1, ~, ~, ~] = set_parameters();
    B = eval_B();
    J = [-l1*cos(q(1)), 0, 0];
    
    if step_number >2
       T = J'*F_hip;
       u_noise = u + B'*T;
    else
        u_noise = u;
    end
   
end

