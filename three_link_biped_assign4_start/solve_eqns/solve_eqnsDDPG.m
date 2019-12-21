% Note: eqns.m defines the equations of motion to be solved by this script
% This function returns the time vector T, the solution Y, the event time
% TE, solution at the event time YE.
% q0, dq0 are the initial angles and angular velocities, num_steps are the
% number of steps the robot is supposed to take
% As an example you can use q0 = [pi/6; -pi/3; 0] and dq0 = [0;0;0]. 

function [sln, xhip_abs] = solve_eqnsDDPG(q0, dq0, num_steps)

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

xhip0 = kin_hip(q0);
xhip_abs(1) = xhip0;

opts = odeset('RelTol', 1e-5, 'Events', @step_evnt);

% we define the solution as a structure to simplify the post-analyses and
% animation, here we intialize it to null. 
sln.T = {};
sln.Y = {};
sln.TE = {};
sln.YE = {};

%


for i = 1:num_steps
    
   [T, Y, TE, YE] = ode45(@(t,y) eqnsDDPG(t, y),tspan,y0,opts);% use ode45 to solve the equations of motion (eqns.m)
   sln.T{i} = T;
   sln.Y{i} = Y;
   sln.TE{i} = TE;
   sln.YE{i} = YE;
   
   for i2 = 1:length(T)
        sln.U{i}(i2, 1:2) = 
   end
   
   if T(end) == tmax
         break
   end
    
    % Impact map
    [x_swf,  ~, ~, ~] = kin_swf(YE(1:3), YE(4:6));
    [x_hip] = kin_hip(YE(1:3)');
   
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


end


