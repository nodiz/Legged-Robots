function [x_swf, z_swf, dx_swf, dz_swf] = kin_swf(q, dq)
%--------------------------------------------------------------------------
%   kin_swf : compute the position and the velocity of the swing foot
%
%   inputs:
%       o q           : angles of the system
%       o dq          : derivate of the angle
%   outputs:
%       o x_swf       : x position of the swing foot
%       o z_swf       : z position of the swing foot
%       o dx_swf      : x velocity of the swing foot
%       o dz_swf      : z velocity of the swing foot
%--------------------------------------------------------------------------

if nargin == 1
    dq = zeros(3, 1);
end

q1 = q(1);
dq1 = dq(1);
q2 = q(2);
dq2 = dq(2);

[~, ~, ~, l1, l2, ~, ~] = set_parameters();

x_swf = l1*sin(q1) - l2*sin(q2);
z_swf = l1*cos(q1) - l2*cos(q2);
dx_swf = dq1*l1*cos(q1) - dq2*l2*cos(q2);
dz_swf = dq2*l2*sin(q2) - dq1*l1*sin(q1);

end