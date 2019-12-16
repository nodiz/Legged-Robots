function u = pdgen(q, dq)

u = zeros(2,1); 

Kp = [485, 856];
Kd = [19.4, 19.8];
q_des_torso = 0.09;
spread = 0.34;

error_torso   = -q_des_torso  + q(3);
error_d_torso =  dq(3);

error_spread   = -q(2)  + q(1) - spread;
error_d_spread = -dq(2) + dq(1);

u(1) = Kp(1)*error_torso  + Kd(1)*error_d_torso;
u(2) = Kp(2)*error_spread + Kd(2)*error_d_spread;

if u(1) > 0
    u(1) = min(30,u(1));
else
    u(1) = max(-30,u(1));
end

if u(2) > 0
    u(2) = min(30,u(2));
else
    u(2) = max(-30,u(2));
end
