%% Målinger DSE opgave
%  Kim Petersen, Henrik Truelsen, Viggo Lysdahl, Mark Chylinski 04/04-2018

%% Generelt setup:
clear; close all; clc; format compact

%% Indlæsning af data til step respons
sig1=csvread('step_12V.csv');
sig2=csvread('step_09V.csv');
sig3=csvread('step_06V.csv');
sig4=csvread('step_03V.csv');

%signal 1
time1=sig1(:, 1);
input1=sig1(:, 2);
output1= sig1(:, 3);

%signal 2
time2=sig2(:, 1);
input2=sig2(:, 2);
output2= sig2(:, 3);

%signal 3
time3=sig3(:, 1);
input3=sig3(:, 2);
output3= sig3(:, 3);

%signal 4
time4=sig4(:, 1);
input4=sig4(:, 2);
output4= sig4(:, 3);


%% Variabler til step respons
% øvre samt nedre grænse
lower = 0.5466;
upper = 1.4055;

% skabelsen af nedre/øvre linjer
lower_line = lower*ones(1,8192);
upper_line = upper*ones(1,8192);

% variabel y limit til plot
ylim_plot = upper + 0.2;

% udregning af fs udfra første signal
Ts1 = sig1(2)-sig1(1);
fs = 1/Ts1; %400 hertz

%% Variabler til frekvensrespons
f = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 2];
m = [-5.08066866 -4.860760974 -4.03290727 -12.29298237 -12.81956115 -16.901960 -20 -22.92256072 -27.3595357 -24.86076098 -27.3595357];
theta = [-46.8 -90 -131.773 -172.8 -180 -187.995 -196.6386 -201.6 -134.1818 -75.6 -36];

%% plots 
figure

%plot af 1.2V step respons
subplot(4,2,1:2)
plot(time1, input1, ':'), grid, hold on
plot(time1, output1), grid;
xlabel('tid i s'), ylabel('volt'), title('1.2V Step respons');
xlim([-0.5 8]), ylim([0 3.5]);
lgd = legend('input step 1.2V', 'output potentiometer');
title(lgd,'akser');

%plot af 0.9V step respons
subplot(4,2,3:4)
plot(time2, input2, ':'), grid, hold on
plot(time2, output2), grid;
xlabel('tid i s'), ylabel('volt'), title('0.9V Step respons');
xlim([-0.5 8]), ylim([0 3.5]);
lgd = legend('input step 0.9V', 'output potentiometer');
title(lgd,'akser');

%plot af 0.6V step respons
subplot(4,2,5:6)
plot(time3, input3, ':'), grid, hold on
plot(time3, output3), grid;
xlabel('tid i s'), ylabel('volt'), title('0.6V Step respons');
xlim([-0.5 8]), ylim([0 3.5]);
lgd = legend('input step 0.6V', 'output potentiometer');
title(lgd,'akser');

%plot af 0.3V step respons
subplot(4,2,7:8)
plot(time4, input4, ':'), grid, hold on
plot(time4, output4), grid;
xlabel('tid i s'), ylabel('volt'), title('0.3V Step respons');
xlim([-0.5 8]), ylim([0 3.5]);
lgd = legend('input step 0.3V', 'output potentiometer');
title(lgd,'akser');

figure

%plot af step respons med øvre/under grænse
subplot(1,2,1:2)
plot(time1, output1, ':k'), grid, hold on
plot(time2, output2, ':k'), grid, hold on
plot(time3, output3, ':k'), grid, hold on
plot(time4, output4, ':k'), grid, hold on
plot(time1, lower_line, 'r'), grid, hold on
plot(time1, upper_line, 'r'), grid;
xlabel('tid i s'), ylabel('volt'), title('Step respons med inputs');
ylim([0.4 ylim_plot]), xlim([-0.5 8]);
lgd = legend('potentiometer 1.2V', 'potentiometer 0.9V', 'potentiometer 0.6V', 'potentiometer 0.3V', 'nedre region', 'øvre region');
title(lgd,'akser');

figure

%plot magnitude response
subplot(2,2,1:2);plot(f,m);
title('magnitude respons');
xlabel('frekvens i Hz');
ylabel('Magnitude i dB');

%plot fase respons
subplot(2,2,3:4);plot(f,theta);
title('fase respons');
xlabel('Frekvens i Hz');
ylabel('fase i grader');

%% udregnede overføringsfunktion
sys_id_output = output2 - 0.578;
sys_id_input = input2 - 1.56;

T = 5.86 - 2.6;     % værdier aflæst på graf for output
fd = 1/T;
wd = 2*pi*fd;

MP = (0.643-0.408)/0.408;   % Overshoot

zeta = -log(MP)/sqrt(pi^2+(log(MP)^2)); % Dampening ratio

wn = wd/sqrt(1-(zeta^2));

b = wd^2;           
a = 2*zeta*wn

% overføringsfunktion
num = [0.41 * b];
den = [1 a b];

G = tf(num, den)

figure
step(G); grid minor; hold on
plot(time2, sys_id_output, 'g'); grid minor; hold on;
plot(time2, sys_id_input, 'r');
title('udregnet overføringsfunktion');
xlim([0 12]);
lgd = legend('overføringsfunktion', '0.9V output', 'input');
title(lgd,'akser');

%% system identification tool fundet overføringsfunktion

num = [(-0.02934) (-0.145) 0.8204];
den = [1 0.7996 1.757];

G = tf(num, den)

zeros = zero(G);
poles = pole(G);

figure
subplot(1,3,1:2);
step(G); grid minor; hold on
plot(time2, sys_id_output, 'g'); grid minor; hold on;
plot(time2, sys_id_input, 'r');
title('system identification overføringsfunktion');
xlim([0 12]);
lgd = legend('overføringsfunktion', '0.9V output', 'input');
title(lgd,'akser');
subplot(1,3,3);
zplane(zeros, poles);
