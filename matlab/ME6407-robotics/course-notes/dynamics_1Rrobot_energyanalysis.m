%% Dynamics 1DOF link mechanism with gravity
% DEOM, Joint torque,Energy analysis
clear

g=9.8;
L=0.2;
m=L*0.02*0.01*1000;
Lg=L/2;
I=m*L^2/12; %simple beam about CoM

Ieq=I+m*Lg^2; %parallel axis theorem

%% prescribed theta profile

% %cyclic trajectory
tf=5;
tt=0:0.001:tf;
fh=1; %in Hz
omega=2*pi*fh;
A=pi/2;
theta_data=-A*cos(omega*tt);
dtheta_data=omega*A*sin(omega*tt);
ddtheta_data=omega^2*A*cos(omega*tt);
% %cyclic trajectory end


% cubic poly trajectory
% t0=0;
% tf=1;
% tt=0:0.001:tf;
% theta0=-pi/2;
% thetaf=pi/2;  %in degrees
% a0=theta0;
% a1=0;
% a2=3/(tf^2)*(thetaf-theta0);
% a3=-2/(tf^3)*(thetaf-theta0);
% theta_data=a0+a1*tt+a2*tt.^2+a3*tt.^3;
% dtheta_data=a1+2*a2*tt+3*a3*tt.^2;
% ddtheta_data=2*a2+6*a3*tt;

% for ii=1:length(tt),
%    if tt(ii)>tf,
%        theta_data(ii)=thetaf;
%        dtheta_data(ii)=0;
%        ddtheta_data(ii)=0;
%    end
% end
% cubilc poly trajectory end 

%for SimScape demonstration
%run "dynamics_1Rrobot_SimScape" and compare tau
theta1dsim=[tt',theta_data'];


for ii=1:length(tt),

theta=theta_data(ii);
dtheta=dtheta_data(ii);
ddtheta=ddtheta_data(ii);

%dynamics

KE=1/2*Ieq*dtheta^2;
PE=m*g*Lg*sin(theta);

%torque from inertial term
tau_I=Ieq*ddtheta;
%torque from gvarivy term
tau_g=m*g*Lg*cos(theta);

tau=tau_I+tau_g;

tau_data(:,ii)=[tau_I;tau_g;tau];

TE_data(:,ii)=[KE;PE]; %TE totan energy breakdown

end
% for SimScape demonstration: torque input
taudsim=[tt',tau_data(3,:)'];

%plot theta
figure(1)
plot(tt,theta_data)

%plot breakdown of tau
%tau_I and tau_g
figure(2)
plot(tt,tau_data(1,:),tt,tau_data(2,:))

%plot energy breakdown
% plot KE and PE
figure (3)
plot(tt,TE_data(1,:),tt,+TE_data(2,:))

