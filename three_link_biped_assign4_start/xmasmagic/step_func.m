function [NextObs,Reward,IsDone,LoggedSignals] = step_func(Action,LoggedSignals,EnvConstants)
% This function applies the given action to the environment and evaluates
% the system dynamics for one simulation step.

Torques = Action;
tspan = linspace(0,EnvConstants.Ts,3);

% Unpack the state vector from the logged signals
State = LoggedSignals.State;
q = State(1:3);
dq = State(4:6);

% Calculate next state (Thibault?) 
opts = odeset('RelTol', 1e-5, 'Events', @step_evnt);

[T, Y, YE] = ode45(@(t,y) step_eqns(t,y,Torques),tspan,State,opts); % use ode45 to solve the equations of motion (eqns.m)

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
[x, ~, dx, ~] = kin_hip(q, dq);

if x > EnvConstants.Xend 
    reward0 = 100;
    IsDone = 1;
elseif q(1) > pi/2 || q(1) < - pi/2
    reward0 = -50;
    IsDone = 1;
else 
    reward0 = 0;
    IsDone = 0;
end

Reward = sum([reward0; % reward or penality for winning/losing
    25 * dx; % speed of procession
    0.25; % alive prize
    -sum(0.005 .* (Action.^2)); % penality on torques
    -2*abs(q(3))
    % add something to maintain height?
    ]);

end