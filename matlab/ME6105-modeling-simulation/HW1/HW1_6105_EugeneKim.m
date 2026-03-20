%% PROBLEM 1
clear 
clc

% Defining the data
Ni = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13];
pi = [0, 3, 27, 60, 85, 108, 127, 153, 172, 146, 82, 33, 4];

% Total observations
total_observations = sum(pi);

% Mean calculation
mean = sum(Ni .* pi) / total_observations;

% Standard deviation calculation
std_dev = sqrt(sum(pi .* (Ni - mean).^2) / total_observations);

% Coefficient of variation
coeff_of_variation = std_dev / mean;

% Skewness
skewness = sum(pi .* (Ni - mean).^3) / (std_dev^3 * total_observations);

% Kurtosis
kurtosis = sum(pi .* (Ni - mean).^4) / (std_dev^4 * total_observations);

% Display results
fprintf('Mean: %f\n', mean);
fprintf('Standard Deviation: %f\n', std_dev);
fprintf('Coefficient of Variation: %f\n', coeff_of_variation);
fprintf('Skewness: %f\n', skewness);
fprintf('Kurtosis: %f\n', kurtosis);

%% PROBLEM 2
clear 
clc

% Define probabilities
P_A = 0.9; % Probability section meets spec
P_B_given_A = 0.8; % Probability test accepts given section meets spec
P_B_given_Ac = 0.2; % Probability test accepts given section does not meet spec

% Calculating P(Ac)
P_Ac = 1 - P_A;

% (a) Probability section meets spec and is accepted by the test
P_A_and_B = P_B_given_A * P_A;

% (b) Probability section does not meet spec but is accepted by the test
P_Ac_and_B = P_B_given_Ac * P_Ac;

% (c) Probability a properly constructed section will be accepted
P_B_if_A = P_B_given_A; % This is straightforward as it's a given value

% Display the results
fprintf('Probability that a section meets the spec and is accepted: %f\n', P_A_and_B);
fprintf('Probability that a section does not meet the spec but is accepted: %f\n', P_Ac_and_B);
fprintf('Probability that a properly constructed section is accepted: %f\n', P_B_if_A);

%% PROBLEM 3
clear 
clc


