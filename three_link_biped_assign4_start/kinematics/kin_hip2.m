function [x_h, z_h] = kin_hip2(q)

q1 = q(1);
[~, ~, ~, l1, ~, ~, ~] = set_parameters();

x_h = l1*sin(q1);
z_h = l1*cos(q1);
end