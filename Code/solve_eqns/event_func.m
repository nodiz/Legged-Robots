function [value,isterminal,direction] = event_func(t, y)
%--------------------------------------------------------------------------
%   event_func : detect when the bidep hits the ground to switch legs
% This function defines the event function.
% In the three link biped, the event occurs when the swing foot hits the
% ground.
%
%   inputs:
%       o t          : time vector
%       o y          : angle and derivate vector
%   outputs:
%       o value      : z position of the swf
%       o isterminal : boolean : stop the solve if 0 is reached
%       o direction  : indicates if we reach the value from upside or down
%--------------------------------------------------------------------------

tol = 1e-2;
[~,  z_swf, ~, ~] = kin_swf(y(1:3), y(4:6));

value = (z_swf + tol);
isterminal = 1;         % stop the solve when 0 reached
direction = -1;         % z_swf decreases before hitting the ground

end
