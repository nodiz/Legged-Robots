function x = opti_gaVMC()
%UNTITLED6 Optimizes VMC parameters using genetic algorithm
%   Detailed explanation goes here

x0  = [55, 25,10, 5, 0.005, 0.6]; % start point away from the minimum

lower_bound = [0,0,0,0,0,0];
upper_bound = [100000, 100000, 100000,100000, 100000, deg2rad(45)];
nvars = length(lower_bound);


initpop = 10*randn(20,6) + repmat(x0,20,1);
opt = optimoptions('ga', 'InitialPopulationMatrix', initpop, 'UseParallel',true);
%solve problem
[x, fval, flag] = ga(@eqns_optiVMC,nvars,[],[],[],[],lower_bound,upper_bound,[], opt)

end

