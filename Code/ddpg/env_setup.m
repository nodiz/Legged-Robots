%% Creating custom environment for the 2D walking robot

close all
rng(0)

numObs = 8; % NN dimensioned for two more values to account into state 
numAct = 2; 

EnvVars.Tf = 4; % duration of episode
EnvVars.Ts = 0.01; % duration of step

maxepisodes = 10000; % Max number of episode in the simulation
maxsteps = ceil(EnvVars.Tf/EnvVars.Ts); % Time of episode / Period of step 
EnvVars.maxsteps = maxsteps; % Max steps for and episode
EnvVars.name = 'home4_'; % Folder for the saved video (need to be precreated)
EnvVars.showN = 100; % Showing and saving episode evey showN episodes simulations

ObservationInfo = rlNumericSpec([numObs 1]);
ObservationInfo.Name = 'State';
ObservationInfo.Description = 'theta1, theta2, theta3, td1, td2, td3, e0, e1';

ActionInfo = rlNumericSpec([numAct 1], 'LowerLimit', [-30; -30], 'UpperLimit', [30; 30]);
ActionInfo.Name = 'Torques';
ActionInfo.Description = 'T1, T2';

global ntot
global nstep
ntot = 0 ;
nstep = 0 ;

StepHandle = @(Action,LoggedSignals) step_func(Action,LoggedSignals,EnvVars);
ResetHandle = @reset_func;

% Finally setting up the environment
env = rlFunctionEnv(ObservationInfo,ActionInfo,StepHandle,ResetHandle);


%%  Critic network

statePath = [
    imageInputLayer([numObs 1 1],'Normalization','none','Name','observation')
    fullyConnectedLayer(200,'Name','CriticStateFC1')
    reluLayer('Name', 'CriticRelu1')
    fullyConnectedLayer(100,'Name','CriticStateFC2')];
actionPath = [
    imageInputLayer([numAct 1 1],'Normalization','none','Name','action')
    fullyConnectedLayer(100,'Name','CriticActionFC1','BiasLearnRateFactor',0)];
commonPath = [
    additionLayer(2,'Name','add')
    reluLayer('Name','CriticCommonRelu')
    fullyConnectedLayer(1,'Name','CriticOutput')];

criticNetwork = layerGraph();
criticNetwork = addLayers(criticNetwork,statePath);
criticNetwork = addLayers(criticNetwork,actionPath);
criticNetwork = addLayers(criticNetwork,commonPath);
    
criticNetwork = connectLayers(criticNetwork,'CriticStateFC2','add/in1');
criticNetwork = connectLayers(criticNetwork,'CriticActionFC1','add/in2');

%figure
%plot(criticNetwork)

criticOpts = rlRepresentationOptions('LearnRate',1e-03,'GradientThreshold',1);

critic = rlRepresentation(criticNetwork,ObservationInfo,ActionInfo,'Observation',{'observation'},'Action',{'action'},criticOpts);
%% Actor network


actorNetwork = [
    imageInputLayer([numObs 1 1],'Normalization','none','Name','Observation')
    fullyConnectedLayer(300,'Name','ActorFC1')
    reluLayer('Name','ActorRelu1')
    fullyConnectedLayer(200,'Name','ActorFC2')
    reluLayer('Name','ActorRelu2')
    fullyConnectedLayer(numAct,'Name','ActorFC3')
    tanhLayer('Name','ActorTanh')
    scalingLayer('Name','ActorScaling','Scale',max(ActionInfo.UpperLimit))];

actorOpts = rlRepresentationOptions('LearnRate',1e-04,'GradientThreshold',1);

actor = rlRepresentation(actorNetwork,ObservationInfo,ActionInfo,'Observation',{'Observation'},'Action',{'ActorScaling'},actorOpts);

agentOpts = rlDDPGAgentOptions(...
    'SampleTime',EnvVars.Ts,...
    'TargetSmoothFactor',1e-3,...
    'ExperienceBufferLength',1e6,...
    'DiscountFactor',0.99,...
    'MiniBatchSize',128, ...
    'SaveExperienceBufferWithAgent', 1 ...  % save agent with simuldata?
    );  % increase if not getting anywhere

agentOpts.NoiseOptions.Mean = pi/60; % 6 degres
agentOpts.NoiseOptions.VarianceDecayRate = 1e-5; % increase variance with time
%agentOptions.NoiseOptions.MeanAttractionConstant = 1;
agentOptions.NoiseOptions.Variance = 0.1;

% At each sample time step, the noise model is updated using the following formula, where Ts is the agent sample time.
%x(k) = x(k-1) + MeanAttractionConstant.*(Mean - x(k-1)).*Ts
%       + Variance.*randn(size(Mean)).*sqrt(Ts)

%figure
%plot(actorNetwork)
%agent = rlDDPGAgent(actor,critic,agentOpts);


%% Train the agent

trainOpts = rlTrainingOptions(...
    'MaxEpisodes',maxepisodes,...
    'MaxStepsPerEpisode',maxsteps,...
    'ScoreAveragingWindowLength',5,...
    'Verbose',true,...
    'Plots','training-progress',...
    'StopTrainingCriteria','AverageReward',...
    'StopTrainingValue', 10000,...
    'SaveAgentCriteria','EpisodeReward',...
    'SaveAgentValue', 200);

%trainOpts.ParallelizationOptions.Mode = "async";
%trainOpts.ParallelizationOptions.StepsUntilDataIsSent = 100;
%trainOpts.ParallelizationOptions.DataToSendFromWorkers = "Experiences";


%% Finally train model

doTraining = true;
if doTraining
    % Train the agent.
    trainingStats = train(agent,env,trainOpts);
else
    dips('ciao');
end

generatePolicyFunction(agent)
