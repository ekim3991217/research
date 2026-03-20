%% Simplified PUMA class statics
% run this file before runnig
% "HW03_SOL_simplified_PUMA_statics_simscape.slx"

la=1;
lb=0.2;
lc=1;

%external force and moment at the tip (world frame)
external_force=[0;0;-1];
external_moment=[0;1;0];

%solution 1
theta1=45/360*2*pi;
theta2=-60/360*2*pi;
theta3=120/360*2*pi;

%solution 2 (same end point as 1)
% theta1=45/360*2*pi;
% theta2=60/360*2*pi;
% theta3=-120/360*2*pi;

%solution 3
% theta1=90/360*2*pi;
% theta2=45/360*2*pi;
% theta3=90/360*2*pi;

%solution 4
% theta1=180/360*2*pi;
% theta2=-30/360*2*pi;
% theta3=-60/360*2*pi;

%joint torque setting
tau1=0;
tau2=0;
tau3=0;


