function dy = eqnsPD(t, y, Kp, Kd,  q_des_torso, spread, step_n)
%--------------------------------------------------------------------------
%   eqns : compute the variation in y : dy and ddy (for PD)
%
%   inputs:
%       o t            : time vector 
%       o y            : angle and derivate vector
%       o Kp           : Kp of the PD
%       o Kd           : Kd of the PD
%       o q_des_torso  : objective angle for the torse
%       o spread       : objective angle for the spread
%       o step_n       : number of the step
%   outputs:
%       o dy           : variation of y : dy and ddy
%--------------------------------------------------------------------------

% Extract q and dq
q = y(1:3);
dq = y(4:6);

% Apply the control and the noise
u = controlPD(q, dq, Kp, Kd,  q_des_torso, spread);
u = add_noise(u, q, step_n);

% Intialize dy and download system matrix
dy = zeros(6, 1);
M = eval_M(q);
G = eval_G(q);
C = eval_C(q,dq);
B = eval_B();

% Compute dq
dy(1:3) = dq;
% Compute ddq with the system equation
b =B*u-G-C*dq;
dy(4:6) = M\b; %ddq

end