%% review simple spring-mass-damper response analysis

m=1
b=1
k=5
f=1 %constant force

% analytical solution of dynamic equation
% ddot x = -b/m dot x -k/m x + f

syms y(t)
Dy=diff(y)
ode=diff(y,t,2)==-b/m * diff(y,t,1)-k/m*y+f
cond1 = y(0) == 0
cond2 = Dy(0) == 0
conds = [cond1 cond2]
ySol(t) = dsolve(ode,conds)

tt=0:0.1:5;
figure()
plot(tt, subs(ySol,tt))
grid

% numerical solution of dynamic equation
% ddot x = -b/m dot x -k/m x + f
[V]=odeToVectorField(ode);
M = matlabFunction(V,'vars', {'t','Y'});
sol = ode45(M,[0 10],[0 0]);
figure()
fplot(@(x)deval(sol,x,1), [0, 10])
grid

% transfer function and its step input
figure()
G=tf(1,[m b k])
step(G)
grid

%also see SIMULINK
