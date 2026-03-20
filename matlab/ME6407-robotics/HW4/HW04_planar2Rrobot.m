%% HW04: Planar 2R robot torque calculation: parameter setting file
% SimScape: HW04_planar2Rrobot_SimScape.slx

L1=0.2;
L2=0.15;

Lg1=L1*0.5;
Lg2=L2*0.5;

m1=L1*0.02*0.01*1000;
m2=L2*0.02*0.01*1000;

I1=m1*L1^2/12; %simple beam
I2=m2*L2^2/12; %simple beam

g=9.8;

% end-point (xd,yd)
t0=0;
tf=5;

R=0.12; %radius of the circle
xR=0.2;%center of the circle
yR=0.0;
tt=t0:0.001:tf; 

omega=2*pi*1.5;%cycle frequency

phid=omega*tt;

xed=xR+R*cos(phid);
yed=yR+R*sin(phid);

%% loading workspace to run SimScape file
load('HW04_togetstarted')

disp('parameter loaded. run HW04_planar2Rrobot_SimScape.slx ')