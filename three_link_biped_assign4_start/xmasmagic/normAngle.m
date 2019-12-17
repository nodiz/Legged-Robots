function [q_rew] = normAngle(q)
%TWOPIANGLE Convert angle in the ragne -pi, pifor index = 1:3

q_rew = zeros(size(q));
q_mod = mod(q, 2*pi);

for index = 1:length(q)
    if q_mod(index) < pi
        q_rew(index) = q_mod(index);
    else
        q_rew(index) = q_mod(index) - 2*pi;
    end

end

