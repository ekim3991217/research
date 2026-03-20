clear 
clc
close all

% Step 1: Initialize weights to 1 for all layers according to Model 2 structure
% For a neural network with multiple layers as depicted, the specific structure (layer sizes) is needed to define weights accurately.
% Let's assume there are 4 nodes in the first hidden layer and 2 in the second hidden layer based on the image of Model 2.

% Initial weights from input to first hidden layer (assuming 3 input nodes plus bias)
W1 = ones(4, 4);  % 4 weights for each of the 4 nodes in the first hidden layer

% Initial weights from first to second hidden layer
W2 = ones(2, 5);  % 2 weights for each of the 2 nodes in the second hidden layer plus bias

% Initial weights from second hidden layer to output
W3 = ones(1, 3);  % 1 weight for each of the 1 output node plus bias

% Step 2: Training data (X1, X2, X3, Y)
data = [0 0 1 0; 0 1 1 1; 1 0 1 1; 1 1 1 0];
X = [data(:, 1:3), ones(size(data, 1), 1)];  % Add bias term to input features
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

% Step 4-7: Train the model for 10000 iterations
for epoch = 1:10000
    cumulative_error = 0;  % Initialize cumulative error for each epoch
    y_pred_epoch = [];  % Store predicted values for each epoch

    for i = 1:size(X,1)
        % Forward pass through each layer
        z1 = X(i,:) * W1';
        a1 = sigmoid(z1);  % Activation from first hidden layer
        a1 = [a1, 1];  % Adding bias to the activations for the next layer
        
        z2 = a1 * W2';
        a2 = sigmoid(z2);  % Activation from second hidden layer
        a2 = [a2, 1];  % Adding bias for the output layer

        z3 = a2 * W3';
        y_hat = sigmoid(z3);  % Output activation
        y_pred_epoch = [y_pred_epoch y_hat];  % Store last prediction

        % Calculate the error
        error = y_hat - Y(i);
        cumulative_error = cumulative_error + error^2;  % Sum squared error

        % Backpropagation to update weights
        % Error derivatives for each layer, adjusted by their activation functions' derivatives
        delta3 = error * sigmoid_prime(z3);
        delta2 = (delta3 * W3(:, 1:end-1)) .* sigmoid_prime(z2);
        delta1 = (delta2 * W2(:, 1:end-1)) .* sigmoid_prime(z1);

        % Update weights for each layer
        W3 = W3 - eta * delta3' * a2;
        W2 = W2 - eta * delta2' * a1;
        W1 = W1 - eta * delta1' * X(i,:);

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
disp('Final weights for each layer:');
disp('W1:');
disp(W1);
disp('W2:');
disp(W2);
disp('W3:');
disp(W3);
