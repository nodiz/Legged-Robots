function step_eval(env, agent, n)

simOpts = rlSimulationOptions('MaxSteps',1000);
experience = sim(env,agent,simOpts);
d = experience.Observation.lbro.Data;
dataq = d(:,1:3);
datadq = d(:,4:6);
num_steps = length(experience.Observation.lbro.Data);
h = 0.01;
figure();
myFolder = './videos/';

r0 = [0; 0];
for ji = 1:num_steps
    filename = [myFolder, num2str(n/100), '_', num2str(ij), '.png'];
    q = dataq(ji,:);
    dq = datadq(ji,:);
    pause(h);  % pause for 2 mili-seconds
    % visualize :
        % default r0 = [0; 0]

    x0 = r0(1);
    z0 = r0(2);
    
    [~, ~, ~, l1, l2, l3, ~] = set_parameters;
    q1 = q(1);
    q2 = q(2);
    q3 = q(3);
    
    x1 = (l1*sin(q1))/2 + x0;
    z1 = (l1*cos(q1))/2 + z0;
    x2 = l1*sin(q1) - (l2*sin(q2))/2 + x0;
    z2 = l1*cos(q1) - (l2*cos(q2))/2 + z0;
    x3 = l1*sin(q1) + (l3*sin(q3))/2 + x0;
    z3 = l1*cos(q1) + (l3*cos(q3))/2 + z0;
    
    x_h = l1*sin(q1) + x0;
    z_h = l1*cos(q1) + z0;
    
    x_t = l1*sin(q1) + l3*sin(q3) + x0;
    z_t = l1*cos(q1) + l3*cos(q3) + z0;
    
    x_swf = l1*sin(q1) - l2*sin(q2) + x0;
    z_swf = l1*cos(q1) - l2*cos(q2) + z0;
    
    %% 
    % Here plot a schematic of the configuration of three link biped at the
    % generalized coordinate q = [q1, q2, q3]:
    lw = 2;
    % links
    figure 1
    plot([x0, x_h], [z0, z_h], 'linewidth', lw); 
    hold on
    plot([x_h, x_t], [z_h, z_t], 'linewidth', lw); 
    plot([x_h, x_swf], [z_h, z_swf], 'linewidth', lw);
    % plot a line for "ground"
    plot([-1 + x_h, 1 + x_h], [0, 0], 'color', 'black');
    axis 'square'
    xlim([-1 + x_h, 1 + x_h]);
    ylim([-0.8, 1.2]);
    % point masses
    mz = 40;
    plot(x1, z1, '.', 'markersize', mz); 
    hold on
    plot(x2, z2, '.', 'markersize', mz); 
    plot(x3, z3, '.', 'markersize', mz);
    %title(['U2 is ', num2str(u(2))]);
    hold off
    % update r0:
    [x, ~, dx, ~] = kin_hip(q, dq);
    r0 = r0 + [dx*h;0];
   
    saveas(1,filename);
end



end