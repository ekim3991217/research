clear 
clc

% Given data
mu_X1 = 10;
mu_X2 = 10;
sigma_X1 = 5;
sigma_X2 = 5;
g_target = 0;
tol = 1e-3;
max_iter = 20;

% Initialize variables for HL iterations
X1 = mu_X1;
X2 = mu_X2;
iter_results = []; % Store results for each iteration
beta_prev = 0;

% Hasofer-Lind (HL) method iterations
for iter = 1:max_iter
    % Calculate g(X1, X2) and its partial derivatives
    g_value = X1^3 + X2^3 - 18;
    dg_dX1 = 3 * X1^2;
    dg_dX2 = 3 * X2^2;
    
    % Transform to u-space (standard normal space)
    dg_du1 = dg_dX1 / sigma_X1;
    dg_du2 = dg_dX2 / sigma_X2;
    
    % Compute direction cosines
    norm_grad_g = sqrt(dg_du1^2 + dg_du2^2);
    alpha1 = dg_du1 / norm_grad_g;
    alpha2 = dg_du2 / norm_grad_g;
    
    % Calculate reliability index beta
    beta = abs(g_value) / norm_grad_g;
    
    % Calculate new X values in x-space
    X1_new = mu_X1 - beta * alpha1 * sigma_X1;
    X2_new = mu_X2 - beta * alpha2 * sigma_X2;
    
    % Store iteration results
    iter_results = [iter_results; iter, g_value, dg_dX1, dg_dX2, beta, alpha1, alpha2, X1_new, X2_new];
    
    % Check for convergence
    if abs(beta - beta_prev) < tol
        break;
    end
    
    % Update X1 and X2 for the next iteration
    X1 = X1_new;
    X2 = X2_new;
    beta_prev = beta;
end

% Display results in a table similar to Table 4.1
table_iter = array2table(iter_results, 'VariableNames', ...
    {'Iteration', 'g(X)', 'dg/dX1', 'dg/dX2', 'Beta', 'Alpha1', 'Alpha2', 'X1', 'X2'});
disp('Hasofer-Lind Iteration Results:');
disp(table_iter);


%% Monte Carlo Simulation (MCS) for Comparison
num_samples = 1e6;  % Number of Monte Carlo samples
failure_count = 0;  % Counter for samples where g(X1, X2) < 0

% Generate samples for X1 and X2 based on normal distribution
X1_samples = mu_X1 + sigma_X1 * randn(num_samples, 1);
X2_samples = mu_X2 + sigma_X2 * randn(num_samples, 1);

% Calculate performance function for each sample
g_samples = X1_samples.^3 + X2_samples.^3 - 18;

% Count failures (where g(X1, X2) < 0)
failure_count = sum(g_samples < 0);
P_f = failure_count / num_samples;

% Calculate reliability index from MCS results
beta_mcs = -norminv(P_f);

% Display MCS results
fprintf('\nMonte Carlo Simulation Results:\n');
fprintf('Number of Samples: %d\n', num_samples);
fprintf('Probability of Failure (P_f): %.5f\n', P_f);
fprintf('Reliability Index (Beta) from MCS: %.4f\n', beta_mcs);

% Compare HL method and MCS results
fprintf('\nComparison of HL Method and MCS:\n');
fprintf('Reliability Index (Beta) from HL Method: %.4f\n', beta);
fprintf('Reliability Index (Beta) from MCS: %.4f\n', beta_mcs);
fprintf('Difference in Reliability Index: %.4f\n', abs(beta - beta_mcs));
