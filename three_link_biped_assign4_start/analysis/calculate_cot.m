function [cot, mean_cot] = calculate_cot(sln, h, start_step)
%COT calculate COT for everystep step

if nargin < 2
    h = 0.001;
    start_step = 5;
elseif nargin < 3
    start_step = 5;
end

num_steps = size(sln.T,2);
COT_vect = zeros(1,num_steps);

for i = 1:num_steps
    max_1 = zeros(1, length(sln.T{i}));
    max_2 = zeros(1, length(sln.T{i}));
    for t = 1:length(sln.T{i})   
        max_1(t) = max([0, sln.U{i}(t,1) * (sln.Y{i}(t,4) - sln.Y{i}(t,6))]);
        max_2(t) = max([0, sln.U{i}(t,2) * (sln.Y{i}(t,5) - sln.Y{i}(t,6))]);
    end
    COT_vect(i) = (trapz(sln.T{i}', max_1) + trapz(sln.T{i}', max_2))/...
                    fast_kinHip(sln.Y{i}(:,1),sln.Y{i}(:,4),h);
end

cot = COT_vect;
mean_cot = mean(COT_vect(start_step:end));

end

