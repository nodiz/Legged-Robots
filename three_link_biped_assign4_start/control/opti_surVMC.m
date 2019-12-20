function [x] = opti_surVMC(i_speed)
%OPTI_GA Optimize with genetic algorithm

[~, ~, ~, l1, ~, ~, ~] = set_parameters();
%initial point for optimizatio
%x0  = [500, 900,18, 18, 0.10, deg2rad(30)]; %x1, x2 = Kp ; x3, x4 = Kd, x5 = q_des_torso

%constraints
x0  = [100, 100,100, 10, 10, 10, deg2rad(5), 0.1]; % start point away from the minimum
%initpop = 10*randn(20,6) + repmat(x0,20,1);

lb = [0,0,0,0,0,0,0,0];
ub = [100000, 100000, 100000,10000,10000,10000, deg2rad(45), l1]; %k, C, q_des_torso, x_des
opt = optimoptions('surrogateopt', 'MaxFunctionEvaluations', 100, 'InitialPoints', x0, 'ObjectiveLimit', 0.05);

%solve problem
[x, fval] = surrogateopt(@(x) eqns_optiVMC(x, i_speed),lb,ub, opt)
