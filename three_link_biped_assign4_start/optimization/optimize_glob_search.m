function [x] = optimize_glob_search()
%--------------------------------------------------------------------------
%   optimize_glob_search : optimize the parameters for a PD controller 
%                          with a optimize global search
%
%   inputs:
%       o -
%   outputs:
%      o x : parameters of the controller
%            (Kp torso, Kp spread, Kd torso, Kd torso,
%            desired torso angle, desired spread angle)
%--------------------------------------------------------------------------

rng default % For reproducibility

% Generate initial population around x0 
x0  = [500, 500 ,18, 18, 0.1, deg2rad(30)];

% Constraints (we want positive Kp and limited angles)
lower_bound = [0,0,0,0,0,0];
upper_bound = [Inf, Inf, Inf,Inf, deg2rad(45), deg2rad(180)];

% Define the problem and the parmeters of the algorithm
gs = GlobalSearch('NumTrialPoints',3e4,'NumStageOnePoints', 1042, ...
                  'BasinRadiusFactor', 0.5, 'MaxWaitCycle', 42,   ...
                  'StartPointsToRun', 'bounds');
problem = createOptimProblem('fmincon', 'x0', x0, 'objective', ...
                 @eqns_opti, 'lb', lower_bound, 'ub', upper_bound);

% Solve the problem
[x, ~] = run(gs,problem);

end

