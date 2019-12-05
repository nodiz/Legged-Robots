simOpts = rlSimulationOptions('MaxSteps',500);
experience = sim(env,agent,simOpts);
dataq = experience.Observation.LarryStates.Data(1:3,:,:);
datadq = experience.Observation.LarryStates.Data(4:6,:,:);
num_steps = length(experience.Observation.LarryStates.Data);
h = 0.01;
figure();

r0 = [0; 0];
tic();
for ji = 1:num_steps
    q = dataq(:,1,ji);
    dq = datadq(:,1,ji);
    pause(h);  % pause for 2 mili-seconds
    % visualize :
    visualize(q, r0);
    hold off
    % update r0:
    [x, ~, dx, ~] = kin_hip(q, dq);
    r0 = r0 + [dx*h;0];
   
    
end
t_anim = toc();

% Real time factor is the actual duration of the simulations (get it from sln) to
% the time it takes for MATLAB to animate the simulations (get it from
% t_anim). How does 'skip' effect this value? what does a real time factor
% of 1 mean?
real_time_factor = h*num_steps/t_anim;% This is only an estimation 
fprintf('Real time factor:');
disp(real_time_factor);

