function [mean_speed] = computeSpeed(sln, stab_step)
    
    if nargin == 1
        stab_step = 5;
    end
    
    [q0, ~, ~, ~, num_steps] = control_hyper_parameters();

    % Initialize postion table
    xhip_abs = zeros(num_steps+1,1);
    xhip0 = kin_hip(q0);
    xhip_abs(1) = xhip0;
    r0 = zeros(num_steps+1,1); 

    % Fill position table 
    for i = 1:num_steps
        [x_swf,  ~, ~, ~] = kin_swf(sln.YE{i}(1:3), sln.YE{i}(4:6));
        [x_hip] = kin_hip(sln.YE{i}(1:3)');

        r0(i+1) = r0(i) + x_swf;
        xhip_abs(i+1) = r0(i) + x_hip;
    end
  
    mean_speed = (xhip_abs(end)-xhip_abs(stab_step+1))/(sln.TE{end}-sln.TE{stab_step});

end