clc; clearvars;
 
% Load data from Excel
filename = 'ArtificialDataset.xlsx'
data = readtable(filename);
 
% Extract predictors and response
x = data{:, {'delta_m', 'theta_radian', 'l_m'}}; % Adjust column names as per your Excel file
y = data{:, 'sigma_x_calculated'};              % Replace 'sigma_x_calculated' with your response column name
 
% Normalize predictors (zero mean, unit variance)
x_mean = mean(x, 1);
x_std = std(x, 0, 1);
x_norm = (x - x_mean) ./ x_std;
 
% Add a column of ones to normalized predictors for the intercept term
X = [ones(size(x_norm, 1), 1), x_norm];
 
% Compute regression coefficients
a = pinv(X' * X) * X' * y;
 
% Display normalized coefficients
disp('Coefficients for Normalized Data:');
disp('a0 (Intercept), a1 (delta_m), a2 (theta_radian), a3 (l_m)');
disp(a');
 
% Transform coefficients back to original scale
a0_original = a(1) - sum((a(2:end)' .* x_mean ./ x_std)); % Adjust intercept
a_coeffs_original = a(2:end) ./ x_std'; % Scale back coefficients
 
disp('Original Scale Coefficients:');
disp('a0 (Intercept):');
disp(a0_original);
disp('a1 (delta_m), a2 (theta_radian), a3 (l_m):');
disp(a_coeffs_original');
 
% Predict response using the regression model
y_pred = X * a;
 
% Plot Predicted vs Actual Response
figure;
plot(y, y_pred, 'bo', 'MarkerSize', 8, 'LineWidth', 1.5); % Actual vs Predicted
hold on;
plot([min(y), max(y)], [min(y), max(y)], 'r--', 'LineWidth', 1.5); % y = x line
hold off;
xlabel('Actual \sigma_x');
ylabel('Predicted \sigma_x');
title('Predicted vs Actual Response');
grid on;
legend('Data Points', 'Ideal Fit (y = x)', 'Location', 'Best');
 
% Residual Plot
residuals = y - y_pred;
figure;
plot(y_pred, residuals, 'bo', 'MarkerSize', 8, 'LineWidth', 1.5);
yline(0, 'r--', 'LineWidth', 1.5); % Zero residual line
xlabel('Predicted \sigma_x');
ylabel('Residuals');
title('Residuals vs Predicted Response');
grid on;