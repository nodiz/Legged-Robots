function analyze(sln)
%--------------------------------------------------------------------------
%   analyze : plot graph to analyze a given solution
%
%   inputs:
%       o sln : solution of the motion system 
%   outputs:
%       o -
%--------------------------------------------------------------------------

% Use the global vecotrs
global u_vect  % command vector
global t_vect  % time vector
global dq_vect % difference of angle vector

% Initialize parameters
[q0, ~, ~, ~, ~] = control_hyper_parameters();
num_steps = length(sln.TE);

% Initialize postion table
xhip_abs = zeros(num_steps+1,1);
r0 = zeros(num_steps+1,1);
xhip0 = kin_hip(q0);
xhip_abs(1) = xhip0;

% Fill position table
for i = 1:num_steps
    [x_swf,  ~, ~, ~] = kin_swf(sln.YE{i}(1:3), sln.YE{i}(4:6));
    [x_hip] = kin_hip(sln.YE{i}(1:3)');
    
    r0(i+1) = r0(i)+ x_swf;
    xhip_abs(i+1) = r0(i) + x_hip;
end

% Plot torques vs time
figure()
plot(t_vect, u_vect(1, :), 'red.')
hold on
plot(t_vect, u_vect(2, :), 'blue.')
title('torques vs time')

% Plot angles vs time
states = cell2mat((sln.Y)');
time = cell2mat((sln.T)');
figure()
plot(time, states(:, 1), 'red.')
hold on
plot(time, states(:, 2), 'blue.')
plot(time, states(:, 3), 'green.')
title('angles vs time')

% Plot hip speed vs time
[~, z_h, dx_h, ~] = kin_hip(states(:, 1:3)', states(:, 4:6)');
figure()
plot(time, dx_h, 'blue.')
title('hip speed vs time')

% Plot hip displacement vs step number
step_n = 1:1:num_steps;
figure()
plot(step_n, diff(xhip_abs), 'blue')
title('hip displacement vs step number')

% Plot step frequency vs step number
figure()
time_steps = [0;cell2mat((sln.TE)')];
plot(step_n, 1./diff(time_steps), 'green')
title('step frequency vs step number')

% Plot dq vs q
figure()
plot(states(:, 1), states(:, 4), 'red.')
hold on
plot(states(:, 2), states(:, 5), 'blue.')
plot(states(:, 3), states(:, 6), 'green.')
title('dq vs q')

% Plot z vs step number
figure()
plot(time, z_h , 'blue');
title('z_coordinate vs step number')

% Compute the cost of transportation
[m1, m2, m3, ~, ~, ~, g] = set_parameters()
cost1 = max(0, u_vect(1, :).*(dq_vect(1, :)-dq_vect(3, :)));
cost2 = max(0, u_vect(2, :).*(dq_vect(2, :)-dq_vect(3, :)));
CoT = (sum(cost1) + sum(cost2))/(xhip_abs(end)-xhip_abs(1));
disp(CoT);
CoT_norm = CoT/(g*(m1+m2+m3));
disp(CoT_norm);

end