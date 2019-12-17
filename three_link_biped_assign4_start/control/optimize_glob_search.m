function [x] = optimize_glob_search()
%Oprimizing with global search
%   Detailed explanation goes here

rng default % For reproducibility
gs = GlobalSearch('NumTrialPoints',3e4,'NumStageOnePoints', 1042, 'BasinRadiusFactor', 0.5, 'MaxWaitCycle', 42, 'StartPointsToRun', 'bounds');

%Starting point for opti
x0  = [500, 500 ,18, 18, 0.1, deg2rad(30)]; %KP1, KP2, KD1, KD2, q3_des, spread

%Constraints
lower_bound = [0,0,0,0,0,0];
upper_bound = [Inf, Inf, Inf,Inf, deg2rad(45), deg2rad(180)];

%defining problem
problem = createOptimProblem('fmincon', 'x0', x0, 'objective', @eqns_opti, 'lb', lower_bound, 'ub', upper_bound);

%solve problem with global search
[x, fval] = run(gs,problem)

end

