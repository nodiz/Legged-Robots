function [x] = opti_surVMC()
%--------------------------------------------------------------------------
%   optiVMC : optimize the parameters for a VMC controller with a Surrogate
%
%   inputs:
%       o -
%   outputs:
%       o x : parameters of the controller 
%             k for spring, C for amortizer
%             (k swf, k q2, k q3, C speed, C swf, C q3,
%             desired torso angle, desired spread angle)
%--------------------------------------------------------------------------

[~, ~, ~, l1, ~, ~, ~] = set_parameters();

% Generate initial population around x0 
x0  = [100, 100,100, 10, 10, 10, deg2rad(5), 0.1];% find by experimentation

% Constraints (we want positive Kp and limited angles)
lb = [0,0,0,0,0,0,0,0];
ub = [10000, 10000, 10000,1000,1000,1000, deg2rad(45), l1];

% Solve the problem with the following options
opt = optimoptions('surrogateopt', 'MaxFunctionEvaluations', 500, ...
                   'InitialPoints', x0);
[x, ~] = surrogateopt(@(x) eqns_optiVMC(x),lb,ub, opt);

end
