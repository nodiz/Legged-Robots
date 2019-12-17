function cost = eqns_optiVMC(x)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%Constants for defining the cost function


 k = x(1:2);
 C_vmc = x(3:5);
 q_des_torso = x(6);


S = 1;   %sampling rate
C = [1,1,1]; %weight for cost function
bool = 0;

%initializations
[q0, dq0, ~, v_target, num_steps] = control_hyper_parameters(); %should we define q0 dq0 with respecz to spead and q3_target??
[~, ~, ~, l1, ~, ~, ~] = set_parameters();


%matching targeted speed at every step:
cost_array_x = zeros(floor(num_steps/S),1);

%keeping right hip height
cost_array_z = zeros(floor(num_steps/S),1);

%keeping torso at right angle
cost_array_torso = zeros(floor(num_steps/S),1);


%[sln, xhip_abs] = solve_eqns(q0, dq0, num_steps, Kp, Kd,  q_des_torso, spread);
[sln, xhip_abs] = solve_eqnsVMC(q0, dq0, num_steps, k, C_vmc,  q_des_torso);

%first itertion outside loop
q = sln.YE{1};
if q(3) > pi
    q(3) = q(3)-2*pi;
elseif q(3) < -pi
    q(3) = q(3) + 2*pi;
end
    

q = q(1:3);
hip_height = l1* cos(q(2));
[~, z_h] = kin_hip2(q);

cost_array_z(1) = (z_h -  hip_height)^2;
cost_array_torso(1) = (q(3) - q_des_torso)^2;


j = 2;

for i =S+1:S:num_steps
    
    if length(sln.YE) < i
        bool = 1;
        break
    end
    
    q =sln.YE{i};
    
    if length(q)<3
        bool = 1;
        break
    end
    q = q(1:3);
    hip_height = l1* cos(q(2));
    
    t = sln.T{i}(end);
    t_pre = sln.T{i-S}(end);
    [~,z_h]  = kin_hip2(q);
    
   
    cost_array_z(j) = (z_h -  hip_height)^2;
    

    delta_xhip = xhip_abs(i+1) - xhip_abs(i);
    cost_array_x(j) = (delta_xhip/(t-t_pre) - v_target)^2;
    cost_array_torso(j) = (q(3) - q_des_torso)^2;
    
    j = j+1;
end

t = sln.T{end}(end);
costx = sum(cost_array_x);
costz = sum(cost_array_z);
cost_torso = sum(cost_array_torso);
%global_costx = ((r0(end)-x_h)/t - v_target).^2; %average speed on all steps should match targeted speed

if bool
    cost = inf;
else
    cost =  C(1)*costx + C(2)*costz + C(3)*cost_torso;
end

end


