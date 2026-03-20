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

% Fit a linear regression model using multiple predictors
mdl = fitlm([x1, x2, x3], y);

% ANOVA for the linear model
anovaResults = anova(mdl, 'summary');

% Display the ANOVA table in console
disp('ANOVA Table:');
disp(anovaResults);

% Extract the F-value from the ANOVA table
Fo = anovaResults{2, 5}; % F-value for the model fit

% Get degrees of freedom for MSM and MSE
df1 = anovaResults{2, 3}; % MSM degrees of freedom
df2 = anovaResults{3, 3}; % MSE degrees of freedom

% Specify the significance level, usually 0.05 for 95% confidence
alpha = 0.05;

% Calculate the critical F-value from the F-distribution
Fo_alpha = finv(1-alpha, df1, df2);

% Display the results
fprintf('Calculated F-value (Fo): %f\n', Fo);
fprintf('Critical F-value (Fo_alpha) for alpha = %f: %f\n', alpha, Fo_alpha);

% Decision
if Fo > Fo_alpha
    fprintf('The model is statistically significant at %f level.\n', alpha);
else
    fprintf('The model is not statistically significant at %f level.\n', alpha);
end
