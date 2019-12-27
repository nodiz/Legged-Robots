function [q0, dq0, dq_des_torso, v_target, num_steps] ...
                                               = control_hyper_parameters()
%--------------------------------------------------------------------------
%   control_hyper_parameters : parameters to control the whole program
%
%   inputs:
%       o -
%   outputs:
%       o q0            : initial angle of the robot
%       o dq0           : intial velocity of the joints
%       o dq_des_torso  : deisired velocity of the torso joint
%       o v_target      : velocity that we want to achieve
%       o num_steps     : number of steps that we want to achieve
%--------------------------------------------------------------------------

v_target = [];
q0  = [0.28; -0.22; -0.023];
dq0 = [1.87;1.98;-0.44];
dq_des_torso = 0;
num_steps = 30;

end
