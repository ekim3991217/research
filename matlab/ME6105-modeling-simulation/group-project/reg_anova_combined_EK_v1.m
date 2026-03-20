clear
clc
close all

% Import data from the first sheet of an Excel file
data = readtable('ArtificialDataset_ANOVA.xlsx', 'Sheet', 1);

% Extract variables from the table
x1 = data.x1_delta_m;
x2 = data.x2_theta_radian;
x3 = data.x3_l_m;
y = data.y_sigma_x_calculated;

% Combine predictors into a matrix
X = [x1, x2, x3];

%% 1. Perform the three regressions
% (a) Common regression (Ordinary Least Squares - OLS)
mdl_ols = fitlm(X, y);

% (b) Linear regression (LASSO)
[b_lasso, FitInfo_lasso] = lasso(X, y, 'Alpha', 1, 'CV', 10); % Cross-validated LASSO
b0_lasso = FitInfo_lasso.Intercept(FitInfo_lasso.IndexMinMSE); % Intercept
lasso_eq = ['y = ', num2str(b0_lasso), ' + '];

% Generate LASSO equation
for i = 1:length(b_lasso(:, FitInfo_lasso.IndexMinMSE))
    if b_lasso(i, FitInfo_lasso.IndexMinMSE) ~= 0
        lasso_eq = [lasso_eq, num2str(b_lasso(i, FitInfo_lasso.IndexMinMSE)), '*x', num2str(i), ' + '];
    end
end
lasso_eq = lasso_eq(1:end-2);

% (c) Linear regression (Ridge)
lambda = 1; % Ridge regularization parameter
b_ridge = ridge(y, X, lambda, 0);

% Compute intercept for Ridge regression
ridge_intercept = mean(y) - mean(X) .* b_ridge;
ridge_eq = ['y = ', num2str(ridge_intercept), ' + '];

% Generate Ridge equation
for i = 1:length(b_ridge)
    ridge_eq = [ridge_eq, num2str(b_ridge(i)), '*x', num2str(i), ' + '];
end
ridge_eq = ridge_eq(1:end-2);

%% 2. Print regression equations
disp('Regression equations:');
disp('OLS regression equation:');
disp(mdl_ols.Formula);
disp('LASSO regression equation:');
disp(lasso_eq);
disp('Ridge regression equation:');
disp(ridge_eq);

%% 3. Perform ANOVA for each method
% ANOVA for OLS
anova_ols = anova(mdl_ols, 'summary');

% Generate dummy y_hat for LASSO and Ridge for ANOVA
y_hat_lasso = X * b_lasso(:, FitInfo_lasso.IndexMinMSE) + b0_lasso;
mdl_lasso = fitlm(y_hat_lasso, y);

y_hat_ridge = X * b_ridge + ridge_intercept;
mdl_ridge = fitlm(y_hat_ridge, y);

% ANOVA for LASSO and Ridge
anova_lasso = anova(mdl_lasso, 'summary');
anova_ridge = anova(mdl_ridge, 'summary');

%% 4. Statistical comparison and model selection
% Extract F-statistics and p-values
Fo_ols = anova_ols{2, 5};
Fo_lasso = anova_lasso{2, 5};
Fo_ridge = anova_ridge{2, 5};

p_ols = anova_ols{2, 6};
p_lasso = anova_lasso{2, 6};
p_ridge = anova_ridge{2, 6};

% Print ANOVA tables
disp('ANOVA Table - OLS:');
disp(anova_ols);
disp('ANOVA Table - LASSO:');
disp(anova_lasso);
disp('ANOVA Table - Ridge:');
disp(anova_ridge);

% Model comparison
disp('Statistical comparison:');
fprintf('OLS: F = %.2f, p = %.4f\n', Fo_ols, p_ols);
fprintf('LASSO: F = %.2f, p = %.4f\n', Fo_lasso, p_lasso);
fprintf('Ridge: F = %.2f, p = %.4f\n', Fo_ridge, p_ridge);

% Model selection
if Fo_ols > Fo_lasso && Fo_ols > Fo_ridge
    fprintf('OLS regression provides the best fit with highest statistical significance (p = %.4f).\n', p_ols);
elseif Fo_lasso > Fo_ols && Fo_lasso > Fo_ridge
    fprintf('LASSO regression provides the best fit with highest statistical significance (p = %.4f).\n', p_lasso);
else
    fprintf('Ridge regression provides the best fit with highest statistical significance (p = %.4f).\n', p_ridge);
end
