%% Målinger DSE opgave
%  Kim Petersen, Henrik Truelsen, Viggo Lysdahl, Mark Chylinski 04/04-2018

%% Generelt setup:
clear; close all; clc; format compact

%% Indlæsning af data til impulsrespons

l1=csvread('0-2.5.csv');
l2=csvread('0-3.csv');
l3=csvread('0-3,5.csv');
l4=csvread('0-4.csv');

%% Variabler til impulsrespons
%længden af signal samples
length = 6000;

% variabler for første signal
x1 = l1(:,2);
x1 = x1(251:length+250);

t1 = l1(:,1);
t1 = t1(1:length);

% udregning af fs udfra første signal
Ts1 = t1(2)-t1(1);
fs = 1/Ts1; %400 hertz

% Variabler for andet signal
x2 = l2(:,2);
x2 = x2(1:length);
t2 = l2(:,1);
t2 = t2(1:length);

% Variabler for tredie signal
x3 = l3(:,2);
x3 = x3(1:length);
t3 = l3(:,1);
t3 = t3(1:length);

% Variabler for fjerde signal
x4 = l4(:,2);
x4 = x4(1:length);
t4 = l4(:,1);
t4 = t4(1:length);

%% Variabler til frekvensrespons
f = [0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 2 3 4 5 6 7 8 9 10];
m = [-8.46166 -18.673 -25.934 -30.03 -31.53 -32.76 -35.91 -38.061 -38.78 -41.41 -41.41 -41.41 -41.41 -41.41 -41.41 -41.41 -41.41 -41.41];
theta = [237.6 364.8 25.92 19.8 23.85 27.88 25.92 25.94 25.2 36 43.24 28.8 36 43.37 51.42 57.6 65.45 72];

%% plots 
figure

%plot step respons
subplot(3,2,1:2)
plot(t1, x1), grid, hold on
plot(t2, x2), grid, hold on
plot(t3, x3), grid, hold on
plot(t4, x4), grid
xlabel('tid'), ylabel('volt'), title('Step respons data')
legend('2.5V', '3V', '3.5V', '4V')

%plot magnitude response
subplot(3,2,3:4);plot(f,m);
title('magnitude respons');
xlabel('frekvens i Hz');
ylabel('Magnitude i dB');

%plot fase respons
subplot(3,2,5:6);plot(f,theta);
title('fase respons');
xlabel('Frekvens i Hz');
ylabel('fase i grader');