% Eugene Kim 
% GaTech ME6105 Fall 2024

% HW5_4_MonteCarlo
function monte_carlo_optimization()
    % Parameters
    num_simulations = 1e7; % Number of Monte Carlo simulations
    x1_bounds = [0, 999]; % Bounds for x1
    x2_bounds = [0, 999]; % Bounds for x2
    
    % Initialize best solution
    best_f = inf; % Start with infinity as the best objective value
    best_x = [];  % Variable to store the best x1 and x2

    % Monte Carlo Simulation Loop
    for i = 1:num_simulations
        % Randomly generate x1 and x2 within their bounds
        x1 = x1_bounds(1) + (x1_bounds(2) - x1_bounds(1)) * rand;
        x2 = x2_bounds(1) + (x2_bounds(2) - x2_bounds(1)) * rand;
        
        % Check constraints
        if constraint_satisfied(x1, x2)
            % Compute the objective function
            f_value = objective_function(x1, x2);
            
            % Update the best solution if the new one is better
            if f_value < best_f
                best_f = f_value;
                best_x = [x1, x2];
            end
        end
    end

    % Display the best solution from Monte Carlo Simulation
    fprintf('Best solution from Monte Carlo Simulation:\n');
    fprintf('x1 = %.4f, x2 = %.4f, f(x) = %.4f\n', best_x(1), best_x(2), best_f);
    
    % Compare with fmincon
    compare_with_fmincon();
end

% Objective function f(x1, x2) = x1^2 + 2*x2^2 - 4*x1x2 + 8
function f = objective_function(x1, x2)
    f = x1^2 + 2*x2^2 - 4*x1*x2 + 8;
end

% Check constraints
% Constraint 1: -x1^2 + x2 + 900 <= 0
% Constraint 2: x1*x2 - 1000 <= 0
function satisfied = constraint_satisfied(x1, x2)
    constraint1 = (-x1^2 + x2 + 900 <= 0);
    constraint2 = (x1*x2 - 1000 <= 0);
    
    % Both constraints must be satisfied
    satisfied = constraint1 && constraint2;
end

% Comparison using MATLAB's fmincon function
function compare_with_fmincon()
    % Objective function handle
    fun = @(x) x(1)^2 + 2*x(2)^2 - 4*x(1)*x(2) + 8;
    
    % Initial guess
    x0 = [1, 1];
    
    % Constraints
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    
    % Bounds
    lb = [0, 0]; % Lower bounds for x1 and x2
    ub = [999, 999]; % Upper bounds for x1 and x2
    
    % Non-linear constraints
    nonlcon = @nl_constraints;
    
    % Call fmincon
    options = optimoptions('fmincon','Algorithm','interior-point','Display','iter');
    [x_opt, fval] = fmincon(fun, x0, A, b, Aeq, beq, lb, ub, nonlcon, options);
    
    % Display the solution from fmincon
    fprintf('\nBest solution from fmincon:\n');
    fprintf('x1 = %.4f, x2 = %.4f, f(x) = %.4f\n', x_opt(1), x_opt(2), fval);
end

% Non-linear constraint function for fmincon
function [c, ceq] = nl_constraints(x)
    % Constraint 1: -x1^2 + x2 + 900 <= 0
    % Constraint 2: x1*x2 - 1000 <= 0
    c = [-x(1)^2 + x(2) + 900; x(1)*x(2) - 1000];
    ceq = [];
end

