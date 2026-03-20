%pset 3 pick-and-place
m1=10;
m2=5;
a1=3;
a2=2;

m=m1;
P=tf([1],[m m*a1 m*a2 0]);

step(P)