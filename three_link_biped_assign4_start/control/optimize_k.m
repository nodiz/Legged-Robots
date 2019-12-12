function [x] = optimize_k()
%UNTITLED Optimizes Kp and Kd
%   Detailed explanation goes here

%initial point for optimizatio
x0  = [117, 270,18, 4.8, 0.22, deg2rad(20)]; %x1, x2 = Kp ; x3, x4 = Kd, x5 = q_des_torso

%constraints
A   = [-1,0,0,0,0,0;0,-1,0,0,0,0;0,0,-1,0,0,0;0,0,0,-1,0,0;0,0,0,0,-1,0;0,0,0,0,0,-1];
b   = [0,0,0,0,0,0];

%solve problem
[x, fval, flag] = patternsearch(@eqns_opti,x0,A,b)

end
