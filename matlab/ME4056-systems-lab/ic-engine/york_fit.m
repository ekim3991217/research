function [a, b, sigma_a, sigma_b, b_save] = york_fit(X,Y,sigma_X,sigma_Y, r)
%[a, b, sigma_a, sigma_b, b_save] = york_fit(X,Y,sigma_X,sigma_Y, r)
%Performs linear regression for data with errors in both X and Y, following
%the method in York et al.
%X,Y are row vectors of regression data.
%sigma_X and sigma_Y are row vectors or single values for the error in X
%and Y.
%r is a row vector or singal value for the correlation coefficeients
%between the errors.
%
% a (First Result) is the intercept
% b (Second Result) is the slope
%
%References:
%D. York, N. Evensen, M. Martinez, J. Delgado "Unified equations for the
%slope, intercept, and standard errors of the best straight line" Am. J.
%Phys. 72 (3) March 2004.

%Original Code by: Travis Wiens 2010
%Edited by: David MacNair 2020
%    Edited for clarity with students and added X and Y coersion


%Note: Y = a + b*X
%This is backwards from the typical Y = a*X + b Notation


%If X is provided as a column vector, convert to a row vector
[X_s1,X_s2]=size(X);
if X_s1 > X_s2
    X = X';
    sigma_X = sigma_X';
end

%If Y is provided as a column vector, convert to a row vector
[Y_s1,Y_s2]=size(Y);
if Y_s1 > Y_s2
    Y = Y';
    sigma_Y = sigma_Y';
end

N_itermax = 10; %Maximum Number of Interations
tol = 1e-15; %Relative Tolerance to Stop At

N = numel(X); %Determine Number of X Values

if nargin < 5 %If 5th arguement (r) is not provided, assume it is 0
    r = 0;
end

if numel(sigma_X) == 1 %If 1 Value Provided for X Standard Error, Set It For All X Values
    sigma_X = sigma_X*ones(1,N);
end

if numel(sigma_Y) == 1 %If 1 Value Provided for Y Standard Error, Set It For All X Values
    sigma_Y = sigma_Y*ones(1,N);
end

if numel(r) == 1 %If 1 Value Provided for Covarience(r), Set It For All Covarience Values
    r = r*ones(1,N);
end

%Make Initial Guess at b Using Least Squares
tmp = Y/[X; ones(1,N)]; %Determine Least Squares Estimate
b_lse = tmp(1); %Use the first result (slope) as guess for slope
%a_lse = tmp(2);

b = b_lse; %Initial Guess for Slope

omega_X = 1./sigma_X.^2; %1 / Variance X
omega_Y = 1./sigma_Y.^2; %1 / Variance Y

alpha = sqrt(omega_X.*omega_Y);

b_save = zeros(1,N_itermax+1); % Vector to Save b Iterations
b_save(1) = b; % Save First b Value

for i = 1:N_itermax
    W = omega_X.*omega_Y./(omega_X+b^2*omega_Y-2*b*r.*alpha);

    X_bar = sum(W.*X)/sum(W);
    Y_bar = sum(W.*Y)/sum(W);

    U = X-X_bar;
    V = Y-Y_bar;

    beta = W.*(U./omega_Y+b*V./omega_X-(b*U+V).*r./alpha);

    b = sum(W.*beta.*V)/sum(W.*beta.*U);
    b_save(i+1) = b;
    if abs((b_save(i+1)-b_save(i))/b_save(i+1)) < tol %Difference Between b Values is Below Tolerance
        break
    end
end

a = Y_bar-b*X_bar;

x = X_bar+beta;
%y = Y_bar+b*beta;

x_bar = sum(W.*x)/sum(W);
%y_bar = sum(W.*y)/sum(W);

u = x-x_bar;
%v = y-y_bar;

sigma_b = sqrt(1/sum(W.*u.^2));
sigma_a = sqrt(1./sum(W)+x_bar^2*sigma_b^2);