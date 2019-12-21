
simOpts = rlSimulationOptions('MaxSteps',1000);

path = '/Users/nodiz/Documents/savedAgents_robop3/';
listing = dir(path);
h = 0.01;
reward = zeros (length(listing)) ;
distance = zeros (length(listing)) ;
speed = zeros (length(listing)) ;

for x = 4:10:length(listing)
    file = listing(x).name;
    load([path, file]);
    experience = sim(env,saved_agent,simOpts);
    d = experience.Observation.lbro.Data;
    disp([num2str(x),'/', num2str(length(listing)), ' | ', listing(x).name, ' | ', num2str(length(d))])
    if length(d) < 1000
        continue
    else 
        reward(x) = sum(experience.Reward.Data);
        [distance(x), speed(x)] = fast_kinHip(d(1,:),d(4,:), 50, 1000, h);
        disp(['r=', num2str(reward(x)), ' | ', 'd=', num2str(distance(x)), ' | ', 'd=', num2str(speed(x))])
    end
end