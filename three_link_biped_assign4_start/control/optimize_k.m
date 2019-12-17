function [x] = optimize_k()
%UNTITLED Optimizes Kp and Kd
%   Detailed explanation goes here

%initial point for optimizatio
%x0  = [500, 900,18, 18, 0.10, deg2rad(30)]; %x1, x2 = Kp ; x3, x4 = Kd, x5 = q_des_torso
fval_best = Inf;
x = [500, 900,18, 18, 0.10, deg2rad(30)];
%constraints
lower_bound = [0,0,0,0,0,0];
upper_bound = [1000, 1000, 1000,1000, deg2rad(45), deg2rad(90)];


for start = 1:1
    x0 = lower_bound + rand(size(lower_bound)).*(upper_bound - lower_bound);
    %solve problem
    [new_x, fval] = patternsearch(@eqns_opti,x0,[],[],[],[],lower_bound, upper_bound);
    if fval < fval_best
        x = new_x;
        fval_best = fval
    end
end
end




