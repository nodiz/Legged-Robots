function [x] = optimize_k()
%UNTITLED Optimizes Kp and Kd
%   Detailed explanation goes here

%initial point for optimizatio
x0  = [300,100,60, 20, deg2rad(10)]; %x1, x2 = Kp ; x3, x4 = Kd, x5 = q_des_torso

%constraints
A   = [-1,0,0,0,0;0,-1,0,0,0;0,0,-1,0,0;0,0,0,-1,0;0,0,0,0,-1];
b   = [0,0,0,0,0];

%solve problem
x = fmincon(@eqns_opti,x0,A,b);

end

