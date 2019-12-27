function cost = eqns_optiVMC(x)
%--------------------------------------------------------------------------
%   eqns_optiVMC : cost function for the optimization of the VMC
%
%   inputs:
%       o x         : parameters of the controller 
%                     k for spring, C for amortizer
%                     (k swf, k q2, k q3, C speed, C swf, C q3,
%                     desired torso angle, desired spread angle)
%   outputs:
%       o cost      : cost for the given parameters
%--------------------------------------------------------------------------

%Constants for defining the cost function

% Parameters of the controller to evaluate
k = x(1:3);
C_vmc = x(4:6);
q_des_torso = x(7);
x_des = x(8);

% Parameters of the system
[q0, dq0, ~, v_target, num_steps] = control_hyper_parameters();
[~, ~, ~, l1, ~, ~, ~] = set_parameters();

% Constants for the cost function
S = 1;        % sampling rate
C = [50,5,1]; % weight for cost function
fell = 0;
PENALTY = 1000;

%matching targeted speed at every step:
cost_array_x = zeros(floor(num_steps/S),1);

%keeping right hip height
cost_array_z = zeros(floor(num_steps/S),1);

%keeping torso at right angle
cost_array_torso = zeros(floor(num_steps/S),1);

%avoid step behind stance leg
cost_array_penalty = zeros(floor(num_steps/S),1);

% Solve the motion system
[sln, xhip_abs] = solve_eqnsVMC(q0, dq0, num_steps, k, C_vmc,...
                                q_des_torso, x_des, i_speed);

%first itertion outside loop
q = sln.YE{1};
q = q(1:3);
hip_height = sqrt(l1^2-x_des^2);
[~, z_h] = kin_hip(q');
% Cost of the 1st step (for the first we don't care about the speed)
cost_array_z(1) = (z_h -  hip_height)^2;
cost_array_torso(1) = (q(3) - q_des_torso)^2;

j = 2;
for i =S+1:S:num_steps
    
    % Interupt the process in case the robot fell
    if length(sln.YE) < i
        fell = 1;
        break
    end
    q =sln.YE{i};
    % Interupt the process in case the robot fell
    if length(q)<3
        fell = 1;
        break
    end
    
    q = q(1:3);
    
    % Udpate time and positions
    hip_height = l1* cos(q(2));
    t = sln.T{i}(end);
    t_pre = sln.T{i-S}(end);
    [x_h,z_h]  = kin_hip(q');
    delta_xhip = xhip_abs(i+1) - xhip_abs(i);
    
    % Update the costs
    cost_array_z(j) = (z_h -  hip_height)^2;
    cost_array_x(j) = (delta_xhip/(t-t_pre) - v_target)^2;
    cost_array_torso(j) = (q(3) - q_des_torso)^2;
    if x_h < 0 %if robot steps behind stance leg
        cost_array_penalty(i) = PENALTY;
    end
    
    j = j+1;
end

if fell % if he fell that is the worst solution --> inf cost
    cost = inf;
else  % Compute the global cost
    costx = sum(cost_array_x);
    costz = sum(cost_array_z);
    cost_torso = sum(cost_array_torso);
    cost_penalty = sum(cost_array_penalty);
    cost =  C(1)*costx + C(2)*costz + C(3)*cost_torso + cost_penalty;
end

end


