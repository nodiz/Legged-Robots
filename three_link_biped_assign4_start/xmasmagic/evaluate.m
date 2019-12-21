simOpts = rlSimulationOptions('MaxSteps',500);
saveVideo = 1;
experience = sim(env,saved_agent,simOpts);
d = experience.Observation.lbro.Data;
dataq = d(1:3,:);
datadq = d(4:6,:);
num_steps = length(d);
h = 0.01;
figure();

if saveVideo
    videoName = ['videos/', 't', '.avi'];
    writerObj = VideoWriter(videoName);
    writerObj.FrameRate = 1/h/5;
    open(writerObj);
end

r0 = [0; 0];
tic();
for ji = 1:num_steps
    q = dataq(:,ji);
    dq = datadq(:,ji);
    % pause(h);  % pause for 2 mili-seconds
    % visualize :
    visualize(q, r0);
    if saveVideo
        F = getframe(gcf) ;
        writeVideo(writerObj, F);
    end
    hold off
    % update r0:
    [x, ~, dx, ~] = kin_hip(q, dq);
    r0 = r0 + [dx*h;0]; 
end
t_anim = toc();
if saveVideo
    close(writerObj);
end

% Real time factor is the actual duration of the simulations (get it from sln) to
% the time it takes for MATLAB to animate the simulations (get it from
% t_anim). How does 'skip' effect this value? what does a real time factor
% of 1 mean?
real_time_factor = h*num_steps/t_anim;% This is only an estimation 
fprintf('Real time factor:');
disp(real_time_factor);
dsp(r0(1));