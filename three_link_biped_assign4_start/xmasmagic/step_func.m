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
if mod(ntot, 100) == 0
    if nstep == 0
        videoName = ['videos/', num2str(ntot/100), '_', num2str(nstep), '.avi'];
        writerObj = VideoWriter(videoName);
        writerObj.FrameRate = 1;
        open(writerObj);
        if ntot == 0
            figure
        end
    end
    clf
    visualize(q);
    F = getframe(gcf) ;
    writeVideo(writerObj, F);
end

% Rewarding 

[x_swf,z_swf,dx_swf,y_swf]= kin_swf(q, dq); %% � v�rifier;
[x, z, dx, dz] = kin_hip(q, dq);

%Reward = 1 - q_rew(3)  ;
%Reward = dx - 50 * (q_rew(3)) -50 * abs(z-0.4320) - 0.02 * sum(Action.^2) + 0.02*dq(3) + 50*nstep/20;
Reward = z;

% Conclusion

nstep = nstep + 1;

IsDone = 0;

if nstep == EnvVars.maxsteps
    ntot = ntot + 1;
    IsDone = 1;
    if mod(ntot, 100) == 0
        close(writerObj);
    end
end

end


