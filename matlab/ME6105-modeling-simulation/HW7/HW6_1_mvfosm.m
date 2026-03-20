% Given data
mu_Fy = 38;  % Mean of Fy in ksi
sigma_Fy = 3.8;  % Standard deviation of Fy in ksi
mu_Z = 54;  % Mean of Z in in^3
sigma_Z = 2.7;  % Standard deviation of Z in in^3
M = 1140;  % Deterministic bending moment in kip-in

% Part (a) Reliability index calculation
% Step 1: Calculate mean of g
mu_g_a = mu_Fy * mu_Z - M;

% Step 2: Calculate standard deviation of g
sigma_g_a = sqrt((sigma_Fy * mu_Z)^2 + (sigma_Z * mu_Fy)^2);

% Step 3: Calculate reliability index for part (a)
beta_a = mu_g_a / sigma_g_a;

% Display result for part (a)
fprintf('Reliability index for part (a): %.4f\n', beta_a);

% Part (b) Reliability index calculation
% Step 1: Calculate mean of g for part (b)
mu_g_b = mu_Fy - (M / mu_Z);

% Step 2: Calculate standard deviation of g for part (b)
sigma_g_b = sqrt(sigma_Fy^2 + ((M * sigma_Z) / mu_Z^2)^2);

% Step 3: Calculate reliability index for part (b)
beta_b = mu_g_b / sigma_g_b;

% Display result for part (b)
fprintf('Reliability index for part (b): %.4f\n', beta_b);
