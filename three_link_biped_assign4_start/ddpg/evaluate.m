%% Params

saveVideo = 0;
nsteps = 500;

%% Running simulation

simOpts = rlSimulationOptions('MaxSteps',nsteps);
experience = sim(env,saved_agent,simOpts);

if saveVideo
    videoName = ['videos/', 't', '.avi'];
    writerObj = VideoWriter(videoName);
    writerObj.FrameRate = 1/h/5;
    open(writerObj);
end

d = experience.Observation.State.Data;
dataq = d(1:3,:);
datadq = d(4:6,:);
num_steps = length(d); % may be different from nsteps if robot falls


%% Show 

h = 0.01;
figure();
r0 = [0; 0];
tic();
for ji = 1:num_steps
    q = dataq(:,ji);
    dq = datadq(:,ji);
    
    visualize(q, r0);
    
    if saveVideo
        F = getframe(gcf) ;
        writeVideo(writerObj, F);
    else 
        pause(h)
    end
    
    hold off
    % Update r0
    [x, ~, dx, ~] = kin_hip(q, dq);
    r0 = r0 + [dx*h;0]; 
end
t_anim = toc();

%% Post processing 

if saveVideo
    close(writerObj);
end

real_time_factor = h*num_steps/t_anim;% This is only an estimation 
fprintf('Real time factor:');
disp(real_time_factor);

speed = r0(1) / (num_steps * h);
fprintf('Overall speed: ');
disp(speed);