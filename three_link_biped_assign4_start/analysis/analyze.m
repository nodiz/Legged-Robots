function meanValues = analyze(sln, stableSteps, showSteps, name)
%--------------------------------------------------------------------------
%   analyze : plot graph to analyze a given solution
%
%   inputs:
%       o sln : solution of the motion system 
%   outputs:
%       o -
%--------------------------------------------------------------------------

% Initialize parameters
[q0, ~, ~, ~, ~] = control_hyper_parameters();
num_steps = length(sln.TE);

%Extract matrix containing states, time and torques
states = cell2mat((sln.Y)');
time = cell2mat((sln.T)');
torques = cell2mat((sln.U)');

% Initialize postion table
xhip_abs = zeros(num_steps+1,1);
xhip0 = kin_hip(q0);
xhip_abs(1) = xhip0;
r0 = zeros(num_steps+1,1); 

% Fill position table�
for i = 1:num_steps
    [x_swf,  ~, ~, ~] = kin_swf(sln.YE{i}(1:3), sln.YE{i}(4:6));
    [x_hip] = kin_hip(sln.YE{i}(1:3)');
    
    r0(i+1) = r0(i) + x_swf;
    xhip_abs(i+1) = r0(i) + x_hip;
end

%plot torques vs Time
figure()
hold on
plot(time, torques(1,:), 'blue.')
title('Torques vs time')
plot(time, torques(2, :), 'red.')

% Plot torques 

figure(1)
hold on
plot(interT, interU(:,1), 'blue')
title('Torques vs time')
plot(interT, interU(:,2), 'red')
legend('u1','u2');

if saveFigures
    fileName = ['fig/', name, '_torques', '.png'];
    saveas(gcf,fileName)
end

% Plot angles vs time
figure()
plot(time, states(:, 1), 'red.')
hold on
plot(interT, interY(:, 2), 'blue', 'Linewidth', 2)
plot(interT, interY(:, 3), 'green', 'Linewidth', 2)
title('Angles vs time')
legend('q1','q2', 'q3')

if saveFigures
    fileName = ['fig/', name, '_q', '.png'];
    saveas(gcf,fileName)
end


% Plot hip speed vs time
[~, z_h, dx_h, ~] = kin_hip(interY(:, 1:3)', interY(:, 4:6)');


% Plot z vs step number
figure(3)

subplot(3,1,1)

plot(interT, z_h , 'blue');
title('Hip height vs step number')

% Plot hip displacement vs step number

subplot(3,1,2)

step_n_plus = firstStep:expandedLastStep;


plot(step_n_plus, diff(xhip_abs(firstStep:expandedLastStep+1)), 'blue')
hold on 
plot(step_n_plus, diff(xhip_abs(firstStep:expandedLastStep+1)), 'blue+', 'linewidth', 2)
title('Hip displacement vs step number')

subplot(3,1,3)
plot(interT, dx_h, 'blue')
title('Hip speed vs time')
if saveFigures
    fileName = ['fig/', name, '_hip', '.png'];
    saveas(gcf,fileName)
end




% Plot dq vs q
figure(4)

subplot(2,1,1);
plot(states(:, 1), states(:, 4), 'red.')
hold on
plot(states(:, 2), states(:, 5), 'blue.')
plot(states(:, 3), states(:, 6), 'green.')
title('dq vs q, all ');
legend('q1','q2','q3');

subplot(2,1,2); 
plot(interY(:, 1), interY(:, 4), 'red.')
hold on
plot(interY(:, 2), interY(:, 5), 'blue.')
plot(interY(:, 3), interY(:, 6), 'green.')

plot(interYE(:, 1), interYE(:, 4), 'red+', 'linewidth', 3)
hold on
plot(interYE(:, 2), interYE(:, 5), 'blue+', 'linewidth', 3)
plot(interYE(:, 3), interYE(:, 6), 'green+', 'linewidth', 3)
title('dq vs q, stable');
legend('q1','q2','q3', 'q1Event', 'q2Event', 'q3Event');

if saveFigures
    fileName = ['fig/', name, '_qdq', '.png'];
    saveas(gcf,fileName)
end
%% Step frequency

% Plot step frequency vs step number
figure(5)
subplot(4,1,1)

time_steps = [0;cell2mat((sln.TE)')];
t_diff = diff(time_steps);
plot(t_diff)
mean_freq = mean(t_diff(firstStep:end));
titleF = ['Frequency over step: mean(', num2str(mean_freq),')'];
title(titleF);
hold on; 
plot(t_diff, 'b+', 'linewidth', 2)
disp(['Mean Freq [m/s] = ', num2str(mean_freq)])

%% Step length

subplot(4,1,2)
stepL = diff(xhip_abs);
plot(stepL)
mean_length = mean(stepL(firstStep:end));
titleF = ['Stride over step: mean(', num2str(mean_length),')'];
title(titleF);
hold on; 
plot(stepL, 'b+', 'linewidth', 2)
disp(['Mean length [m/s] = ', num2str(mean_length)])
%% Speed

subplot(4,1,3)
time_steps = [0;cell2mat((sln.TE)')];
t_diff = diff(time_steps);
x_diff = diff(xhip_abs);
speed_vect = x_diff./t_diff;
plot(speed_vect)
mean_speed = mean(speed_vect(firstStep:end));
titleF = ['Speed over step: mean(', num2str(mean_speed),')'];
title(titleF);
hold on; 
plot(speed_vect, 'b+', 'linewidth', 2)
disp(['Mean Speed [m/s] = ', num2str(mean_speed)])


%% Cost of Transport
    % use Matlab function: trapz to compute integrals
    
[cot, mean_cot] = calculate_cot(sln, stableSteps);

subplot(4,1,4)
plot(cot, 'b');
hold on
plot(cot, 'b+', 'linewidth', 2);
titleF = ['Cot over steps: mean(', num2str(mean_cot),')'];
title(titleF);
disp(['Cost of Transport [J/m] = ', num2str(mean_cot)])
if saveFigures
    fileName = ['fig/', name, '_speed-cot', '.png'];
    saveas(gcf,fileName)
end
 

%% Variables to return 

meanValues.cot = mean_cot;
meanValues.speed = mean_speed;
meanValues.length = mean_length;
meanValues.freq = mean_freq;
meanValues.name = name; 

end
