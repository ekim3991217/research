clear;
clc;
close all;

% Step 1: Generate training data
mu = 10;
sigma = 5;
num_samples = 10000; % Increased number of data points to improve training
X1 = normrnd(mu, sigma, [num_samples, 1]);
X2 = normrnd(mu, sigma, [num_samples, 1]);

% True output based on the limit state function
Y = X1.^3 + X2.^3 - 18;

% Step 2: Create and train a feedforward neural network
net = feedforwardnet([10 10]); % Example architecture with two hidden layers of 10 neurons each
net.divideParam.trainRatio = 0.7;
net.divideParam.valRatio = 0.15;
net.divideParam.testRatio = 0.15;
net = train(net, [X1 X2]', Y');

% Step 3: Predict outputs using the trained network
Y_pred = net([X1 X2]');

% Calculate mean squared error
mse_value = mse(Y - Y_pred);

% Display the MSE
fprintf('Mean Squared Error: %f\n', mse_value);

% Step 4: Display results in a 3D plot
figure;
plot3(X1, X2, Y, 'ro'); % Actual data
hold on;
plot3(X1, X2, Y_pred, 'b*'); % Predicted data
xlabel('X1');
ylabel('X2');
zlabel('g(X1, X2)');
title('3D Plot of Actual vs. Predicted Results');
legend('Actual', 'Predicted');

%% Step 5: MCS to estimate Pf
failure_threshold = 0; % Assuming failure when g(X1, X2) < 0
failures = sum(Y < failure_threshold);
Pf = failures / num_samples;

% Display Pf
fprintf('Probability of Failure (Pf): %f\n', Pf);

% Save the model and results
save('trainedModel.mat', 'net');
save('results.mat', 'X1', 'X2', 'Y', 'Y_pred', 'mse_value', 'Pf');

