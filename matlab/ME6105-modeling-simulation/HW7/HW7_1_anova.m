% HW7_1_anova.m
clear 
clc
close all

%% PART A) LINEAR REGRESSION

% Define the data
x1 = [90; 100; 110; 120];  % Load (N)
x2 = [150; 100; 200; 160]; % Young's Modulus (GPa)
d = [1.2; 2; 1.1; 1.6];    % Deflection (mm)

% Create design matrix for linear regression
X = [ones(length(x1), 1), x1, x2];  % Including intercept

% Linear regression
[b, bint, r, rint, stats] = regress(d, X);  % b contains coefficients

% Display regression coefficients
fprintf('Calculated Linear Regression Coefficient:\n');
fprintf('Intercept: %f\n', b(1));
fprintf('Load (x1): %f\n', b(2));
fprintf('Young''s Modulus (x2): %f\n', b(3));

% Predicting deflection using the regression model
predicted_d = X * b;

% Prediction v. Actual Deflection Plot
figure;
plot(x1, d, 'bo', 'MarkerSize', 8, 'DisplayName', 'Observed Deflections'); % Original data points
hold on;
plot(x1, predicted_d, 'r-', 'LineWidth', 2, 'DisplayName', 'Predicted Deflections'); % Predicted regression line

% Plot labels
xlabel('Load (N)');
ylabel('Deflection (mm)');
title('Regression Analysis: Deflection vs Load and Young''s Modulus');
legend('show');
grid on;

% Save plot if needed
% saveas(gcf, 'regression_plot.png');

%% PART B) ANOVA

% Number of observations and predictors
n = length(d);
p = 2;  % excluding the intercept

% Sum of Squares
SST = sum((d - mean(d)).^2);  % Total Sum of Squares
SSR = sum((X * b - mean(d)).^2);  % Regression Sum of Squares
SSE = sum(r.^2);  % Error Sum of Squares

% Degrees of Freedom
dfT = n - 1;  % Total
dfR = p;      % Regression
dfE = n - p - 1;  % Error

% Mean Square
MSR = SSR / dfR;
MSE = SSE / dfE;

% F-statistic
F = MSR / MSE;

% Display ANOVA table
fprintf('\nANOVA Table:\n');
fprintf('Source\t\tSS\t\tdf\tMS\t\tF\n');
fprintf('Regression\t%f\t%d\t%f\t%f\n', SSR, dfR, MSR, F);
fprintf('Error\t\t%f\t%d\t%f\n', SSE, dfE, MSE);
fprintf('Total\t\t%f\t%d\n\n', SST, dfT);

% F-test
fprintf('The calculated F-statistic is %f\n', F);
if F > 1.614 % Critical Value Given in Problem Statement
    fprintf('The regression model is significant at the chosen level (F-critical = 1.614).\n');
else
    fprintf('The regression model is not significant.\n');
end

