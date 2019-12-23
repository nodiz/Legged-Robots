function dy = eqnsVMC(t, y, k, C,  q_des_torso, x_des, v_target, step_number)
%--------------------------------------------------------------------------
%   eqnsVMC : compute the variation in y : dy and ddy (for VMC)
%
%   inputs:
%       o t            : time vector 
%       o y            : angle and derivate vector
%       o k            : spring factor for the VMC
%       o C            : damping factor for the VMC
%       o q_des_torso  : objective angle for the torse
%       o x_des        : objective x
%       o step_number  : number of the step
%   outputs:
%       o dy           : variation of y : dy and ddy
%--------------------------------------------------------------------------

n = 6;

% Extract q and dq
q = y(1:3);
dq = y(4:6);

% Apply the control and the noise
u = controlVMC(q,dq, k, C, q_des_torso, x_des, v_target);
u = add_noise(u, q, step_number);

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

