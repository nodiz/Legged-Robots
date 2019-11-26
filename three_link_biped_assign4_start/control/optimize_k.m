function [Kp,Kd] = optimize_k(q0, dq0, num_steps)
%UNTITLED Optimizes Kp and Kd
%   Detailed explanation goes here

[~, ~, ~, l1, ~, ~, ~] = set_parameters();


%define optimization variables
Kp = optimvar('Kp',2,1,'LowerBound',0);
Kd = optimvar('Kd1',2,1,'LowerBound',0);



[q, dq] = var.YE{end};

var = solve_eqns(q0, dq0, num_steps);


prob = optimproblem('Objective','max');
prob.Objective = l1*sin(q(1));

cons1 = var

% linprob.Constraints.cons1 = I1 - HE1 <= 132000;
% linprob.Constraints.cons2 = EP + PP >= 12000;

linprob.Constraints.econs1 = LE2 + HE2 == I2;
linprob.Constraints.econs2 = LE1 + LE2 + BF2 == LPS;



outputArg1 = inputArg1;
outputArg2 = inputArg2;
end

