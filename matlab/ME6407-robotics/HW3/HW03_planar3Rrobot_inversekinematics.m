%% Planar 3R robotinverse kinematics HW03

a1=0.2;
a2=0.15;
a3=0.12;
d1=0.1;
d2=0.1;
d3=0.1;

%% inverse kinematics

%desired end point location and orientation
xed=0.2;
yed=0.2;
thetaed=120/360*2*pi;

%determine O3 location for inverse kinematics
x3posd=xed-a3*cos(thetaed);
y3posd=yed-a3*sin(thetaed);

p13=sqrt(x3posd^2+y3posd^2);

C2inv=(p13^2-a1^2-a2^2)/2/a1/a2;

C2=C2inv;

theta2invp=atan2(sqrt(1-((p13^2-a1^2-a2^2)/(2*a1*a2))^2),(p13^2-a1^2-a2^2)/(2*a1*a2));
theta2invm=-atan2(sqrt(1-((p13^2-a1^2-a2^2)/(2*a1*a2))^2),(p13^2-a1^2-a2^2)/(2*a1*a2));

theta2inv=theta2invp;% choose one
S2=sin(theta2inv);

tmp=inv([a1+a2*C2 -a2*S2;a2*S2 a1+a2*C2])*[x3posd;y3posd];

theta1inv=atan2(tmp(2),tmp(1))

theta3inv=thetaed-theta1inv-theta2inv

%% plot inverse kinematics solution
theta1=theta1inv
theta2=theta2inv
theta3=theta3inv

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
C123=cos(theta1+theta2+theta3);

%from manipulator geometries
x4pos=a1*C1+a2*C12+a3*C123
y4pos=a1*S1+a2*S12+a3*S123

x3pos=a1*C1+a2*C12;
y3pos=a1*S1+a2*S12;

figure(2)
hold on
plot([0 a1*C1 a1*C1+a2*C12 a1*C1+a2*C12+a3*C123 x4pos],[0 a1*S1 a1*S1+S12*a2 a1*S1+S12*a2+a3*S123 y4pos])
plot(x4pos,y4pos,'o');
axis equal
grid

%Homogeneous transformation
T01=[C1 -S1 0 0;S1 C1 0 0;0 0 1 d1; 0 0 0 1];
T12=[C2 -S2 0 a1;S2 C2 0 0;0 0 1 d2; 0 0 0 1];
T23=[C3 -S3 0 a2;S3 C3 0 0;0 0 1 d3; 0 0 0 1];
T34=[1 0 0 a3;0 1 0 0;0 0 1 0; 0 0 0 1];

T04=T01*T12*T23*T34