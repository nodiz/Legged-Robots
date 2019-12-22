function action1 = evaluatePolicy(observation1)
%#codegen

% Reinforcement Learning Toolbox
% Generated on: 21-Dec-2019 18:18:43

action1 = localEvaluate(observation1);
end7/8/
%% Local Functions
function action1 = localEvaluate(observation1)
persistent policy
if isempty(policy)
	policy = coder.loadDeepLearningNetwork('rewardAgent.mat','policy');
end
action1 = predict(policy,observation1);
end