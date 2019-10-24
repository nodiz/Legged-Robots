%% 
% This function defines the event function.
% In the three link biped, the event occurs when the swing foot hits the
% ground.
%%
function [value,isterminal,direction] = event_func(t, y)

% you may want to use kin_swf to set the 'value'
n = 6;

[~,  z_swf, ~, ~] = kin_swf(y(1:n/2), y(n/2+1:n));



value = z_swf + 1e-3; %z_swf = 0 when foot hits the ground
isterminal = 1;  %
direction = -1; %z_swf decreases before hitting the ground

end
