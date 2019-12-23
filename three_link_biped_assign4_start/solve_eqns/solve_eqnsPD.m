function [sln, xhip_abs] = solve_eqnsPD(q0, dq0, num_steps, Kp, Kd,  q_des_torso, spread)
%--------------------------------------------------------------------------
%   solve_eqnsPD : solve the motion equation system for a PD
% Note: eqns.m defines the equations of motion to be solved by this script
% This function returns the time vector T, the solution Y, the event time
% TE, solution at the event time YE.
% q0, dq0 are the initial angles and angular velocities, num_steps are the
% number of steps the robot is supposed to take
% As an example you can use q0 = [pi/6; -pi/3; 0] and dq0 = [0;0;0]. 
%
%   inputs:
%       o q0           : initial joints angle
%       o dq0          : initial joints velocities
%       o num_steps    : number of the step 
%       o Kp           : Kp factors for PD
%       o Kd           : Kd factors for PD
%       o q_des_torso  : objective angle for the torse 
%       o spread       : objective angle for the spread angle
%   outputs:
%       o sln          : structure-solution of the system of motion
%       o xhip_abs     : vector of x position of the hip
%--------------------------------------------------------------------------

% Time vector generation
h = 0.001;         % time step
sln.h = h;
tmax = 2;          % max time that we allow for a single step
t0 = 0;
tspan = t0:h:tmax; % from 0 to tmax with time step h

% Initialization of table of position
r0 = zeros(num_steps+1,1);
xhip_abs = zeros(num_steps+1,1);
xhip0 = kin_hip(q0);
xhip_abs(1) = xhip0;
y0 = [q0; dq0];

% Options for ode45
opts = odeset('RelTol', 1e-5, 'Events', @event_func);

% we define the solution as a structure to simplify the post-analyses and
% animation, here we intialize it to null. 
sln.T = {};
sln.Y = {};
sln.TE = {};
sln.YE = {};

for i = 1:num_steps
    
    % compute the ode45 solution
   [T, Y, TE, YE] = ode45(@(t,y) eqnsPD(t, y, Kp, Kd,  q_des_torso, spread, i),tspan,y0,opts);% use ode45 to solve the equations of motion (eqns.m)
   sln.T{i} = T;
   sln.Y{i} = Y;
   sln.TE{i} = TE;
   sln.YE{i} = YE;
   
   for i2 = 1:length(T)
    	sln.U{i}(i2,1:2) = controlPD(Y(i2,1:3), Y(i2,4:6), Kp, Kd,  q_des_torso, spread)';
   end
   
   if T(end) == tmax
         break % if we exceed the 2 seconds for 1 step we kill the loop
   end
    
    % Impact map
    [x_swf,  ~, ~, ~] = kin_swf(YE(1:3), YE(4:6));
    [x_hip] = kin_hip(YE(1:3)');
    [q0,dq0] = impact(YE(1:3)', YE(4:6)');
    y0 = [q0;dq0];
   
    % Update time vector
    t0 = T(end);
    tmax = t0+2;
    tspan = t0:h:tmax;
    
    % Udpate x position of the swf and of the hip 
    r0(i+1) = r0(i)+ x_swf; 
    xhip_abs(i+1) = r0(i) + x_hip;
    
end

end


