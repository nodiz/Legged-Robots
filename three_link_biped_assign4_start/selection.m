%% Loading stuffs

load('analyze1')
folder = '/Users/nodiz/Documents/savedAgents_robop3/';

%% Sorting for distance

[distR, orderDist] = sort(distance, 'descend');
toKeep = orderDist(distR~=0);
length(toKeep);

namesR = listing(toKeep);
speedR = speed(toKeep);
rewardR = reward(toKeep);

% Plot found speed from -0.5 to 2 with 0.1 bin length 
figure
h = histogram(speedR, linspace(-0.5, 2, 26));
title('Obtained speed surviving more than 10000 steps')

%% Finding interesting agents

% Get agent path from agent number
agentPath = @(index) [folder,  namesR(index).name];

collection = [rewardR/1000, speedR];

figure
plot(collection(:,1), collection(:,2))
title('Reward vs Speed')
hold on 

fastest = 1;
[~, rOrder] = sort(rewardR,'descend');
rewarded = rOrder(1);
[~, coolOrder] = sort(rewardR.*speedR, 'descend');
coolest = coolOrder(1);

agentList = [fastest, rewarded, coolest];
plot(collection(agentList,1), collection(agentList,2), 'r+', 'linewidth', 2);
for i = 1: length(agentList)
    text(collection(agentList(i),1), collection(agentList(i),2), namesR(agentList(i)).name)
end

%% Loading agents and saving them for analysis


for i = 1: length(agentList)
    load(agentPath(agentList(i)))
    interestingAgents(i).agent = saved_agent;
    interestingAgents(i).name = namesR(agentList(i)).name;
end

save('agentToAnalyse', 'interestingAgents')
