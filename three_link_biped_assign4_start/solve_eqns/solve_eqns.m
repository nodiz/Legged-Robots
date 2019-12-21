        %% Solve equations of motion 
% Note: eqns.m defines the equations of motion to be solved by this script
% This function returns the time vector T, the solution Y, the event time
% TE, solution at the event time YE.
% q0, dq0 are the initial angles and angular velocities, num_steps are the
% number of steps the robot is supposed to take
% As an example you can use q0 = [pi/6; -pi/3; 0] and dq0 = [0;0;0]. 

function [sln, xhip_abs] = solve_eqns(q0, dq0, num_steps, Kp, Kd,  q_des_torso, spread)
global u_vect;
u_vect = [];
global t_vect;
t_vect = [];
global dq_vect;
dq_vect = [];


r0 = zeros(num_steps+1,1);
xhip_abs = zeros(num_steps+1,1);
h = 0.001; % time step
tmax = 2; % max time that we allow for a single step
t0 = 0;
tspan = t0:h:tmax; % from 0 to tmax with time step h
y0 = [q0; dq0];

xhip0 = kin_hip2(q0);
xhip_abs(1) = xhip0;

opts = odeset('RelTol', 1e-5, 'Events', @event_func);

% we define the solution as a structure to simplify the post-analyses and
% animation, here we intialize it to null. 
sln.T = {};
sln.Y = {};
sln.TE = {};
sln.YE = {};

%


for i = 1:num_steps
    
   [T, Y, TE, YE] = ode45(@(t,y) eqns(t, y, Kp, Kd,  q_des_torso, spread, i),tspan,y0,opts);% use ode45 to solve the equations of motion (eqns.m)
   sln.T{i} = T;
   sln.Y{i} = Y;
   sln.TE{i} = TE;
   sln.YE{i} = YE;
   
   if T(end) == tmax
         break
   end
    
    % Impact map
    [x_swf,  ~, ~, ~] = kin_swf(YE(1:3), YE(4:6));
    [x_hip] = kin_hip2(YE(1:3));
   
    t0 = T(end);
    tmax = t0+2;
    tspan = t0:h:tmax;
    
    [q0,dq0] = impact(YE(1:3)', YE(4:6)');
    y0 = [q0;dq0];
     
    r0(i+1) = r0(i)+ x_swf; %global xcoordinate. Useful for cost fct
    
    xhip_abs(i+1) = r0(i) + x_hip;
    
   
    
%     if x_swf > 0
%         [q0,dq0] = impact(YE(1:3)', YE(4:6)');
%        
%     else
%         y0 = [YE(1:3); YE(4:6)];
%     end
    
   
end
r0 = r0(2:end);

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


