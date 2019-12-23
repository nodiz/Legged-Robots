%--------------------------------------------------------------------------
%   opti_part : Stock and plot the comparison between all the results of
%               the PD and VMC controller. Add more plot if you want
%--------------------------------------------------------------------------

% Load and init
load('analyzePD-VMC.mat')

CoT_PD = zeros(1,9);
CoT_VMC = zeros(1,9);

speed_PD = zeros(1,9);
speed_VMC = zeros(1,9);

length_PD = zeros(1,9);
length_VMC = zeros(1,9);

freq_PD = zeros(1,9);
freq_VMC = zeros(1,9);

% Store data in vectors
for i = 1:9
    CoT_PD(i) = analyzeArray{1,i}.cot;
    CoT_VMC(i) = analyzeArray{1,9+i}.cot;
    speed_PD(i) = analyzeArray{1,i}.speed;
    speed_VMC(i) = analyzeArray{1,9+i}.speed;
    length_PD(i) = analyzeArray{1,i}.length;
    length_VMC(i) = analyzeArray{1,9+i}.length;
    freq_PD(i) = analyzeArray{1,i}.freq;
    freq_VMC(i) = analyzeArray{1,9+i}.freq;
end

% Print CoT vs Speed
figure
hold on
scatter(speed_PD,CoT_PD, 'blue', 'x')
plot(speed_PD,CoT_PD, 'blue')
scatter(speed_VMC,CoT_VMC, 'red')
plot(speed_VMC,CoT_VMC, 'red')
legend('PD points','PD','VMC points','VMC');
xlabel('Speed [m/s]');
ylabel('CoT [-]');
title('CoT vs Speed');

% Print CoT vs Length
figure
hold on
scatter(length_PD,CoT_PD, 'blue', 'x')
scatter(length_VMC,CoT_VMC, 'red')
legend('PD points','VMC points');
xlabel('Length [m]');
ylabel('CoT [-]');
title('CoT vs length');

% Print CoT vs Frequency
figure
hold on
scatter(freq_PD,CoT_PD, 'blue', 'x')
plot(freq_PD,CoT_PD, 'blue')
scatter(freq_VMC,CoT_VMC, 'red')
plot(freq_VMC,CoT_VMC, 'red')
legend('PD points','PD','VMC points','VMC');
xlabel('Freq [1/s]');
ylabel('CoT [-]');
title('CoT vs Frequency');