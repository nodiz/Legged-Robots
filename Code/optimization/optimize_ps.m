function [x] = optimize_ps()
%--------------------------------------------------------------------------
%   optimize_ps : optimize the parameters for a PD controller with a 
%                 pattern search algorithm
%
%   inputs:
%       o -
%   outputs:
%      o x : parameters of the controller
%            (Kp torso, Kp spread, Kd torso, Kd torso,
%            desired torso angle, desired spread angle)
%--------------------------------------------------------------------------

% Initial position x0
x0 = [500, 900,18, 18, 0.10, deg2rad(30)]; % find by experimentation

% Constraints (we want positive Kp and limited angles)
lower_bound = [0,0,0,0,0,0];
upper_bound = [1000, 1000, 1000,1000, deg2rad(45), deg2rad(90)];

% Solve the problem
[x, ~] = patternsearch(@eqns_opti,x0,[],[],[],[], ...
                       lower_bound, upper_bound);

end




