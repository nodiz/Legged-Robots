function [NextObs,Reward,IsDone,LoggedSignals] = step_func(Action,LoggedSignals,EnvVars)
% This function applies the given action to the environment and evaluates
% the system dynamics for one simulation step.

global ntot
global nstep
global writerObj

Torques = Action;
tspan = linspace(0,EnvVars.Ts,2);

State = LoggedSignals.State;

% Calculate next state 
opts = odeset('RelTol', 1e-5, 'Events', @step_evnt);
%opts = odeset('RelTol', 1e-5);
[~, Y, YE] = ode45(@(t,y) step_eqns(t,y,Torques),tspan,State,opts); % use ode45 to solve the equations of motion (eqns.m)
newState = Y(end,:)';
if ~isempty(YE)
    [q0,dq0] = impact(Y(end,1:3)', Y(end,4:6)');
    newState = [q0;dq0];
end
q = newState(1:3);
dq = newState(4:6);
q_mod = mod( q, 2*pi );
q_rew = zeros(3,1);
for index = 1:3
    if q_mod(index) < pi
        q_rew(index) = q_mod(index);
    else
        q_rew(index) = q_mod(index) - 2*pi;
    end
end

newState(1:3) = q_rew;

LoggedSignals.State = newState;
NextObs = newState;


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

% Rewarding 

[x_swf,z_swf,dx_swf,y_swf]= kin_swf(q, dq); %% À vérifier;
[x, z, dx, dz] = kin_hip(q, dq);

%Reward = 1 - q_rew(3)  ;
Reward = 10*dx - 1 * (q_rew(3)) - 0.1 * abs(z-0.4320)^2 - 0.01 * sum(Action.^2);
if z > 0
else 
    Reward = Reward - 50;
end
%Reward = z;

% Conclusion

nstep = nstep + 1;

IsDone = 0;

if nstep == EnvVars.maxsteps

    IsDone = 1;
    if mod(ntot, EnvVars.showN) == 0
        close(writerObj);
    end
    ntot = ntot + 1;
    nstep = 0;
end

end


