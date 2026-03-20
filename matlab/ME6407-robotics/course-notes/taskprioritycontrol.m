function [yout]=taskprioritycontrol(q)

xe_error=q(1);
ye_error=q(2);

theta1=q(3);
theta2=q(4);
theta3=q(5);


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

a1=0.2;
a2=0.15;
a3=0.12;
d1=0.1;
d2=0.1;
d3=0.1;

J=[-a1*S1-a2*S12-a3*S123 -a2*S12-a3*S123 -a3*S123;
    a1*C1+a2*C12+a3*C123 a2*C12+a3*C123 a3*C123];

manipulability=sqrt(det(J*transpose(J)));

%numerical evaluation of gradient of J
for l=1:3,
    
    theta1=q(3)+0.05*(l==1);
    theta2=q(4)+0.05*(l==2);
    theta3=q(5)+0.05*(l==3);

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

J=[-a1*S1-a2*S12-a3*S123 -a2*S12-a3*S123 -a3*S123;
    a1*C1+a2*C12+a3*C123 a2*C12+a3*C123 a3*C123];

manipulability_new=sqrt(det(J*transpose(J)));

xi(l)=(manipulability_new-manipulability)/0.05;

end

%yout=[0.01*pinv(J)*[xe_error;ye_error]+100*(eye(3,3)-pinv(J)*J)*xi';manipulability];
yout=[0.01*pinv(J)*[xe_error;ye_error];manipulability];
