%% Planar 3R robotinverse kinematics HW03

a1=0.2;
a2=0.15;
a3=0.12;
d1=0.1;
d2=0.1;
d3=0.1;

%% Jacobian

theta1=0;
theta2=0;
theta3=0;

S1=sin(theta1);
S12=sin(theta1+theta2);
S2=sin(theta2);
S123=sin(theta1+theta2+theta3);
S23=sin(theta2+theta3);
S3=sin(theta3);
C1=cos(theta1);
C2=cos(theta2);
C3=cos(theta3);
C12=cos(theta1+theta2);
C23=cos(theta2+theta3);
C3=cos(theta3);
C123=cos(theta1+theta2+theta3);

% from Jacobian handout

J=[-a1*S1-a2*S12-a3*S123 -a2*S12-a3*S123 -a3*S123;
    a1*C1+a2*C12+a3*C123 a2*C12+a3*C123 a3*C123];

tf=5; % simulation end time

N=8; %number of points

figure(2)
axis([-0.2 0.2 -0.2 0.2])
grid
hold on
[xed,yed]=ginput(N);
tt=tf/N:tf/N:tf;
%end point data for simscape
xedyedsim=[tt' xed yed]
plot(xed,yed)
%axis([-1 1 -1 1])
