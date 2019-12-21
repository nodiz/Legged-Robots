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
r0 = zeros(num_steps+1,1);
vStep = zeros(num_steps,1);

% Fill position table
for i = 1:num_steps
    [x_swf,  ~, ~, ~] = kin_swf(sln.YE{i}(1:3), sln.YE{i}(4:6));
    [x_hip] = kin_hip(sln.YE{i}(1:3)');
    
    r0(i+1) = r0(i) + x_swf;
    xhip_abs(i+1) = r0(i) + x_hip;
end

% figure()
% hold on
% plot(t_vect, u_vect(2, :), 'blue.')
% title('Torques vs time')
% plot(t_vect, u_vect(1, :), 'red.')

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

    
figure()
t_diff = diff(time_steps);
x_diff = diff(xhip_abs);

plot(x_diff./t_diff)
hold on; 
plot(x_diff./t_diff, 'b+', 'linewidth', 2)


%% Cost of Transport
    % use Matlab function: trapz to compute integrals
    
% j = 1;
% first_stable_step = 3;
% for i = first_stable_step:num_steps
%     max_1 = 0;
%     max_2 = 0;
%     for t = 1:length(sln.T{i})   
%         max_1(t) = max([0, u_vect(i,1) * (sln.Y{i}(t,4) - sln.Y{i}(t,6))]);
%         max_2(t) = max([0, u2{i}(t,1) * (sln.Y{i}(t,5) - sln.Y{i}(t,6))]);
%     end
%     COT_vect(j) = (trapz(sln.T{i}', max_1) + trapz(sln.T{i}', max_2))/...
%                     (hip.x{i}(end,1) - hip.x{i}(1,1));
%     j = j + 1;
% end
% 
% COT = mean(COT_vect);
% disp(['Cost of Transport [J/m] = ', num2str(COT)]);
% 
% cost1 = max(0, u_vect(1, :).*(dq_vect(1, :)-dq_vect(3, :)));
% cost2 = max(0, u_vect(2, :).*(dq_vect(2, :)-dq_vect(3, :)));
% CoT = (sum(cost1) + sum(cost2))/(xhip_abs(end)-xhip_abs(1))


end
