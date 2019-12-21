function [x] = optimize_ms()
%--------------------------------------------------------------------------
%   optimize_ms : optimize the parameters for a PD controller with a 
%                 multi start algorithm
%                 
%   inputs:
%       o -
%   outputs:
%      o x : parameters of the controller
%            (Kp torso, Kp spread, Kd torso, Kd torso,
%            desired torso angle, desired spread angle)
%--------------------------------------------------------------------------

rng default % For reproducibility

% Initial position
x0  = [55, 25,10, 5, 0.005, 0.6]; % find by experimentation

% Constraints (we want positive Kp and limited angles)
lower_bound = [0,0,0,0,0,0];
upper_bound = [1000, 1000, 1000,1000, deg2rad(45), deg2rad(90)];

% Problem generation
problem = createOptimProblem('fmincon','objective', ...
          @eqns_opti,'x0',x0,'lb',lower_bound,'ub',upper_bound);
ms = MultiStart('StartPointsToRun','bounds');

% Solve the problem
n_start_point = 5;
[x,~] = run(ms, problem, n_start_point);

end




