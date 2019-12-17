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

mat = [set1;set2;set3;set4;set5]
KP_torso = mat(:,1);
KP_spread = mat(:,2);
Kd_torso = mat(:,3);
Kd_spread = mat(:,4);
Q3_des = mat(:,5);
Spread = mat(:,6);

v_moy = [0.46;0.5;0.6;0.7;0.73];

figure()
plot(v_moy, KP_torso, 'red')
hold on
plot(v_moy, KP_spread, 'blue')
plot(v_moy, Kd_torso, 'yellow')
plot(v_moy, Kd_spread, 'cyan')
plot(v_moy, Q3_des, 'black')
plot(v_moy, Spread, 'green')

