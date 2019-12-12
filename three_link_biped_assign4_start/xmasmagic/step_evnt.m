function [value,isterminal,direction] = step_evnt(t, y)
% you may want to use kin_swf to set the 'value'
n = length(y);

if (y(2)>0)
    c = 1e-2;
else
    c = 2e-2;
end

[~,  z_swf, ~, ~] = kin_swf(y(1:n/2), y(n/2+1:n));
value = (z_swf + c) ; %z_swf = 0 when foot hits the ground
isterminal = 1;  %
direction = -1; %z_swf decreases before hitting the ground
end
