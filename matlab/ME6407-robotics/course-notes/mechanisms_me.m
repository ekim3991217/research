%% Planar 2R robot manipulability

a1=0.2;
a2=0.2;

%% inverse kinematics

%desired end point location
xed=0.2;
yed=0.2;

%xed=0.0;
%yed=0.02;


%determine O3 location for inverse kinematics

p13=sqrt(xed^2+yed^2);

C2inv=(p13^2-a1^2-a2^2)/2/a1/a2;

C2=C2inv;

theta2invp=atan2(sqrt(1-((p13^2-a1^2-a2^2)/(2*a1*a2))^2),(p13^2-a1^2-a2^2)/(2*a1*a2));
theta2invm=-atan2(sqrt(1-((p13^2-a1^2-a2^2)/(2*a1*a2))^2),(p13^2-a1^2-a2^2)/(2*a1*a2));

theta2inv=theta2invp;% choose one
S2=sin(theta2inv);

tmp=inv([a1+a2*C2 -a2*S2;a2*S2 a1+a2*C2])*[xed;yed];

theta1inv=atan2(tmp(2),tmp(1))


%% plot inverse kinematics solution
theta1=theta1inv
theta2=theta2inv

S1=sin(theta1);
S12=sin(theta1+theta2);
S2=sin(theta2);
C1=cos(theta1);
C2=cos(theta2);
C12=cos(theta1+theta2);


%from manipulator geometries
xe=a1*C1+a2*C12;
ye=a1*S1+a2*S12;

figure(2)
hold on
plot([0 a1*C1 a1*C1+a2*C12],[0 a1*S1 a1*S1+S12*a2])
plot(xe,ye,'o');
axis equal
grid

%Jacobian
J=[-a1*S1-a2*S12 -a2*S12;a1*C1+a2*C12 a2*C12]


%%


m1=20;
m2=7;

L1=0.2;
L2=0.3;

Lg1=L1*0.1;
Lg2=L2*0.5; 

I1=m1*L1^2/12; %simple beam
I2=m2*L2^2/12; 

%Inertia matrix
M11=m1*Lg1^2+m2*(L1^2+Lg2^2+2*L1*Lg2*C2)+I1+I2;
M12=m2*(Lg2^2+L1*Lg2*C2)+I2;
M21=M12;
M22=m2*Lg2^2+I2;


M=[M11 M12;M21 M22];

%manipulability ellipsoid
[U,S,V] = svd(J);

u1=S(1,1)*U(:,1);
u2=S(2,2)*U(:,2);

scale=0.2;
tt=0:pi/10:2*pi;
me_v=u1*cos(tt)+u2*sin(tt);
plot(scale*me_v(1,:)+xe,scale*me_v(2,:)+ye,'k-');

%manipulating-force ellipsoid
% [U,S,V] = svd(J);
% 
% u1=1/S(1,1)*U(:,1);
% u2=1/S(2,2)*U(:,2);
% 
% scale=0.003;
% tt=0:pi/10:2*pi;
% fme_v=u1*cos(tt)+u2*sin(tt);
% plot(scale*fme_v(1,:)+xe,scale*fme_v(2,:)+ye,'r-');

%dynamic manipulability ellipsoid
% [U,S,V] = svd(J*M^-1);
% 
% u1=S(1,1)*U(:,1);
% u2=S(2,2)*U(:,2);
% 
% scale=0.05;
% tt=0:pi/10:2*pi;
% dme_v=u1*cos(tt)+u2*sin(tt);
% plot(scale*dme_v(1,:)+xe,scale*dme_v(2,:)+ye,'g-');



