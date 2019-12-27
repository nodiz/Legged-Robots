function [x_h, z_h, dx_h, dz_h] = kin_hip(q, dq)
%--------------------------------------------------------------------------
%   kin_hip : compute the position and the velocity of the hip from angles
%
%   inputs:
%       o q         : angles of the system
%       o dq        : derivate of the angle
%   outputs:
%       o x_h       : x position of the hip
%       o z_h       : z position of the hip
%       o dx_h      : x velocity of the hip
%       o dz_h      : z velocity of the hip
%--------------------------------------------------------------------------

if nargin == 1
    dq = zeros(3, 1);
end

q1 = q(1, :);
dq1 = dq(1, :);
[~, ~, ~, l1, ~, ~, ~] = set_parameters();

x_h = l1.*sin(q1);
z_h = l1.*cos(q1);
dx_h = dq1.*l1.*cos(q1);
dz_h = -dq1.*l1.*sin(q1);

end