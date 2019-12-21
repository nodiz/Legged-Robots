function [x] = opti_ga()
%--------------------------------------------------------------------------
%   opti_ga : optimize the parameters for a PD controller with a genetic
%             algorithm
%
%   inputs:
%       o -
%   outputs:
%      o x : parameters of the controller
%            (Kp torso, Kp spread, Kd torso, Kd torso,
%            desired torso angle, desired spread angle)
%--------------------------------------------------------------------------

% Generate initial population around x0 
x0  = [55, 25,10, 5, 0.005, 0.6]; % find by experimentation
initpop = 10*randn(20,6) + repmat(x0,20,1);
opt = optimoptions('ga', 'InitialPopulationMatrix', initpop);

% Constraints (we want positive Kp and limited angles)
lower_bound = [0,0,0,0,0,0];
upper_bound = [1000, 1000, 1000, 1000, deg2rad(45), deg2rad(90)];

% Solve the problem
nvars = length(lower_bound);
[x, ~, ~] = ga(@(x) eqns_opti(x),nvars,[],[],[],[],...
               lower_bound,upper_bound,[], opt);

end

