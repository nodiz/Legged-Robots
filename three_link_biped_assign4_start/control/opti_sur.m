function [x] = opti_sur(i)
%OPTI_GA Optimize with genetic algorithm


%initial point for optimizatio
%x0  = [500, 900,18, 18, 0.10, deg2rad(30)]; %x1, x2 = Kp ; x3, x4 = Kd, x5 = q_des_torso

%constraints
x0  = [55, 25,10, 5, 0.005, 0.6]; % start point away from the minimum
initpop = 10*randn(20,6) + repmat(x0,20,1);

lb = [0,0,0,0,0,0];
ub = [1000, 1000, 1000,1000, deg2rad(45), deg2rad(90)];

%opt = optimoptions('surrogateopt', 'InitialPoints',initpop);
%solve problem
[x, fval] = surrogateopt(@(x) eqns_opti(x,i),lb,ub)
endz
