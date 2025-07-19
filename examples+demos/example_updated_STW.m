%% Updated STW Models Example - Vector and Meshgrid Inputs
% This script demonstrates the updated STW model functions that accept
% either vector inputs (x, t) or meshgrid inputs (X, T)

clear; clc; close all;

fprintf('Updated STW Models Example\n');
fprintf('==========================\n\n');

%% 1. Vector Input Example
fprintf('1. Vector Input Example\n');
fprintf('-----------------------\n');

% Define spatial and temporal vectors
x = linspace(0, 8, 40);      % nx = 40 spatial points
t = linspace(0, 4, 25);      % nt = 25 temporal points

fprintf('Input vectors:\n');
fprintf('  x: %d points from %.1f to %.1f\n', length(x), min(x), max(x));
fprintf('  t: %d points from %.1f to %.1f\n', length(t), min(t), max(t));

% Simple STW Model with vector inputs
params_simple = [1.5, 2, 3, pi/6, 0.2];
Y_simple = simple_STW_model(params_simple, x, t);

fprintf('\nSimple STW Model (vector inputs):\n');
fprintf('  Output size: [%d, %d] (nt x nx)\n', size(Y_simple, 1), size(Y_simple, 2));
fprintf('  Output range: [%.3f, %.3f]\n', min(Y_simple(:)), max(Y_simple(:)));

% Frequency Dispersion STW Model with vector inputs
params_freqdisp = [1.2, 1.5, 0.3, 2.5, 0.2, 0.4, 0, 0.1];
Y_freqdisp = freqdisp_STW_model(params_freqdisp, x, t);

fprintf('\nFreqdisp STW Model (vector inputs):\n');
fprintf('  Output size: [%d, %d] (nt x nx)\n', size(Y_freqdisp, 1), size(Y_freqdisp, 2));
fprintf('  Output range: [%.3f, %.3f]\n\n', min(Y_freqdisp(:)), max(Y_freqdisp(:)));

%% 2. Meshgrid Input Example
fprintf('2. Meshgrid Input Example\n');
fprintf('-------------------------\n');

% Create meshgrids manually
[X_mesh, T_mesh] = meshgrid(x, t);

fprintf('Input meshgrids:\n');
fprintf('  X, T: [%d, %d] matrices\n', size(X_mesh, 1), size(X_mesh, 2));

% Use the same parameters but with meshgrid inputs
Y_simple_mesh = simple_STW_model(params_simple, X_mesh, T_mesh);
Y_freqdisp_mesh = freqdisp_STW_model(params_freqdisp, X_mesh, T_mesh);

fprintf('\nSimple STW Model (meshgrid inputs):\n');
fprintf('  Output size: [%d, %d]\n', size(Y_simple_mesh, 1), size(Y_simple_mesh, 2));

fprintf('\nFreqdisp STW Model (meshgrid inputs):\n');
fprintf('  Output size: [%d, %d]\n', size(Y_freqdisp_mesh, 1), size(Y_freqdisp_mesh, 2));

% Verify outputs are identical
fprintf('\nVerification:\n');
fprintf('  Simple models identical: %s\n', mat2str(isequal(Y_simple, Y_simple_mesh)));
fprintf('  Freqdisp models identical: %s\n\n', mat2str(isequal(Y_freqdisp, Y_freqdisp_mesh)));

%% 3. Visualization
fprintf('3. Creating visualizations...\n');

figure('Name', 'Updated STW Models - Matrix Outputs', 'Position', [12 66 1488 345]);

% Simple model visualizations
subplot(2, 4, 1);
imagesc(x, t, Y_simple);
xlabel('X'); ylabel('T'); title('Simple STW - Image');
colorbar; axis xy;

subplot(2, 4, 2);
contour(x, t, Y_simple, 15);
xlabel('X'); ylabel('T'); title('Simple STW - Contour');
colorbar;

subplot(2, 4, 3);
surf(X_mesh, T_mesh, Y_simple);
xlabel('X'); ylabel('T'); zlabel('Y');
title('Simple STW - Surface');
shading interp; colorbar;

subplot(2, 4, 4);
plot(x, Y_simple(round(end/2), :), 'b-', 'LineWidth', 2);
xlabel('X'); ylabel('Y'); title('Simple STW - X slice (t=const)');
grid on;

% Freqdisp model visualizations
subplot(2, 4, 5);
imagesc(x, t, Y_freqdisp);
xlabel('X'); ylabel('T'); title('Freqdisp STW - Image');
colorbar; axis xy;

subplot(2, 4, 6);
contour(x, t, Y_freqdisp, 15);
xlabel('X'); ylabel('T'); title('Freqdisp STW - Contour');
colorbar;

subplot(2, 4, 7);
surf(X_mesh, T_mesh, Y_freqdisp);
xlabel('X'); ylabel('T'); zlabel('Y');
title('Freqdisp STW - Surface');
shading interp; colorbar;

subplot(2, 4, 8);
% plot(t, Y_freqdisp(:, round(end/2)), 'r-', 'LineWidth', 2);
% xlabel('T'); ylabel('Y'); title('Freqdisp STW - T slice (x=const)');
plot(x, Y_freqdisp(round(end/2), :), 'r-', 'LineWidth', 2);
xlabel('T'); ylabel('Y'); title('Freqdisp STW - X slice (t=const)');
grid on;

%% 4. Different Grid Sizes Example
fprintf('\n4. Different Grid Sizes Example\n');
fprintf('-------------------------------\n');

% High resolution example
x_hr = linspace(0, 6, 100);
t_hr = linspace(0, 3, 60);

Y_hr = simple_STW_model(params_simple, x_hr, t_hr);

fprintf('High resolution:\n');
fprintf('  Input: x(%d), t(%d)\n', length(x_hr), length(t_hr));
fprintf('  Output: [%d, %d]\n', size(Y_hr, 1), size(Y_hr, 2));

% Low resolution example
x_lr = linspace(0, 6, 10);
t_lr = linspace(0, 3, 8);

Y_lr = simple_STW_model(params_simple, x_lr, t_lr);

fprintf('Low resolution:\n');
fprintf('  Input: x(%d), t(%d)\n', length(x_lr), length(t_lr));
fprintf('  Output: [%d, %d]\n', size(Y_lr, 1), size(Y_lr, 2));

% Compare resolutions
figure('Name', 'Resolution Comparison', 'Position', [168 379 1310 181]);

subplot(1, 3, 1);
imagesc(x_hr, t_hr, Y_hr);
xlabel('X'); ylabel('T'); title('High Resolution');
colorbar; axis xy;

subplot(1, 3, 2);
imagesc(x_lr, t_lr, Y_lr);
xlabel('X'); ylabel('T'); title('Low Resolution');
colorbar; axis xy;

subplot(1, 3, 3);
% Show difference in a line plot
plot(x_hr, Y_hr(end/2, :), 'b-', 'LineWidth', 2, 'DisplayName', 'High res');
hold on;
plot(x_lr, Y_lr(end/2, :), 'ro-', 'LineWidth', 2, 'MarkerSize', 6, 'DisplayName', 'Low res');
xlabel('X'); ylabel('Y'); title('Resolution Comparison');
legend; grid on;

%% 5. Usage Tips and Examples
fprintf('\n5. Usage Tips\n');
fprintf('-------------\n');
fprintf('Vector input format: Y = model_function(params, x_vector, t_vector)\n');
fprintf('Meshgrid input format: Y = model_function(params, X_meshgrid, T_meshgrid)\n');
fprintf('Output Y is always a matrix of size [nt, nx]\n');
fprintf('  - Rows correspond to different time values\n');
fprintf('  - Columns correspond to different spatial values\n\n');

fprintf('Matrix indexing:\n');
fprintf('  Y(i, j) = output at t(i), x(j)\n');
fprintf('  Y(i, :) = spatial profile at time t(i)\n');
fprintf('  Y(:, j) = temporal evolution at position x(j)\n\n');

%% 6. Animation Example
fprintf('6. Creating animation...\n');

% Create animation of the wave evolution
figure('Name', 'STW Wave Animation', 'Position', [300, 300, 800, 600]);

% Use high resolution data
x_anim = linspace(0, 8, 200);
t_anim = linspace(0, 4, 150);
% Y_anim = simple_STW_model(params_simple, x_anim, t_anim);
Y_anim = freqdisp_STW_model(params_freqdisp, x_anim, t_anim);

% Y_hr = simple_STW_model(params_simple, x_hr, t_hr);
% Y_freqdisp = freqdisp_STW_model(params_freqdisp, x, t);
% % High resolution example
% x_hr = linspace(0, 6, 100);
% t_hr = linspace(0, 3, 60);

drawnow;shg;
for i = 1:5:size(Y_anim, 1)  % Every 5th time step
    subplot(2, 1, 1);
    plot(x_anim, Y_anim(i, :), 'b-', 'LineWidth', 2);
    xlabel('X'); ylabel('Y'); 
    title(sprintf('Wave Profile at t = %.2f', t_anim(i)));
    ylim([min(Y_anim(:)), max(Y_anim(:))]);
    grid on;
    
    subplot(2, 1, 2);
    imagesc(x_anim, t_anim(1:i), Y_anim(1:i, :));
    xlabel('X'); ylabel('T'); title('Wave Evolution');
    colorbar; axis xy; drawnow;
    
    pause(0.1);
end

fprintf('Animation complete!\n\n');
fprintf('=== Example Complete ===\n');
fprintf('The STW models now return [nt, nx] matrices for easy visualization!\n');
