function [NextObs,Reward,IsDone,LoggedSignals] = step_func(Action,LoggedSignals,EnvVars)
% This function applies the given action to the environment and evaluates
% the system dynamics for one simulation step.

global ntot 
global nstep 
nstep = nstep + 1;

Torques = Action;
tspan = linspace(0,EnvVars.Ts,3);

% Unpack the state vector from the logged signals
State = LoggedSignals.State;
q = State(1:3);
dq = State(4:6);

% Calculate next state (Thibault?) 
opts = odeset('RelTol', 1e-5, 'Events', @step_evnt);

[~, Y, YE] = ode45(@(t,y) step_eqns(t,y,Torques),tspan,State,opts); % use ode45 to solve the equations of motion (eqns.m)
State = Y(end,:)';
if ~isempty(YE)
    [q0,dq0] = impact(Y(end,1:3)', Y(end,4:6)');
    State = [q0;dq0];
end
newState = State;
% Euler integration
LoggedSignals.State = newState;
% Transform state to observation
NextObs = LoggedSignals.State;
% Check terminal condition
q = NextObs(1:3);
dq = NextObs(4:6);

q_mod = mod(q,2*pi);
q_rew = min( q_mod, 2*pi-q_mod);

IsDone = 0;
penfall = 0;
if q_rew(1) > pi*3/4 || q_rew(1) < - pi*3/4
    penfall = -50;
    nstep = 0 ;
    ntot = ntot + 1;
    IsDone = 1;
elseif nstep == EnvVars.maxsteps - 1
    ntot = ntot + 1;
    IsDone = 1;
end

[x_swf,z_swf,dx_swf,dz_swf]= kin_swf(q, dq);
[x, z, dx, dz] = kin_hip(q, dq);

if mod(ntot, 100) == 0
    clf
    visualize(q);
    pause(0.01)
end

%Reward = 1 - q_rew(3)  ;
Reward = dx + dx_swf/10 - 50 * (q_rew(3)) -50 * abs(z-0.4330) - 0.02 * sum(Action.^2) + 50*EnvVars.n/400 + penfall;
end