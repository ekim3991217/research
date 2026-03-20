%% dynamics planar RP robot
% Robot dynamics based on Craig book Example 6.5
% run this program before running Simulink
% provide end-point desired positions using ginput

% then run "controls_planarRProbot_simulink.slx" (joint position
% control+computed torque)
% computed torque method example

% OR run "controls_planarRProbot_jacobiancontrol_simulink.slx" (task-space
% jacobian control)
% Jacobian control (inverse and transpose)

% then run "dynamics_planarRProbot_plot.m" to display results

clear;
g=9.81;
I1=10;
I2=5;
m1=2;
m2=1;
l1=0.5;

tf=5; % simulation end time

N=8; %number of points

figure(2)
[xed,yed]=ginput(N);

tt=tf/N:tf/N:tf;

for ii=1:N,
    theta1inv(ii)=atan2(yed(ii),xed(ii));
    d2inv(ii)=sqrt(xed(ii)^2+yed(ii)^2)-l1;
    
end

plot(xed,yed)
axis([-1 1 -1 1])
hold on

%joint data for simulink
theta1d2sim=[tt' theta1inv' d2inv']

%end point data for simulink
xedyedsim=[tt' xed yed]

disp('ready. run simulink model')