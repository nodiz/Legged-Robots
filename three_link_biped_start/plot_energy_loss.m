
size = 100;
alpha = linspace(0,pi/4,size);
q_m = zeros(3,size);
dq_m = [1;0.2;0];

q_p = zeros(3,size);
dq_p = zeros(3,size);
T1 = zeros(1,size);
T2 = zeros(1,size);
energy_loss = zeros(1,size);

for i = 1:size
    q_m(:,i) = [alpha(i);-alpha(i);0];
    [q_p(:,i), dq_p(:,i)] = impact(q_m(:,i), dq_m);
    
    T1(i) = eval_energy(q_m(:,i),dq_m);
    T2(i) = eval_energy(q_p(:,i),dq_p(:,i));
    
    energy_loss(i) = (T2(i)-T1(i))/T1(i);
    
end

plot(energy_loss, alpha);
