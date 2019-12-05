function [InitialObservation, LoggedSignal] = reset_func()
    
    q0 = [pi/6; -pi/6; 0];
    dq0 = [0;0;0];
    
    %x = 0;
    %dx = 0;
    %ev = 0;
    
    noiseq = [0;0;0];
    noisedq = [0;0;0];
    
    qn = q0 + noiseq;
    dqn = dq0 + noisedq; 
    
    LoggedSignal.State = [qn; dqn];
    %LoggedSignal.State = [qn; dqn;x;dx;ev];
    InitialObservation = LoggedSignal.State;

end