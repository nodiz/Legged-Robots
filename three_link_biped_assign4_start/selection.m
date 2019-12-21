%% Loading stuffs

load('analyze1')
folder = '/Users/nodiz/Documents/savedAgents_robop3';

%% Sorting for distance

[distR, orderDist] = sort(distance, 'descend');
toKeep = orderDist(distR~=0);
length(toKeep)

namesR = listing(toKeep);
speedR = speed(toKeep);
rewardR = reward(toKeep);

% Plot found speed from -0.5 to 2 with 0.1 bin length 
h = histogram(speedR, linspace(-0.5, 2, 26));

%% Finding one speed for every bin maximizing the reward


%%

agentPath = @(index) [folder, '/', namesR(index).name];
load(agentPath());

