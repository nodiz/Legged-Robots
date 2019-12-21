function [InitialObservation, LoggedSignal] = reset_func()
    
    q0 = [pi/6; -pi/6; 0];
    dq0 = [0;0;0];
    
    LoggedSignal.State = [q0; dq0;0;0];
    %LoggedSignal.State = [qn; dqn;x;dx;ev];
    InitialObservation = LoggedSignal.State;

end