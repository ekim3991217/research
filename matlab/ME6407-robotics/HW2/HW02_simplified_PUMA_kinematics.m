%% Simplified PUMA class forward and inverse kinematics template
% Sample (incomplete code) for HW 02
% Simspace model "HW02_simplified_PUMA_kinematics_simscape" use T matrices
% to display the manipulator

la=1;
lb=0.2;
lc=1;


%% joint angles
theta1=0/360*2*pi;
theta2=-90/360*2*pi;
theta3=90/360*2*pi;

%% Sample hard-coded homogeneous transformation for theta1,2,3=0,-90,90
% Hint: appropriately redefinethese matrices as functions of joint angles 
T01=[    1     0     0     0;
     0     1     0     0;
     0     0     1     0;
     0     0     0     1;
     ];
T12=[    0.0000    1.0000 0  0;
         0         0    1.0000         0;
    1.0000   -0.0000         0         0;
         0         0         0    1.0000;
         ];
T23=[     0.0000   -1.0000         0    1.0000;
    1.0000    0.0000         0         0;
         0         0    1.0000         0;
         0         0         0    1.0000;
         ];
 
%T02=T01*T12
T02=[
    0.0000    1.0000         0         0
         0         0    1.0000         0
    1.0000   -0.0000         0         0
         0         0         0    1.0000
     ];
 
%T03=T01*T12*T23
T03= [    1     0     0     0
     0     0     1     0
     0    -1     0     1
     0     0     0     1
];


%% end-point location

%Endpoint wrt Frame 3
r3=[lc;0;lb;1];
r0=T03*r3

%Full transformation from 0 to 4 (same result)
T34=[1 0 0 lc;
    0 1 0 0;
    0 0 1 lb; 
    0 0 0 1];
T04=T01*T12*T23*T34


%% extract joint locations and draw manipulator

%Oo-O3-Om-O4
%Om is between O3 and O4
rm=T03*[0;0;lb;1];


figure(1)
hold on
plot3([0.1 -0.1 -0.1 0.1 0.1],[0.1 0.1 -0.1 -0.1 0.1],[0 0 0 0 0])  %base square
plot3([0 T03(1,4) rm(1) r0(1)],[0 T03(2,4) rm(2) r0(2)],[0 T03(3,4) rm(3) r0(3)])
plot3(r0(1),r0(2),r0(3),'o');
axis equal
%axis([-1 1 -1 1 -0.5 1.5])

grid
hold off
view(-30,30)

%% inverse kinematics solutions
