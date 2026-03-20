clc 
clear 
close all

% Parameters
L = 0.0013; % Fixed value of L in m

% Coefficients of Linear Regression Equation
% Assuming the regression equation is: 
% f(δ, θ, l) = c1*δ + c2*θ + c3*l + c4
c1 = 615.6452; % Example coefficient for δ
c2 = 468.2088; % Example coefficient for θ
c3 = -52.3036; % Example coefficient for l
c4 = 627.7699; % Example constant term

% Define bounds
lb = [eps, deg2rad(0), 0.1]; % Lower bounds: delta, theta (radians), l
ub = [0.35, deg2rad(10), 0.3]; % Upper bounds: delta, theta (radians), l

% Initial guess
x0 = [0.2, deg2rad(5), 0.2]; % A reasonable starting point within bounds

% Objective Function (Linear Regression Equation)
objective = @(x) c1 * x(1) + c2 * x(2) + c3 * x(3) + c4;

% Constraints Function
constraints = @(x) compute_constraints(x, L);

% Run fmincon
options_fmincon = optimoptions('fmincon', 'Display', 'iter');
[x_opt_fmincon, fval_fmincon] = fmincon(objective, x0, [], [], [], [], lb, ub, constraints, options_fmincon);

% Display results
fprintf('=== Results using fmincon ===\n');
fprintf('Optimal delta: %.10f m\n', x_opt_fmincon(1));
fprintf('Optimal theta: %.10f radians (%.6f degrees)\n', x_opt_fmincon(2), rad2deg(x_opt_fmincon(2)));
fprintf('Optimal l: %.10f mm\n', x_opt_fmincon(3));
fprintf('Minimum objective function value: %.6f\n', fval_fmincon);


function [c, ceq] = compute_constraints(x, L)
    delta = x(1);
    theta = x(2);
    l = x(3);
    
    % Inequality constraints (c <= 0)
    c(1) = (L * theta) / (L + 2 * l) - 0.2; % Constraint 1
    c(2) = -delta; % Constraint 2 (delta >= 0)
    c(3) = delta - 0.35; % Constraint 2 (delta <= 0.35)
    c(4) = -theta; % Constraint 3 (theta >= 0)
    c(5) = theta - deg2rad(10); % Constraint 3 (theta <= 10 degrees)
    c(6) = -l; % Constraint 4 (l >= 0.1)
    c(7) = l - 0.3; % Constraint 4 (l <= 0.3)
    
    % Equality constraints (ceq = 0)
    ceq = [];
end

