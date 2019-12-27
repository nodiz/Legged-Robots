function action1 = evaluateCurrentPolicy(observation1)
%#codegen

% Reinforcement Learning Toolbox
% Generated on: 21-Dec-2019 17:34:29

action1 = localEvaluate(observation1);
end
%% Local Functions
function action1 = localEvaluate(observation1)
persistent policy
if isempty(policy)
	policy = coder.loadDeepLearningNetwork('coolAgent.mat','policy');
end
action1 = predict(policy,observation1);
end