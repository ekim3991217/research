% Eugene Kim 
% GaTech ME6105 Fall 2024

% HW5_1_optimization_comparison
function [] = optimize_methods_comparison()
    clear all;
    error = 1e-6; % Tolerance for convergence
    x0 = [1; 1]; % Initial decision variable (column vector)
    max_iterations = 2000; % Maximum number of iterations

    % Steepest Descent Method
    [X_sd, f_sd, iter_sd] = steepest_descent(x0, error, max_iterations);

    % Conjugate Gradient Method
    [X_cg, f_cg, iter_cg] = conjugate_gradient(x0, error, max_iterations);

    %-- Plotting results --%
    figure;

    % Plot both optimization paths on the cost function contour
    plot_optimization(X_sd, X_cg, 'Steepest Descent', 'Conjugate Gradient');

    % Output a table for conjugate gradient results
    print_iteration_table(X_cg, f_cg, iter_cg);
end

% Plotting function for optimization comparison with cost function contours
function [] = plot_optimization(X_sd, X_cg, title_sd, title_cg)
    % Create grid for contour plot
    xx = 0.5:0.05:2;
    yy = 0.5:0.05:2;
    [X_grid, Y_grid] = meshgrid(xx, yy);
    
    % Calculate cost function values on grid
    Z = 8./(X_grid.^2) + 1.2*X_grid.*Y_grid + 5./Y_grid;
    
    % Steepest Descent Plot
    subplot(1, 2, 1);
    contour(X_grid, Y_grid, Z, 50); hold on;
    plot(X_sd(1,:), X_sd(2,:), 'ro-', 'LineWidth', 1.5, 'MarkerSize', 4);
    title(title_sd);
    xlabel('x_1');
    ylabel('x_2');
    hold off;
    
    % Conjugate Gradient Plot
    subplot(1, 2, 2);
    contour(X_grid, Y_grid, Z, 50); hold on;
    plot(X_cg(1,:), X_cg(2,:), 'bo-', 'LineWidth', 1.5, 'MarkerSize', 4);
    title(title_cg);
    xlabel('x_1');
    ylabel('x_2');
    hold off;
end

% Steepest Descent Method function
function [X, f_vals, k] = steepest_descent(x0, tol, max_iter)
    X = x0; % Initial point (as a column vector)
    f_vals = myfunc(X(1), X(2)); % Store initial function value
    k = 0; % Iteration counter

    while k < max_iter
        k = k + 1;
        [f, g] = myfunc(X(1,end), X(2,end)); % Function and gradient at current X
        c = norm(g); % Norm of the gradient (convergence criterion)
        if c < tol
            break;
        end
        d = -g; % Steepest descent direction
        alpha = mygolden(X(:,end), d); % Step size
        X_new = X(:,end) + alpha.*d; % Update X
        X = [X, X_new]; % Store history as new column
        f_vals = [f_vals, f]; % Store function value
    end
end

% Conjugate Gradient Method function with iteration outputs
function [X, f_vals, k] = conjugate_gradient(x0, tol, max_iter)
    X = x0; % Initial point (as a column vector)
    f_vals = myfunc(X(1), X(2)); % Store initial function value
    k = 0; % Iteration counter
    
    [f, g] = myfunc(X(1), X(2));
    d = -g; % Initial direction
    
    fprintf('Iteration | x1        | x2        | f(x)\n');
    fprintf('------------------------------------------\n');
    
    while k < max_iter
        k = k + 1;
        [f, g] = myfunc(X(1,end), X(2,end)); % Function and gradient at current X
        c = norm(g); % Norm of the gradient (convergence criterion)
        if c < tol
            break;
        end
        
        alpha = mygolden(X(:,end), d); % Step size
        X_new = X(:,end) + alpha.*d; % Update X
        X = [X, X_new]; % Store history as new column
        f_vals = [f_vals, f]; % Store function value
        
        % Print iteration details
        fprintf('%9d | %10.6f | %10.6f | %10.6f\n', k, X(1,end), X(2,end), f);
        
        [f_new, g_new] = myfunc(X(1,end), X(2,end)); % Compute new gradient
        beta = (g_new' * g_new) / (g' * g); % Conjugate gradient update
        d = -g_new + beta * d; % New search direction
        g = g_new; % Update gradient
    end
end

% Golden section search to find optimal step size
function [a] = mygolden(x, d)
    golden = 1.618; % golden section ratio
    ga = 0.382;
    gb = 0.618;
    a_l = 0.0;
    delta = 0.05;
    error = 0.0001;

    % Initial bracketing
    f1 = onedimension(a_l, x, d);
    a_u = delta;
    f2 = onedimension(a_u, x, d);

    while (f1 > f2) % minimum has not been surpassed yet
        f1 = f2;
        a_l = a_u;
        a_u = a_l + delta*golden;
        f2 = onedimension(a_u, x, d);
    end

    % Reducing the interval of uncertainty
    a_l = a_l / golden;
    in = a_u - a_l;
    a_a = a_l + ga*in;
    a_b = a_l + gb*in;

    while (in > error)
        fa = onedimension(a_a, x, d);
        fb = onedimension(a_b, x, d);
        if (fa < fb)
            a_u = a_b;
            a_b = a_a;
            a_a = a_l + ga*(a_u - a_l);
        elseif (fa > fb)
            a_l = a_a;
            a_a = a_b;
            a_b = a_l + gb*(a_u - a_l);
        else
            a_l = a_a;
            a_u = a_b;
            a_a = a_l + ga*(a_u - a_l);
            a_b = a_l + gb*(a_u - a_l);
        end
        in = a_u - a_l;
    end
    a = (a_l + a_u)/2;
end

% Evaluate the function along the search direction
function f = onedimension(a, x, d)
    x1_new = x(1) + a*d(1);
    x2_new = x(2) + a*d(2);
    f = 8./x1_new.^2 + 1.2*x1_new.*x2_new + 5./x2_new; % objective function
end

% Function to calculate the objective function and its gradient
function [f, g] = myfunc(x1, x2)
    f = 8./x1.^2 + 1.2*x1.*x2 + 5./x2; % objective function

    % Gradient components
    g1 = -16./x1.^3 + 1.2*x2;
    g2 = 1.2*x1 - 5./x2.^2;
    g = [g1; g2]; % gradient vector
end

% Print a table of iteration results for the conjugate gradient method
function [] = print_iteration_table(X_cg, f_cg, iter_cg)
    fprintf('\n***** Conjugate Gradient Results *****\n');
    fprintf('Iteration | x1        | x2        | f(x)\n');
    fprintf('------------------------------------------\n');
    for i = 1:iter_cg
        fprintf('%9d | %10.6f | %10.6f | %10.6f\n', i, X_cg(1,i), X_cg(2,i), f_cg(i));
    end
    fprintf('------------------------------------------\n');
    fprintf('Converged in %d iterations\n', iter_cg);
    fprintf('Final solution: x1 = %f, x2 = %f\n', X_cg(1,end), X_cg(2,end));
    fprintf('Final function value: f(x) = %f\n', f_cg(end));
end
