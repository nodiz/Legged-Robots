function [NextObs,Reward,IsDone,LoggedSignals] = step_func(Action,LoggedSignals,EnvVars)
% This function applies the given action to the environment and evaluates
% the system dynamics for one simulation step.

global ntot
global nstep
global writerObj

verboseOut = 0;
train = 1;
tspan = linspace(0,EnvVars.Ts,2);

% Calculate next state 

opts = odeset('RelTol', 1e-5, 'Events', @step_evnt);
%opts = odeset('RelTol', 1e-5);
[~, Y, YE] = ode45(@(t,y) step_eqns(t,y,Action),tspan,LoggedSignals.State(1:6),opts); % use ode45 to solve the equations of motion (eqns.m)

newState = Y(end,:)';

if ~isempty(YE)
    [q,dq] = impact(Y(end,1:3)', Y(end,4:6)');
    newState = [q;dq];
end

q = newState(1:3);
dq = newState(4:6);

q_rew = normAngle(q);

newState(1:3) = q_rew;

LoggedSignals.State = [newState;0;0];
NextObs = [newState;0;0];

% Reward 

[x_swf,z_swf,dx_swf,y_swf]= kin_swf(q, dq); %% ? v?rifier;
[x, z, dx, dz] = kin_hip(q, dq);

speedReward = 5*min(dx,10);
torsoPenality = 5*(normAngle(q_rew(3) - 0.09))^2;
zPenality =  20*abs(min(z-0.5,0))^2;
actionPenality = 0.002 * sum(Action.^2);

Reward = speedReward - torsoPenality - zPenality - actionPenality + 0.5;

IsDone = 0;
if z < 0 
    Reward = Reward-500;
    IsDone = 1;
end
    
if verboseOut
    disp([ ...
        num2str(nstep), ' step| ', ...
        num2str(speedReward), ' s| ', ...
        num2str(torsoPenality), ' t| ', ...
        num2str(zPenality), ' z| ', ...
        num2str(actionPenality), ' a| ', ...
        num2str(Reward) 'r|'
        ]);
end

% Video Writing

if mod(ntot, EnvVars.showN) == 0
    if nstep == 0
        videoName = ['videos/', EnvVars.name, floor(num2str(ntot/EnvVars.showN)),'.avi'];
        writerObj = VideoWriter(videoName);
        writerObj.FrameRate = 20;
        open(writerObj);
        figure(1)
    end
    clf
    visualize(q);
    F = getframe(gcf) ;
    writeVideo(writerObj, F);
end

% Conclusion
nstep = nstep + 1;

if (or(EnvVars.maxsteps == nstep, IsDone == 1) && train )
    IsDone = 1;
    if mod(ntot, EnvVars.showN) == 0
        close(writerObj);
    end
    ntot = ntot + 1;
    nstep = 0;
end

end


