function [x] = opti_ga(i)
%OPTI_GA Optimize with genetic algorithm


%initial point for optimizatio
%x0  = [500, 900,18, 18, 0.10, deg2rad(30)]; %x1, x2 = Kp ; x3, x4 = Kd, x5 = q_des_torso

%constraints
x0  = [55, 25,10, 5, 0.005, 0.6]; % start point away from the minimum


lower_bound = [0,0,0,0,0,0];
upper_bound = [Inf, Inf, Inf,Inf, deg2rad(45), deg2rad(90)];
nvars = length(lower_bound);


initpop = 10*randn(20,6) + repmat(x0,20,1);
opt = optimoptions('ga', 'InitialPopulationMatrix', initpop, 'FunctionTolerance', 1e-4, 'UseParallel',true);
%solve problem
[x, fval, flag] = ga(@(x) eqns_opti(x,i),nvars,[],[],[],[],lower_bound,upper_bound,[], opt)

end

