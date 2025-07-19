%% STW Models Example Script
% This script demonstrates basic usage of the STW models with example data

clear; clc; close all;

fprintf('STW Models Example\n');
fprintf('==================\n\n');

%% 1. Create example input data (Nx2 matrix)
fprintf('Creating example data...\n');

% Method 1: Create a regular grid
x_vals = linspace(0, 8, 40);
t_vals = linspace(0, 4, 25);
[X_mesh, T_mesh] = meshgrid(x_vals, t_vals);

% Convert to Nx2 matrix format required by STW models
X = [X_mesh(:), T_mesh(:)];

fprintf('Data created: %d points\n', size(X, 1));
fprintf('X range: [%.1f, %.1f]\n', min(X(:,1)), max(X(:,1)));
fprintf('T range: [%.1f, %.1f]\n\n', min(X(:,2)), max(X(:,2)));

%% 2. Simple STW Model Example
fprintf('Simple STW Model Example\n');
fprintf('------------------------\n');

% Define parameters: [A, k, b, o, c]
% A = amplitude, k = wave number, b = frequency, o = phase, c = offset
params_simple = [1.5, 2, 3, pi/6, 0.2];

fprintf('Parameters: A=%.1f, k=%.1f, b=%.1f, o=%.2f, c=%.1f\n', params_simple);

% Calculate model output
Y_simple = simple_STW_model(params_simple, X);

fprintf('Model equation: Y = A * sin(k*x + b*t + o) + c\n');
fprintf('Output range: [%.3f, %.3f]\n\n', min(Y_simple), max(Y_simple));

%% 3. Frequency Dispersion STW Model Example
fprintf('Frequency Dispersion STW Model Example\n');
fprintf('--------------------------------------\n');

% Define parameters: [A, k0, k1, b0, b1, mu, o, c]
params_freqdisp = [1.2, 1.5, 0.3, 2.5, 0.2, 0.4, 0, 0.1];

fprintf('Parameters:\n');
fprintf('  A  = %.1f (amplitude)\n', params_freqdisp(1));
fprintf('  k0 = %.1f (base wave number)\n', params_freqdisp(2));
fprintf('  k1 = %.1f (wave number variation)\n', params_freqdisp(3));
fprintf('  b0 = %.1f (base frequency)\n', params_freqdisp(4));
fprintf('  b1 = %.1f (frequency variation)\n', params_freqdisp(5));
fprintf('  mu = %.1f (coupling term)\n', params_freqdisp(6));
fprintf('  o  = %.1f (phase shift)\n', params_freqdisp(7));
fprintf('  c  = %.1f (offset)\n', params_freqdisp(8));

% Calculate model output (uses reduced model by default)
Y_freqdisp = freqdisp_STW_model(params_freqdisp, X);

fprintf('Model equation: Y = A * sin((k0+k1*x)*x + (b0+b1*t)*t + mu*x*t + o) + c\n');
fprintf('Output range: [%.3f, %.3f]\n\n', min(Y_freqdisp), max(Y_freqdisp));

%% 4. Visualize the results
fprintf('Creating visualizations...\n');

% Reshape outputs for surface plotting
Y_simple_mesh = reshape(Y_simple, size(X_mesh));
Y_freqdisp_mesh = reshape(Y_freqdisp, size(X_mesh));

% Create figure with subplots
figure('Name', 'STW Models Comparison', 'Position', [100, 100, 1200, 800]);

% Plot 1: Input data points
subplot(2, 3, 1);
plot(X(:,1), X(:,2), 'k.', 'MarkerSize', 4);
xlabel('X'); ylabel('T');
title('Input Data Points');
grid on; axis equal;

% Plot 2: Simple model output (2D)
subplot(2, 3, 2);
scatter(X(:,1), X(:,2), 30, Y_simple, 'filled');
xlabel('X'); ylabel('T');
title('Simple STW Model');
colorbar;

% Plot 3: Simple model output (3D surface)
subplot(2, 3, 3);
surf(X_mesh, T_mesh, Y_simple_mesh);
xlabel('X'); ylabel('T'); zlabel('Y');
title('Simple STW (3D)');
shading interp; colorbar;

% Plot 4: Freqdisp model output (2D)
subplot(2, 3, 5);
scatter(X(:,1), X(:,2), 30, Y_freqdisp, 'filled');
xlabel('X'); ylabel('T');
title('Freqdisp STW Model');
colorbar;

% Plot 5: Freqdisp model output (3D surface)
subplot(2, 3, 6);
surf(X_mesh, T_mesh, Y_freqdisp_mesh);
xlabel('X'); ylabel('T'); zlabel('Y');
title('Freqdisp STW (3D)');
shading interp; colorbar;

% Plot 6: Direct comparison
subplot(2, 3, 4);
plot(Y_simple, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Simple');
hold on;
plot(Y_freqdisp, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Freqdisp');
xlabel('Data Point Index');
ylabel('Model Output (Y)');
title('Model Comparison');
legend('Location', 'best');
grid on;

fprintf('Visualization complete!\n\n');

%% 5. Alternative data generation methods
fprintf('Alternative Data Generation Examples\n');
fprintf('===================================\n');

% Method 2: Random sampling
fprintf('Method 2: Random sampling\n');
n_points = 500;
x_random = rand(n_points, 1) * 10;  % Random x values 0-10
t_random = rand(n_points, 1) * 5;   % Random t values 0-5
X_random = [x_random, t_random];

Y_random = simple_STW_model(params_simple, X_random);
fprintf('Random data: %d points, Y range [%.3f, %.3f]\n', ...
        size(X_random, 1), min(Y_random), max(Y_random));

% Method 3: Line/trajectory data
fprintf('Method 3: Trajectory data\n');
t_traj = linspace(0, 3, 100)';
x_traj = 2 * t_traj + sin(t_traj);  % Curved trajectory
X_traj = [x_traj, t_traj];

Y_traj = freqdisp_STW_model(params_freqdisp, X_traj);
fprintf('Trajectory data: %d points, Y range [%.3f, %.3f]\n', ...
        size(X_traj, 1), min(Y_traj), max(Y_traj));

% Visualize alternative data
figure('Name', 'Alternative Data Types', 'Position', [200, 200, 900, 600]);

subplot(2, 3, 1);
scatter(X_random(:,1), X_random(:,2), 20, Y_random, 'filled');
xlabel('X'); ylabel('T'); title('Random Sampling');
colorbar;

subplot(2, 3, 2);
scatter(X_traj(:,1), X_traj(:,2), 30, Y_traj, 'filled');
xlabel('X'); ylabel('T'); title('Trajectory Data');
colorbar;

subplot(2, 3, 3);
plot3(X_traj(:,1), X_traj(:,2), Y_traj, 'r-', 'LineWidth', 2);
xlabel('X'); ylabel('T'); zlabel('Y');
title('3D Trajectory');
grid on;

subplot(2, 3, [4, 5, 6]);
plot(t_traj, Y_traj, 'b-', 'LineWidth', 2);
xlabel('Time (T)'); ylabel('Model Output (Y)');
title('Output Along Trajectory');
grid on;

fprintf('\nExample script completed!\n');
fprintf('Try running: test_STW_models() for more extensive testing\n');
fprintf('Or run: interactive_STW_visualizer() for interactive exploration\n');
