function cost = eqns_opti(x)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%Constants for defining the cost function
S = 1;   %sampling rate
C = [1,50,50]; %weight for cost function
COST_FALL = 10000;
COST_TORSO = 100;
bool = 0;

%initializations
[q0, dq0,~, spread, v_target, num_steps] = control_hyper_parameters(); %should we define q0 dq0 with respecz to spead and q3_target??
[~, ~, ~, l1, ~, ~, ~] = set_parameters();
hip_height = l1* cos(spread/2);

%matching targeted speed at every step:
cost_array_x = zeros(floor(num_steps/S),1);

%keeping right hip height
cost_array_z = zeros(floor(num_steps/S),1);

%keeping torso at right angle
cost_array_torso = zeros(floor(num_steps/S),1);

Kp = x(1:2);
Kd = x(3:4);
q_des_torso = x(5);

[sln, r0] = solve_eqns(q0, dq0, num_steps, Kp, Kd,  q_des_torso);


%first itertion outside loop
q = sln.YE{1};
q = q(1:3);
[~, z_h] = kin_hip2(q);

if z_h <  hip_height/2
    cost_array_z(1) = COST_FALL;
else 
    cost_array_z(1) = (z_h -  hip_height)^2;
end
   
cost_array_torso(1) = (q(3) - q_des_torso)^2;

if abs(q(3) - q_des_torso) > deg2rad(10) 
    cost_array_torso(1) = COST_TORSO;
end


%does not take speed into account for first step
%t = sln.T{1}(end);
%t_pre = 0;
%cost_array_x(1) = ((r0(1)-x_h)/(t-t_pre) - v_target)^2;

j = 2;

for i =S+1:S:num_steps
    
    if length(sln.YE{i}) < 3
        bool = 1;
        break
    end
    
    q =sln.YE{i};
    q = q(1:3);
     
    t = sln.T{i}(end);
    t_pre = sln.T{i-S}(end);
    [x_h,z_h]  = kin_hip2(q);
    
    
    if z_h <  hip_height/2
        cost_array_z(j) = COST_FALL;
    else 
        cost_array_z(j) = (z_h -  hip_height)^2;
    end
    
    r = r0(i) - r0(i-S); %step length
    cost_array_x(j) = ((r-x_h)/(t-t_pre) - v_target)^2;
    cost_array_torso(j) = (q(3) - q_des_torso)^2;
    
    if abs(q(3) - q_des_torso) > deg2rad(10) 
        cost_array_torso(j) = COST_TORSO;
    end
    
    
    j = j+1;
end

t = sln.T{end}(end);
costx = sum(cost_array_x);
costz = sum(cost_array_z);
cost_torso = sum(cost_array_torso);
%global_costx = ((r0(end)-x_h)/t - v_target).^2; %average speed on all steps should match targeted speed

if bool
    cost = inf;
    disp("KAWABOUNGA")
else
    cost =  C(1)*costx + C(2)*costz + C(3)*cost_torso;
end
% + global_costx
 
end

