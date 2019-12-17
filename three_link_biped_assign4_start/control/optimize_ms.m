function [x] = optimize_ms()
%UNTITLED Optimizes Kp and Kd
%   Detailed explanation goes here
rng default % For reproducibility
%initial point for optimizatio
x0  = [55, 25,10, 5, 0.005, 0.6]; % start point away from the minimum

%constraints
lower_bound = [0,0,0,0,0,0];
upper_bound = [1000, 1000, 1000,1000, deg2rad(45), deg2rad(90)];


problem = createOptimProblem('fmincon','objective',@eqns_opti,'x0',x0,'lb',lower_bound,'ub',upper_bound);
ms = MultiStart('StartPointsToRun','bounds', 'UseParallel', true);

%solve problem
[x,fval] = run(ms,problem,5)
end




