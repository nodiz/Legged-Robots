%%
% This function takes the configuration of the 3-link model and plots the 
% 3-link model. 
% q = [q1, q2 ,q3] the generalized coordinates. Try different angles to see
% if your formulas for x1, z1, etc. makes sense. Example: q = [-pi/6, pi/6,
% pi/8]
%%
function visualize(q)

[~, ~, ~, l1, l2, l3, ~] = set_parameters;
     q1 = q(1);
     q2 = q(2);
     q3 = q(3);
    
x1 = (l1*sin(q1))/2;
z1 = (l1*cos(q1))/2;
x2 = l1*sin(q1) - (l2*sin(q2))/2;
z2 = l1*cos(q1) - (l2*cos(q2))/2;
x3 = l1*sin(q1) + (l3*sin(q3))/2;
z3 = l1*cos(q1) + (l3*cos(q3))/2;
x_h = l1*sin(q1);
z_h = l1*cos(q1);
x_t = l1*sin(q1) + l3*sin(q3);
z_t = l1*cos(q1) + l3*cos(q3);
x_swf = l1*sin(q1) - l2*sin(q2);
z_swf = l1*cos(q1) - l2*cos(q2);
    
    %% 
    % Here plot a schematic of the configuration of three link biped at the
    % generalized coordinate q = [q1, q2, q3]:
    close all
    lw = 2;
    % links
    % link1
    plot([0, x_h], [0, z_h], 'linewidth', lw); 
    hold on
    % link2
    plot([x_swf, x_h], [z_swf, z_h], 'linewidth', lw); 
    hold on
    % link3
    plot([x_t, x_h], [z_t, z_h], 'linewidth', lw); 
    hold on
    
    axis 'square'
    xlim([-1, 1]);
    ylim([0, 1.2]);
    % point masses
    mz = 40;
    % m1
    plot(x1, z1, '.', 'markersize', mz); 
    
    % m2
     plot(x2, z2, '.', 'markersize', mz);
    % m3
     plot(x3, z3, '.', 'markersize', mz);
end
