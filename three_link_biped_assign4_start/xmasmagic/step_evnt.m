function [value,isterminal,direction] = step_evnt(t, y)
% you may want to use kin_swf to set the 'value'
n = 6;

[~,  z_swf, ~, ~] = kin_swf(y(1:n/2), y(n/2+1:n));
value = (z_swf + 1e-2) ; %z_swf = 0 when foot hits the ground
isterminal = 1;  %
direction = -1; %z_swf decreases before hitting the ground
end
