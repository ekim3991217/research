%% Linear algebra practice: some exercises from Vector and Matrices Review document

%% vector components
unitvectorx=[1 0 0]'  %"i" vector
unitvectory=[0 1 0]'  %"j" vector
unitvectorz=[0 0 1]'  %"k" vector

%problem 1-(d)
d_vector=2*unitvectorx+2*unitvectory-unitvectorz
w_vector=7*unitvectorx-2*unitvectory+12*unitvectorz

figure(100)
vectdata=[zeros(3,1) w_vector];
plot3(vectdata(1,:), vectdata(2,:), vectdata(3,:) )
grid


%% cross products

%unitvectorx (cross) unitvectory = unitvectorz
cross(unitvectorx,unitvectory)

%note the order matters: problem 15
%unitvectory (cross) unitvectorz = - unitvectorz
cross(unitvectory,unitvectorx)

%[a (cross)] can be expressed as a matrix: problem 19
a=w_vector

a_mat_cross=[0 -a(3) a(2);a(3) 0 -a(1);-a(2) a(1) 0]

%verification (same results)
cross(w_vector, d_vector)
a_mat_cross*d_vector


%% Matrices
%singular matrix: problem 26

 A=[6 -2 0;25 17 2;3 -1 0]

 
rank(A); %rank=2<3
det(A); %is zero

% inverse of an orthogonal matrix is its transpose: problem 28

syms t
Rx = [1 0 0; 0 cos(t) -sin(t); 0 sin(t) cos(t)] %rotation about x axis
%Ry = [cos(t) 0 sin(t); 0 1 0; -sin(t) 0 cos(t)] %rotation about y axis
%Rz = [cos(t) -sin(t) 0; sin(t) cos(t) 0; 0 0 1] %rotation about z axis

simplify(inv(Rx))
transpose(Rx)

%inverse and transpose computation
%(AB)^T=B^T B^T
 B=[3 -4 0;4 3 0; 0 0 1];
 
 transpose(A*B)
 transpose(B)*transpose(A)
 

