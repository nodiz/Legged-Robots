
function analyze(sln)
global u_vect
global t_vect
global dq_vect

[q0, dq0, ~, ~, ~] = control_hyper_parameters();
num_steps = length(sln.TE);
xhip_abs = zeros(num_steps+1,1);
xhip0 = kin_hip(q0);
xhip_abs(1) = xhip0;
r0 = zeros(num_steps+1,1);

for i = 1:num_steps
    [x_swf,  ~, ~, ~] = kin_swf(sln.YE{i}(1:3), sln.YE{i}(4:6));
    [x_hip] = kin_hip(sln.YE{i}(1:3)');
    
    r0(i+1) = r0(i)+ x_swf;
    xhip_abs(i+1) = r0(i) + x_hip;
end

figure()
plot(t_vect, u_vect(1, :), 'red.')
hold on
plot(t_vect, u_vect(2, :), 'blue.')
title('torques vs time')


states = cell2mat((sln.Y)');
time = cell2mat((sln.T)');
figure()
plot(time, states(:, 1), 'red.')
hold on
plot(time, states(:, 2), 'blue.')
plot(time, states(:, 3), 'green.')
title('angles vs time')


[~, z_h, dx_h, ~] = kin_hip(states(:, 1:3)', states(:, 4:6)');
figure()
plot(time, dx_h, 'blue.')
title('hip speed vs time')

step_n = 1:1:num_steps;
figure()
plot(step_n, diff(xhip_abs), 'blue')
title('hip displacement vs step number')

figure()
time_steps = [0;cell2mat((sln.TE)')];
plot(step_n, 1./diff(time_steps), 'green')
title('step frequency vs step number')


figure()

plot(states(:, 1), states(:, 4), 'red.')
hold on
plot(states(:, 2), states(:, 5), 'blue.')
plot(states(:, 3), states(:, 6), 'green.')
title('dq vs q')

figure()
plot(time, z_h , 'blue');
title('z_coordinate vs step number')


cost1 = max(0, u_vect(1, :).*(dq_vect(1, :)-dq_vect(3, :)));
cost2 = max(0, u_vect(2, :).*(dq_vect(2, :)-dq_vect(3, :)));
CoT = (sum(cost1) + sum(cost2))/(xhip_abs(end)-xhip_abs(1))


end