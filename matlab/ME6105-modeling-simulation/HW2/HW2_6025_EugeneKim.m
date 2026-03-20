%% PROBLEM 1 
clear 
clc 

% Number of random variables to generate
N = 10000;

% Rate parameter for the exponential distribution
lambda = 1;

% Generate uniformly distributed random variables
U = rand(N, 1);

% Transform the uniform random variables using the inverse CDF of the exponential distribution
X = -log(1 - U) / lambda;

% Create a histogram of the exponential random variables
figure;
histogram(X, 50, 'Normalization', 'pdf'); % 'pdf' normalizes the histogram to approximate a probability density function
title('Histogram of Exponentially Distributed Random Variables');
xlabel('Value');
ylabel('Probability Density');
grid on;

% Compare with theoretical PDF
hold on;
x_values = linspace(0, max(X), 1000);
pdf_values = lambda * exp(-lambda * x_values);
plot(x_values, pdf_values, 'r-', 'LineWidth', 2);
legend('Histogram', 'Theoretical PDF');

%% PROBLEM 2
close all 
clear 
clc 

% a) 
% Parameters
a = .4;
b = .8;
c = .5; % Adjusted to ensure the covariance matrix is positive semi-definite
mu = [0, 0]; % Mean vector
sigma = [a^2, c^2; c^2, b^2]; % Covariance matrix

% Sample sizes
Ns = [10, 100, 1000, 10000, 100000];

% Cell array to store the generated samples
samples = cell(length(Ns), 1);

% Generate the random variables
for i = 1:length(Ns)
    N = Ns(i);
    samples{i} = mvnrnd(mu, sigma, N);
end

% Plotting the scatter plot of random variables for each N
for i = 1:length(Ns)
    figure; % Create a new figure for each sample size
    scatter(samples{i}(:,1), samples{i}(:,2), 10, 'filled'); % Scatter plot of the samples
    title(['Scatter Plot for N = ', num2str(Ns(i))]);
    xlabel('X1');
    ylabel('X2');
    axis equal;
    grid on;
end

% b)

rho = c^2/(a* b); 
disp(rho)

% Evaluate and display statistical measures
disp('Sample Size | Mean X1 | Mean X2 | Var X1 | Var X2 | Correlation');
for i = 1:length(Ns)
    % Current sample
    X = samples{i};
    
    % Compute sample means
    meanX1 = mean(X(:,1));
    meanX2 = mean(X(:,2));
    
    % Compute sample variances
    varX1 = var(X(:,1), 1); % The second argument '1' normalizes by N (not N-1)
    varX2 = var(X(:,2), 1);
    
    % Compute empirical correlation coefficient
    correlation = corr(X(:,1), X(:,2));
    
    % Display results
    fprintf('%10d | %7.4f | %7.4f | %7.4f | %7.4f | %7.4f\n', Ns(i), meanX1, meanX2, varX1, varX2, correlation);
end

%% PROBLEM 3 
close all 
clear 
clc

% Constants
% a = 1; % Scale parameter for X
% b = 1; % Ensuring the integral of the PDF equals 1
% c = 1; % Scale parameter for the transformation

% a = 1; % Scale parameter for X
% b = 2; % Ensuring the integral of the PDF equals 1
% c = 3; % Scale parameter for the transformation
% 
a = 4; % Scale parameter for X
b = 5; % Ensuring the integral of the PDF equals 1
c = 6; % Scale parameter for the transformation

x_max = 5; % Upper limit for x to plot
y_max = a; % Upper limit for y to plot (since y = a*exp(-c*x))

% Generate x and y values
x = linspace(0, x_max, 1000);
y = linspace(0.001, y_max, 1000); % Avoid zero in computation

% PDF of X
f_X = b * exp(-a * x);

% PDF of Y using the transformation
f_Y = (b/(c*a)) * (y/a).^((a/c)-1) .* exp(-((a/c)*log(y/a)));

% Plotting
figure;
subplot(1,2,1); % Subplot for PDF of X
plot(x, f_X, 'LineWidth', 2);
title('PDF of X');
xlabel('x');
ylabel('f_X(x)');
grid on;

subplot(1,2,2); % Subplot for PDF of Y
plot(y, f_Y, 'LineWidth', 2);
title('PDF of Y');
xlabel('y');
ylabel('f_Y(y)');
grid on;


%% PROBLEM 4 
close all
clear 
clc
% a) 
% Generate Gaussian samples
x = randn(10000, 1);

% Smoothing parameters
sigmas = [0.1, 0.05, 0.025, 0.0125];

% Create a figure for plotting
figure;
hold on; % Hold on to plot multiple lines

% Loop through each sigma and plot the resulting density estimate
for i = 1:length(sigmas)
    [v, f_hat] = KernelDensity(x, sigmas(i), 100);
    plot(v, f_hat, 'LineWidth', 2, 'DisplayName', ['σ = ' num2str(sigmas(i))]);
end

% Add legend and plot details
legend('show');
title('Kernel Density Estimates for Different Smoothing Parameters');
xlabel('Scaled Data Value');
ylabel('Density');
grid on;
hold off;

