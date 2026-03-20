clear 
clc
close all

% Step 1: Initialize weights randomly
w = -1 + 2.*rand(3, 1);  % 3 weights for 3 inputs

% Step 2: Training data (X1, X2, X3, Y)
data = [0 0 1 0; 0 1 1 1; 1 0 1 1; 1 1 1 0];
X = data(:, 1:3);  % Input features
Y = data(:, 4);    % True labels

% Step 3: Define the sigmoid function and its derivative
sigmoid = @(z) 1 ./ (1 + exp(-z));
sigmoid_prime = @(z) sigmoid(z) .* (1 - sigmoid(z));

% Learning rate
eta = 0.9;

% Initialize matrix to store MSE for each epoch
mse_matrix = zeros(10000, 1);

% Print the header of the table
fprintf('Epoch\tError\t\tPredicted Y\n');
fprintf('-----\t-----\t\t-----------\n');

% Step 4-7: Train the model
for epoch = 1:10000
    cumulative_error = 0;  % Initialize cumulative error for each epoch
    y_pred_epoch = [];  % Store predicted values for each epoch

    for i = 1:size(X,1)
        % Forward pass
        z = X(i,:) * w;
        y_hat = sigmoid(z);
        y_pred_epoch = [y_pred_epoch y_hat];  % Store last prediction

        % Calculate the error
        error = y_hat - Y(i);
        cumulative_error = cumulative_error + error^2;  % Sum squared error

        % Backpropagation
        gradient = error * sigmoid_prime(z) * X(i,:)';

        % Update weights
        w = w - eta * gradient;
    end

    % Calculate mean squared error for the epoch
    mse_matrix(epoch) = cumulative_error / size(X, 1);  % Store MSE in the matrix

    % Conditionally print the MSE and predicted Y based on the specified intervals
    if (epoch <= 10) || ...
       (epoch >= 100 && epoch <= 1000 && mod(epoch, 100) == 0) || ...
       (epoch >= 1000 && mod(epoch, 1000) == 0)
        fprintf('%d\t%.4f\t\t%.4f\n', epoch, mse_matrix(epoch), y_pred_epoch(end));
    end
end

% Output the final weights
disp('Final weights:');
disp(w);
