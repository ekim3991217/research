clear;
clc;
close all;

% Define the limit state function g(X)
g = @(x1, x2) 61./x1.^3 + 37./x2.^3 - 1;

% Points for regression and approximation
X1 = [1.3, 1];
X2 = [0.7, 1];

% Evaluate the function at these points
g_values = g(X1, X2);

% Creating a range for plotting
x_range = linspace(0.7, 1.3, 100);
[X1_grid, X2_grid] = meshgrid(x_range, x_range);

% Evaluate the true function for comparison
g_true = g(X1_grid, X2_grid);

% Two-point Taylor Series Approximation
% Calculate the partial derivatives at X_1
dg_dX1 = -3 * 61 / X1(1)^4; % Partial derivative with respect to x1 at X_1
dg_dX2 = -3 * 37 / X2(1)^4; % Partial derivative with respect to x2 at X_1

% Taylor approximation function based on point X_1
taylor_approx = @(x1, x2) g_values(1) + dg_dX1 * (x1 - X1(1)) + dg_dX2 * (x2 - X2(1));

% Evaluate Taylor approximation
g_taylor = arrayfun(taylor_approx, X1_grid, X2_grid);

% Polynomial Regression - Linear Fit
% Construct design matrix for linear regression
A = [X1', X2', ones(size(X1'))];
b = g_values';

% Solve the normal equations A'*A*p = A'*b
p = (A'*A) \ (A'*b);

% Evaluate polynomial regression
g_poly = p(1) * X1_grid + p(2) * X2_grid + p(3);

% Plotting results
figure;
hold on;
surf(X1_grid, X2_grid, g_true, 'FaceAlpha',0.5, 'EdgeColor', 'none', 'DisplayName', 'True Function');
mesh(X1_grid, X2_grid, g_taylor, 'FaceColor', 'r', 'EdgeColor', 'k', 'DisplayName', 'Taylor Approximation');
mesh(X1_grid, X2_grid, g_poly, 'FaceColor', 'b', 'EdgeColor', 'k', 'DisplayName', 'Polynomial Regression');
scatter3(X1, X2, g_values, 100, 'ko', 'filled', 'DisplayName', 'Data Points');
xlabel('x1 values');
ylabel('x2 values');
zlabel('g(X) values');
legend show;
title('Comparison of True Function, Polynomial Regression, and Taylor Approximation');
grid on;
hold off;

% Calculate Mean Squared Errors
mse_taylor = immse(g_taylor(:), g_true(:));
mse_poly = immse(g_poly(:), g_true(:));

% Display MSE for comparison
fprintf('\nMean Squared Error for Taylor Approximation: %f\n', mse_taylor);
fprintf('Mean Squared Error for Polynomial Regression: %f\n', mse_poly);
