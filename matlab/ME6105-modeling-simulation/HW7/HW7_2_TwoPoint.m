% HW7_2_TwoPoint.m
clear 
clc 
close all

% Define the limit state function
g = @(x1, x2) 61./x1.^3 + 37./x2.^3 - 1;

% Points for the two-point approximation
X1 = [1.3, 0.7];
X2 = [1, 1];

% Function values at these points
gX1 = g(X1(1), X1(2));
gX2 = g(X2(1), X2(2));

% Derivatives at both points
dg_dx1_1 = -183 * X1(1)^-4;  % Partial derivative with respect to x1 at point 1
dg_dx2_1 = -111 * X1(2)^-4;  % Partial derivative with respect to x2 at point 1
dg_dx1_2 = -183 * X2(1)^-4;  % Partial derivative with respect to x1 at point 2
dg_dx2_2 = -111 * X2(2)^-4;  % Partial derivative with respect to x2 at point 2

% Linear interpolation using Taylor series expansion
% Interpolating between two points based on Taylor expansion at point 1
g_approx = @(x1, x2) gX1 + dg_dx1_1 * (x1 - X1(1)) + dg_dx2_1 * (x2 - X1(2));

% g_values = g(X1, X2);
% 
% % Polynomial Regression: Fit a cubic polynomial
% p = polyfitn([X1', X2'], g_values', 3);
% 
% % Evaluate polynomial regression
% g_poly_vals = polyvaln(p, [X1_grid(:), X2_grid(:)]);
% g_poly_vals = reshape(g_poly_vals, size(X1_grid));
% Range for evaluation
x_range = linspace(0.5, 1.5, 100);
[X1_grid, X2_grid] = meshgrid(x_range, x_range);
g_true = g(X1_grid, X2_grid);
g_approx_vals = arrayfun(g_approx, X1_grid, X2_grid);

g_values = g(X1, X2);


% Create polynomial features for each variable up to the third degree
% Including interaction terms
X1_poly = [X1' X1'.^2 X1'.^3 X1'.*X2' X1'.^2.*X2' X1'.*X2'.^2];
X2_poly = [X2' X2'.^2 X2'.^3 X1'.*X2' X1'.*X2'.^2 X1'.^2.*X2'];

% Combine all polynomial features
X_poly = [ones(length(X1), 1), X1_poly, X2_poly]; % Include a column for the intercept

% Perform linear regression to find the coefficients
coefficients = (X_poly' * X_poly) \ (X_poly' * g_values');

% Evaluate the polynomial regression model over the grid
g_poly_vals = coefficients(1) + coefficients(2) * X1_grid + coefficients(3) * X1_grid.^2 + ...
              coefficients(4) * X1_grid.^3 + coefficients(5) * X1_grid .* X2_grid + ...
              coefficients(6) * X1_grid.^2 .* X2_grid + coefficients(7) * X1_grid .* X2_grid.^2 + ...
              coefficients(8) * X2_grid + coefficients(9) * X2_grid.^2 + ...
              coefficients(10) * X2_grid.^3 + coefficients(11) * X1_grid .* X2_grid + ...
              coefficients(12) * X1_grid .* X2_grid.^2 + coefficients(13) * X1_grid.^2 .* X2_grid;


% Visualization
figure;
mesh(X1_grid, X2_grid, g_true);
hold on;
mesh(X1_grid, X2_grid, g_approx_vals);
mesh(X1_grid, X2_grid, g_poly_vals);
legend('True Function', 'Two-point Taylor Approximation', 'Linear FIt');
xlabel('x1');
ylabel('x2');
zlabel('g(X)');
title('Comparison of Two Point and Common Regression');
grid on;
hold off;
% 
% % Plotting results
% figure;
% hold on;
% mesh(X1_grid, X2_grid, g_true, 'DisplayName', 'True Function');
% mesh(X1_grid, X2_grid, g_approx_vals, 'FaceColor', 'r', 'DisplayName', 'Two-point Approximation');
% mesh(X1_grid, X2_grid, g_poly_vals, 'FaceColor', 'b', 'DisplayName', 'Polynomial Regression');
% scatter3(X1, X2, g_values, 100, 'k', 'filled', 'DisplayName', 'Data Points');
% colorbar;
% legend('show');
% xlabel('x1');
% ylabel('x2');
% zlabel('g(X)');
% title('Comparison of True Function, Two-Point Approximation, and Polynomial Regression');
% grid on;
% hold off;
% 
% % Mean Squared Error Calculation
% mse_two_point = immse(g_approx_vals, g_true);
% mse_poly = immse(g_poly_vals, g_true);
% 
% % Print MSE for comparison
% fprintf('\nMean Squared Error for Two-point Approximation: %f\n', mse_two_point);
% fprintf('Mean Squared Error for Polynomial Regression: %f\n', mse_poly);



