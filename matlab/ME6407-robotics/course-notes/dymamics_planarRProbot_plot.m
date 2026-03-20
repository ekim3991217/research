%% animation of planar RP robot
datalength=length(planarRProbotmotoindata.data);

h = waitbar(0,'Simulation running...');

for i=1:5:datalength
theta1=planarRProbotmotoindata.data(i,2);
d2=planarRProbotmotoindata.data(i,3);

figure(1)
clf;
axis([-1 1 -1 1])
hold on

%second link
plot([(l1/2+d2)*cos(theta1) (l1+d2)*cos(theta1)],[(l1/2+d2)*sin(theta1) (l1+d2)*sin(theta1)])
%first link
plot([0 l1*cos(theta1)],[0 l1*sin(theta1)])

plot((l1+d2)*cos(theta1), (l1+d2)*sin(theta1),'o')
xlabel(['Time=' num2str(planarRProbotmotoindata.data(i,1)) 'sec'])
grid
  waitbar(i/datalength)
end
close(h)

