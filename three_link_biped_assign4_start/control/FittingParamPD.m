load('w_v0.46_ms.mat', 'x');
set1 = x;
load('w_v0.5_ms.mat', 'x');
set2 = x;
load('w_v0.6_ms.mat', 'x');
set3 = x;
load('w_v0.7_ms.mat', 'x');
set4 = x;
load('w_v0.73_ms.mat', 'x');
set5 = x;
load('w_0.54.mat', 'x');
set6 = x;
load('w_0.62.mat', 'x');
set7 = x;
load('w_v0.58.mat', 'x');
set8 = x;
load('w_v0.37_ga.mat', 'x');
set9 = x;
mat = [set1;set2;set3;set4;set5;set6;set7;set8;set9];

v_moy = zeros(1, 8);
for i = 1:length(mat)
    x = mat(i,:);
    [sln, xhip_abs] = solve_eqns([0.28; -0.22; -0.023],[1.87;1.98;-0.44],30,x(1:2), x(3:4), x(5), x(6));
    dist = xhip_abs(end)-xhip_abs(2);
    time = sln.TE{end}-sln.TE{1};
    v_moy(i) = dist/time;
end

KP_torso = mat(:,1);
KP_spread = mat(:,2);
Kd_torso = mat(:,3);
Kd_spread = mat(:,4);
Q3_des = mat(:,5);
Spread = mat(:,6);

v_moy = sort(v_moy)

figure()
plot(v_moy, KP_torso, 'r*')
title('KP-Torso')
figure()
plot(v_moy, KP_spread, 'b*')
title('KP-spread')
figure()
plot(v_moy, Kd_torso, 'y*')
title('Kd-Torso')
figure()
plot(v_moy, Kd_spread, 'c*')
title('Kd-spread')
figure()
plot(v_moy, Q3_des, 'b*')
title('Q3_des')
figure()
plot(v_moy, Spread, 'b*')
title('spread')
