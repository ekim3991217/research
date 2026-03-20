%% dynamic equation of planar 2R robot
% symbolic derivation of Lagrange equations

close all;clear all;clc;

syms t g

%Link Parameters
l  = sym('l_%d', [1 2]).'; %length of link
lg = sym('lg_%d', [1 2]).'; %location of center of gravity on link
m  = sym('m_%d', [1 2]).'; %mass of link
I  = sym('I_%d', [1 2]).'; %inertia of link about center assuming principle axes
 
%Define System Coordinates and Derivatives
syms  q1(t)   q2(t)
syms  dq1(t)  dq2(t)  
syms ddx(t) ddy(t) ddq1(t) ddq2(t)

q   = [q1(t) q2(t)].';
dq  = [dq1(t) dq2(t)].';
ddq = [ddq1(t) ddq2(t)].';
diff_q  = diff(q,t);
diff_dq = diff(dq,t);

%% Kinematics

Oe  = sym(zeros(2,2));
Oe(:,1) = l(1)*[cos(q(1));sin(q(1))];
Og(:,1) = lg(1)*[cos(q(1));sin(q(1))];
ang=q(1)+q(2);
Oe(:,2) = Oe(:,1)+ l(2)*[cos(ang);sin(ang)];
Og(:,2) = Oe(:,1)+ lg(2)*[cos(ang);sin(ang)];



Ve = diff(Oe);
Vg = diff(Og);

Ve = subs(Ve, diff_q, dq);
Vg = subs(Vg, diff_q, dq);


%% Energy

%Potential Energy

PE=Og(2,:)*m*g;
 

%Kinetic Energy
KElin = sym(0);
KErot = sym(0);
for i = 1:2
    KElin = KElin + 0.5*m(i)*Vg(:,i).'*Vg(:,i);
    KErot = KErot + 0.5*I(i)*(sum(dq(1:i)))^2;
end
KE = KElin + KErot;

L = KE-PE;

dLddqdt = sym(zeros(2,1));
dLdq = sym(zeros(2,1));
 
for i = 1:length(q)
    dLdq(i) = functionalDerivative(L, q(i));
    tmp = functionalDerivative(L, dq(i));
    tmp = diff(tmp, t);
    dLddqdt(i) = subs(tmp, [diff_q diff_dq], [dq ddq]);
end
EOM = dLddqdt  - dLdq;
disp('Entire DEOM')
transpose(simplify(EOM))

%% h(q,dot q) only

for i = 1:length(q)
    dKdq(i) = functionalDerivative(KE, q(i));
    tmpK = functionalDerivative(KE, dq(i));
    tmpK = diff(tmpK, t);
    dLddqdtK(i) = subs(tmpK, [diff_q diff_dq], [dq zeros(size(diff_dq))]);
end
disp('h(q,dot q)')
EOMH = simplify(dLddqdtK-dKdq);
transpose(EOMH)

%% g(q) only

for i = 1:length(q)
    dPdq(i) = functionalDerivative(-PE, q(i));
    %tmpP = functionalDerivative(-PE, dq(i));
    %tmpP = diff(tmpP, t);
    %dLddqdtP(i) = subs(tmpP, [diff_q diff_dq], [0 0]);
end

disp('g(q)')
EOMG = simplify(-dPdq);
transpose(EOMG)



