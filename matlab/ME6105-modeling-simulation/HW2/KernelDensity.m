function [v, f_hat] = KernelDensity(x, sigma, M)
    % Inputs:
    %    x - Input data vector (Gaussian samples).
    %    sigma - Smoothing parameter for the Gaussian kernel.
    %    M - Number of grid points for density estimation.
    %
    % Outputs:
    %    v - Grid points where the density is estimated.
    %    f_hat - Estimated density values.

    % Scale the sample data to [0, 1]
    x_scaled = (x - min(x)) / (max(x) - min(x));

    % Generate the uniform grid array of M points where density will be estimated
    v = linspace(0, 1, M);

    % Initialize density estimate array
    f_hat = zeros(size(v));

    % Compute the density using Gaussian kernel
    for i = 1:M
        f_hat(i) = sum(exp(-((x_scaled - v(i)).^2) / (2 * sigma^2)));
    end

    % Normalize the kernel density estimate using the trapezoidal rule
    f_hat = f_hat / trapz(v, f_hat);
end
