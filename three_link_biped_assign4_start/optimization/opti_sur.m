function [x] = opti_sur()
%--------------------------------------------------------------------------
%   opti_sur : optimize the parameters for a PD controller with Surrogate
%
%   inputs:
%       o -
%   outputs:
%       o x : parameters of the controller
%             (Kp torso, Kp spread, Kd torso, Kd torso,
%             desired torso angle, desired spread angle)
%--------------------------------------------------------------------------

% Initalize the position at x0
x0  = [55, 25,10, 5, 0.005, 0.6]; % find by experimentation
opt = optimoptions('surrogateopt', 'MaxFunctionEvaluations', 500,... 
                   'InitialPoints', x0);

% Constraints (we want positive Kp and limited angles)
lb = [0,0,0,0,0,0];
ub = [1000, 1000, 1000,1000, deg2rad(45), deg2rad(90)];

% Solve the problem
[x, ~] = surrogateopt(@(x) eqns_opti(x),lb,ub,opt);

end
