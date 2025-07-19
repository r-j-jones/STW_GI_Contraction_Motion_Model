%% A_dispersion_function Example Script
% This script demonstrates:
% 1. Different types of amplitude dispersion functions
% 2. How to apply dispersion to STW model outputs
% 3. Visualization of dispersion effects on spatiotemporal patterns

clear; clc; close all;

fprintf('=== A_dispersion_function Example Script ===\n\n');

%% 1. Basic Dispersion Functions Demonstration
fprintf('1. Demonstrating Basic Dispersion Functions\n');
fprintf('-------------------------------------------\n');

% Create test variable for univariate dispersion
mu_test = linspace(0, 5, 100);

% Parameters for dispersion functions
alpha = 0.5;
beta = 0.3;
gamma = 1.5;
mu0 = 2.5;
sigma = 1.0;

% Calculate different dispersion types
D_linear = A_dispersion_function('linear', mu_test, alpha);
D_exponential = A_dispersion_function('exponential', mu_test, alpha);
D_inverse_power = A_dispersion_function('inverse_power_law', mu_test, alpha);
D_quadratic = A_dispersion_function('quadratic', mu_test, alpha);
D_gaussian = A_dispersion_function('gaussian', mu_test, alpha);
D_gaussian_bump = A_dispersion_function('gaussian_bump', mu_test, alpha, beta, gamma, mu0, sigma);

fprintf('Generated dispersion functions for mu from %.1f to %.1f\n', min(mu_test), max(mu_test));

% Visualize univariate dispersion functions
figure('Name', 'Univariate Dispersion Functions', 'Position', [100, 100, 1200, 800]);

subplot(2, 3, 1);
plot(mu_test, D_linear, 'b-', 'LineWidth', 2);
title('Linear Dispersion'); xlabel('μ'); ylabel('D(μ)');
grid on; ylim([0, 1.1]);

subplot(2, 3, 2);
plot(mu_test, D_exponential, 'r-', 'LineWidth', 2);
title('Exponential Dispersion'); xlabel('μ'); ylabel('D(μ)');
grid on; ylim([0, 1.1]);

subplot(2, 3, 3);
plot(mu_test, D_inverse_power, 'g-', 'LineWidth', 2);
title('Inverse Power Law'); xlabel('μ'); ylabel('D(μ)');
grid on; ylim([0, 1.1]);

subplot(2, 3, 4);
plot(mu_test, D_quadratic, 'm-', 'LineWidth', 2);
title('Quadratic Dispersion'); xlabel('μ'); ylabel('D(μ)');
grid on; ylim([0, 1.1]);

subplot(2, 3, 5);
plot(mu_test, D_gaussian, 'c-', 'LineWidth', 2);
title('Gaussian Dispersion'); xlabel('μ'); ylabel('D(μ)');
grid on; ylim([0, 1.1]);

subplot(2, 3, 6);
plot(mu_test, D_gaussian_bump, 'k-', 'LineWidth', 2);
title('Gaussian Bump'); xlabel('μ'); ylabel('D(μ)');
grid on; ylim([0, 1.1]);

fprintf('Univariate dispersion functions plotted.\n\n');

%% 2. STW Model Setup
fprintf('2. Setting up STW Models\n');
fprintf('------------------------\n');

% Define spatial and temporal vectors
x = linspace(0, 8, 100);
t = linspace(0, 4, 60);

fprintf('Spatial domain: x from %.1f to %.1f (%d points)\n', min(x), max(x), length(x));
fprintf('Temporal domain: t from %.1f to %.1f (%d points)\n', min(t), max(t), length(t));

% STW model parameters
params_simple = [2.0, 1.5, 2.0, pi/4, 0.1];  % [A, k, b, o, c]
params_freqdisp = [1.8, 1.2, 0.3, 2.2, 0.2, 0.4, pi/6, 0.0];  % [A, k0, k1, b0, b1, mu, o, c]

fprintf('\nSimple STW parameters: A=%.1f, k=%.1f, b=%.1f, o=%.2f, c=%.1f\n', params_simple);
fprintf('Freqdisp STW parameters: A=%.1f, k0=%.1f, k1=%.1f, b0=%.1f, b1=%.1f, mu=%.1f, o=%.2f, c=%.1f\n', params_freqdisp);

% Generate STW model outputs
Y_simple = simple_STW_model(params_simple, x, t);
Y_freqdisp = freqdisp_STW_model(params_freqdisp, x, t);

fprintf('\nSTW outputs generated:\n');
fprintf('  Simple: [%d x %d] matrix, range [%.3f, %.3f]\n', size(Y_simple, 1), size(Y_simple, 2), min(Y_simple(:)), max(Y_simple(:)));
fprintf('  Freqdisp: [%d x %d] matrix, range [%.3f, %.3f]\n\n', size(Y_freqdisp, 1), size(Y_freqdisp, 2), min(Y_freqdisp(:)), max(Y_freqdisp(:)));

%% 3. Apply Spatial Dispersion (x-dependent)
fprintf('3. Applying Spatial Dispersion\n');
fprintf('------------------------------\n');

% Parameters for spatial dispersion
alpha_x = 0.3;

% Calculate spatial dispersion for each x position
D_x_linear = A_dispersion_function('linear', x, alpha_x);
D_x_exponential = A_dispersion_function('exponential', x, alpha_x);
D_x_inverse_power = A_dispersion_function('inverse_power_law', x, alpha_x);

% Add Gaussian bump dispersion (localized at x = 4.0)
x_center = 4.0;  % Center of the bump
sigma_bump = 1.5;  % Width of the bump
D_x_gaussian_bump = A_dispersion_function('gaussian_bump', x, alpha_x, [], [], x_center, sigma_bump);

fprintf('Spatial dispersion calculated for %d x positions\n', length(x));
fprintf('Gaussian bump centered at x = %.1f with sigma = %.1f\n', x_center, sigma_bump);

% Apply spatial dispersion to STW outputs
% Dispersion is applied as: Y_dispersed = Y .* D_x (broadcast across time)
Y_simple_linear_x = Y_simple .* D_x_linear;
Y_simple_exp_x = Y_simple .* D_x_exponential;
Y_simple_power_x = Y_simple .* D_x_inverse_power;
Y_simple_bump_x = Y_simple .* D_x_gaussian_bump;

Y_freqdisp_linear_x = Y_freqdisp .* D_x_linear;
Y_freqdisp_exp_x = Y_freqdisp .* D_x_exponential;
Y_freqdisp_power_x = Y_freqdisp .* D_x_inverse_power;
Y_freqdisp_bump_x = Y_freqdisp .* D_x_gaussian_bump;
Y_freqdisp_exp_x = Y_freqdisp .* D_x_exponential;
Y_freqdisp_power_x = Y_freqdisp .* D_x_inverse_power;

fprintf('Spatial dispersion applied to STW outputs\n');

%% 4. Apply Temporal Dispersion (t-dependent)
fprintf('\n4. Applying Temporal Dispersion\n');
fprintf('-------------------------------\n');

% Parameters for temporal dispersion
alpha_t = 0.4;

% Calculate temporal dispersion for each t position
D_t_linear = A_dispersion_function('linear', t, alpha_t);
D_t_exponential = A_dispersion_function('exponential', t, alpha_t);
D_t_inverse_power = A_dispersion_function('inverse_power_law', t, alpha_t);

fprintf('Temporal dispersion calculated for %d t positions\n', length(t));

% Apply temporal dispersion to STW outputs
% Dispersion is applied as: Y_dispersed = Y .* D_t' (broadcast across space)
Y_simple_linear_t = Y_simple .* D_t_linear';
Y_simple_exp_t = Y_simple .* D_t_exponential';
Y_simple_power_t = Y_simple .* D_t_inverse_power';

Y_freqdisp_linear_t = Y_freqdisp .* D_t_linear';
Y_freqdisp_exp_t = Y_freqdisp .* D_t_exponential';
Y_freqdisp_power_t = Y_freqdisp .* D_t_inverse_power';

fprintf('Temporal dispersion applied to STW outputs\n');

%% 5. Apply Spatiotemporal Dispersion
fprintf('\n5. Applying Spatiotemporal Dispersion\n');
fprintf('------------------------------------\n');

% Create spatiotemporal input matrix for bivariate dispersion
[X_mesh, T_mesh] = meshgrid(x, t);
XT_matrix = [X_mesh(:), T_mesh(:)];

% Parameters for spatiotemporal dispersion
alpha_st = 0.2;
beta_st = 0.1;
sigma_st = 3.0;

% Calculate spatiotemporal dispersion
D_bivariate = A_dispersion_function('bivariate', XT_matrix, alpha_st, beta_st);
D_gaussian_envelope = A_dispersion_function('gaussian_envelope', XT_matrix, alpha_st, beta_st, gamma, mu0, sigma_st);

% Reshape dispersion back to matrix form
D_bivariate_matrix = reshape(D_bivariate, size(X_mesh));
D_gaussian_envelope_matrix = reshape(D_gaussian_envelope, size(X_mesh));

fprintf('Spatiotemporal dispersion calculated\n');

% Apply spatiotemporal dispersion
Y_simple_bivariate = Y_simple .* D_bivariate_matrix;
Y_simple_gaussian_env = Y_simple .* D_gaussian_envelope_matrix;

Y_freqdisp_bivariate = Y_freqdisp .* D_bivariate_matrix;
Y_freqdisp_gaussian_env = Y_freqdisp .* D_gaussian_envelope_matrix;

fprintf('Spatiotemporal dispersion applied to STW outputs\n');

%% 6. Visualization - Dispersion Patterns
fprintf('\n6. Creating Visualizations\n');
fprintf('-------------------------\n');

% Plot spatial dispersion patterns
figure('Name', 'Spatial Dispersion Patterns', 'Position', [150, 150, 1400, 400]);

subplot(1, 4, 1);
plot(x, D_x_linear, 'b-', 'LineWidth', 2);
title('Linear Spatial Dispersion'); xlabel('x'); ylabel('D(x)');
grid on; ylim([0, 1.1]);

subplot(1, 4, 2);
plot(x, D_x_exponential, 'r-', 'LineWidth', 2);
title('Exponential Spatial Dispersion'); xlabel('x'); ylabel('D(x)');
grid on; ylim([0, 1.1]);

subplot(1, 4, 3);
plot(x, D_x_inverse_power, 'g-', 'LineWidth', 2);
title('Inverse Power Law Spatial Dispersion'); xlabel('x'); ylabel('D(x)');
grid on; ylim([0, 1.1]);

subplot(1, 4, 4);
plot(x, D_x_gaussian_bump, 'm-', 'LineWidth', 2);
title('Gaussian Bump Spatial Dispersion'); xlabel('x'); ylabel('D(x)');
grid on; ylim([0, 1.1]);

% Plot temporal dispersion patterns
figure('Name', 'Temporal Dispersion Patterns', 'Position', [200, 200, 1200, 400]);

subplot(1, 3, 1);
plot(t, D_t_linear, 'b-', 'LineWidth', 2);
title('Linear Temporal Dispersion'); xlabel('t'); ylabel('D(t)');
grid on; ylim([0, 1.1]);

subplot(1, 3, 2);
plot(t, D_t_exponential, 'r-', 'LineWidth', 2);
title('Exponential Temporal Dispersion'); xlabel('t'); ylabel('D(t)');
grid on; ylim([0, 1.1]);

subplot(1, 3, 3);
plot(t, D_t_inverse_power, 'g-', 'LineWidth', 2);
title('Inverse Power Law Temporal Dispersion'); xlabel('t'); ylabel('D(t)');
grid on; ylim([0, 1.1]);

% Plot spatiotemporal dispersion patterns
figure('Name', 'Spatiotemporal Dispersion Patterns', 'Position', [250, 250, 1000, 500]);

subplot(1, 2, 1);
imagesc(x, t, D_bivariate_matrix);
xlabel('x'); ylabel('t'); title('Bivariate Dispersion');
colorbar; axis xy;

subplot(1, 2, 2);
imagesc(x, t, D_gaussian_envelope_matrix);
xlabel('x'); ylabel('t'); title('Gaussian Envelope Dispersion');
colorbar; axis xy;

%% 7. Visualization - Effects on Simple STW Model
fprintf('Creating Simple STW dispersion effects visualization...\n');

figure('Name', 'Simple STW Model - Dispersion Effects', 'Position', [300, 300, 1600, 1000]);

% Original
subplot(3, 5, 1);
imagesc(x, t, Y_simple);
title('Original Simple STW'); xlabel('x'); ylabel('t');
colorbar; axis xy;

% Spatial dispersion effects
subplot(3, 5, 2);
imagesc(x, t, Y_simple_linear_x);
title('Linear Spatial Dispersion'); xlabel('x'); ylabel('t');
colorbar; axis xy;

subplot(3, 5, 3);
imagesc(x, t, Y_simple_exp_x);
title('Exponential Spatial Dispersion'); xlabel('x'); ylabel('t');
colorbar; axis xy;

subplot(3, 5, 4);
imagesc(x, t, Y_simple_power_x);
title('Power Law Spatial Dispersion'); xlabel('x'); ylabel('t');
colorbar; axis xy;

subplot(3, 5, 5);
imagesc(x, t, Y_simple_bump_x);
title('Gaussian Bump Spatial Dispersion'); xlabel('x'); ylabel('t');
colorbar; axis xy;

% Temporal dispersion effects
subplot(3, 5, 7);
imagesc(x, t, Y_simple_linear_t);
title('Linear Temporal Dispersion'); xlabel('x'); ylabel('t');
colorbar; axis xy;

subplot(3, 5, 8);
imagesc(x, t, Y_simple_exp_t);
title('Exponential Temporal Dispersion'); xlabel('x'); ylabel('t');
colorbar; axis xy;

subplot(3, 5, 9);
imagesc(x, t, Y_simple_power_t);
title('Power Law Temporal Dispersion'); xlabel('x'); ylabel('t');
colorbar; axis xy;

% Spatiotemporal dispersion effects
subplot(3, 5, [11, 12]);
imagesc(x, t, Y_simple_bivariate);
title('Bivariate Dispersion'); xlabel('x'); ylabel('t');
colorbar; axis xy;

subplot(3, 5, [13, 14]);
imagesc(x, t, Y_simple_gaussian_env);
title('Gaussian Envelope Dispersion'); xlabel('x'); ylabel('t');
colorbar; axis xy;

% Cross-sections comparison
subplot(3, 5, 6);
mid_t = round(length(t)/2);
plot(x, Y_simple(mid_t, :), 'k-', 'LineWidth', 2, 'DisplayName', 'Original');
hold on;
plot(x, Y_simple_linear_x(mid_t, :), 'b-', 'LineWidth', 1.5, 'DisplayName', 'Linear x');
plot(x, Y_simple_exp_x(mid_t, :), 'r-', 'LineWidth', 1.5, 'DisplayName', 'Exp x');
plot(x, Y_simple_power_x(mid_t, :), 'g-', 'LineWidth', 1.5, 'DisplayName', 'Power x');
plot(x, Y_simple_bump_x(mid_t, :), 'm-', 'LineWidth', 1.5, 'DisplayName', 'Bump x');
xlabel('x'); ylabel('Amplitude'); title('Spatial Profiles (t=const)');
legend('Location', 'best'); grid on;

subplot(3, 5, 10);
mid_x = round(length(x)/2);
plot(t, Y_simple(:, mid_x), 'k-', 'LineWidth', 2, 'DisplayName', 'Original');
hold on;
plot(t, Y_simple_linear_t(:, mid_x), 'b-', 'LineWidth', 1.5, 'DisplayName', 'Linear t');
plot(t, Y_simple_exp_t(:, mid_x), 'r-', 'LineWidth', 1.5, 'DisplayName', 'Exp t');
plot(t, Y_simple_power_t(:, mid_x), 'g-', 'LineWidth', 1.5, 'DisplayName', 'Power t');
xlabel('t'); ylabel('Amplitude'); title('Temporal Profiles (x=const)');
legend('Location', 'best'); grid on;

subplot(3, 5, 15);
% Show spatial profile for Gaussian bump at the bump center
bump_x_idx = find(x >= x_center, 1);  % Find index closest to bump center
plot(t, Y_simple(:, bump_x_idx), 'k-', 'LineWidth', 2, 'DisplayName', 'Original');
hold on;
plot(t, Y_simple_bump_x(:, bump_x_idx), 'm-', 'LineWidth', 2, 'DisplayName', 'Gaussian Bump');
xlabel('t'); ylabel('Amplitude'); title(sprintf('Temporal at Bump Center (x=%.1f)', x_center));
legend('Location', 'best'); grid on;

%% 8. Visualization - Effects on Freqdisp STW Model
fprintf('Creating Freqdisp STW dispersion effects visualization...\n');

figure('Name', 'Freqdisp STW Model - Dispersion Effects', 'Position', [350, 350, 1600, 1000]);

% Original
subplot(3, 5, 1);
imagesc(x, t, Y_freqdisp);
title('Original Freqdisp STW'); xlabel('x'); ylabel('t');
colorbar; axis xy;

% Spatial dispersion effects
subplot(3, 5, 2);
imagesc(x, t, Y_freqdisp_linear_x);
title('Linear Spatial Dispersion'); xlabel('x'); ylabel('t');
colorbar; axis xy;

subplot(3, 5, 3);
imagesc(x, t, Y_freqdisp_exp_x);
title('Exponential Spatial Dispersion'); xlabel('x'); ylabel('t');
colorbar; axis xy;

subplot(3, 5, 4);
imagesc(x, t, Y_freqdisp_power_x);
title('Power Law Spatial Dispersion'); xlabel('x'); ylabel('t');
colorbar; axis xy;

subplot(3, 5, 5);
imagesc(x, t, Y_freqdisp_bump_x);
title('Gaussian Bump Spatial Dispersion'); xlabel('x'); ylabel('t');
colorbar; axis xy;

% Temporal dispersion effects
subplot(3, 5, 7);
imagesc(x, t, Y_freqdisp_linear_t);
title('Linear Temporal Dispersion'); xlabel('x'); ylabel('t');
colorbar; axis xy;

subplot(3, 5, 8);
imagesc(x, t, Y_freqdisp_exp_t);
title('Exponential Temporal Dispersion'); xlabel('x'); ylabel('t');
colorbar; axis xy;

subplot(3, 5, 9);
imagesc(x, t, Y_freqdisp_power_t);
title('Power Law Temporal Dispersion'); xlabel('x'); ylabel('t');
colorbar; axis xy;

% Spatiotemporal dispersion effects
subplot(3, 5, [11, 12]);
imagesc(x, t, Y_freqdisp_bivariate);
title('Bivariate Dispersion'); xlabel('x'); ylabel('t');
colorbar; axis xy;

subplot(3, 5, [13, 14]);
imagesc(x, t, Y_freqdisp_gaussian_env);
title('Gaussian Envelope Dispersion'); xlabel('x'); ylabel('t');
colorbar; axis xy;

% Cross-sections comparison
subplot(3, 5, 6);
plot(x, Y_freqdisp(mid_t, :), 'k-', 'LineWidth', 2, 'DisplayName', 'Original');
hold on;
plot(x, Y_freqdisp_linear_x(mid_t, :), 'b-', 'LineWidth', 1.5, 'DisplayName', 'Linear x');
plot(x, Y_freqdisp_exp_x(mid_t, :), 'r-', 'LineWidth', 1.5, 'DisplayName', 'Exp x');
plot(x, Y_freqdisp_power_x(mid_t, :), 'g-', 'LineWidth', 1.5, 'DisplayName', 'Power x');
plot(x, Y_freqdisp_bump_x(mid_t, :), 'm-', 'LineWidth', 1.5, 'DisplayName', 'Bump x');
xlabel('x'); ylabel('Amplitude'); title('Spatial Profiles (t=const)');
legend('Location', 'best'); grid on;

subplot(3, 5, 10);
plot(t, Y_freqdisp(:, mid_x), 'k-', 'LineWidth', 2, 'DisplayName', 'Original');
hold on;
plot(t, Y_freqdisp_linear_t(:, mid_x), 'b-', 'LineWidth', 1.5, 'DisplayName', 'Linear t');
plot(t, Y_freqdisp_exp_t(:, mid_x), 'r-', 'LineWidth', 1.5, 'DisplayName', 'Exp t');
plot(t, Y_freqdisp_power_t(:, mid_x), 'g-', 'LineWidth', 1.5, 'DisplayName', 'Power t');
xlabel('t'); ylabel('Amplitude'); title('Temporal Profiles (x=const)');
legend('Location', 'best'); grid on;

subplot(3, 5, 15);
% Show spatial profile for Gaussian bump at the bump center
plot(t, Y_freqdisp(:, bump_x_idx), 'k-', 'LineWidth', 2, 'DisplayName', 'Original');
hold on;
plot(t, Y_freqdisp_bump_x(:, bump_x_idx), 'm-', 'LineWidth', 2, 'DisplayName', 'Gaussian Bump');
xlabel('t'); ylabel('Amplitude'); title(sprintf('Temporal at Bump Center (x=%.1f)', x_center));
legend('Location', 'best'); grid on;

%% 9. Summary Statistics
fprintf('\n9. Summary Statistics\n');
fprintf('--------------------\n');

fprintf('Original amplitudes:\n');
fprintf('  Simple STW: max=%.3f, min=%.3f, range=%.3f\n', max(Y_simple(:)), min(Y_simple(:)), range(Y_simple(:)));
fprintf('  Freqdisp STW: max=%.3f, min=%.3f, range=%.3f\n', max(Y_freqdisp(:)), min(Y_freqdisp(:)), range(Y_freqdisp(:)));

fprintf('\nAfter exponential spatial dispersion:\n');
fprintf('  Simple STW: max=%.3f, min=%.3f, range=%.3f (%.1f%% of original)\n', ...
    max(Y_simple_exp_x(:)), min(Y_simple_exp_x(:)), range(Y_simple_exp_x(:)), ...
    100*range(Y_simple_exp_x(:))/range(Y_simple(:)));
fprintf('  Freqdisp STW: max=%.3f, min=%.3f, range=%.3f (%.1f%% of original)\n', ...
    max(Y_freqdisp_exp_x(:)), min(Y_freqdisp_exp_x(:)), range(Y_freqdisp_exp_x(:)), ...
    100*range(Y_freqdisp_exp_x(:))/range(Y_freqdisp(:)));

fprintf('\nAfter Gaussian bump spatial dispersion:\n');
fprintf('  Simple STW: max=%.3f, min=%.3f, range=%.3f (%.1f%% of original)\n', ...
    max(Y_simple_bump_x(:)), min(Y_simple_bump_x(:)), range(Y_simple_bump_x(:)), ...
    100*range(Y_simple_bump_x(:))/range(Y_simple(:)));
fprintf('  Freqdisp STW: max=%.3f, min=%.3f, range=%.3f (%.1f%% of original)\n', ...
    max(Y_freqdisp_bump_x(:)), min(Y_freqdisp_bump_x(:)), range(Y_freqdisp_bump_x(:)), ...
    100*range(Y_freqdisp_bump_x(:))/range(Y_freqdisp(:)));

fprintf('\nAfter Gaussian envelope dispersion:\n');
fprintf('  Simple STW: max=%.3f, min=%.3f, range=%.3f (%.1f%% of original)\n', ...
    max(Y_simple_gaussian_env(:)), min(Y_simple_gaussian_env(:)), range(Y_simple_gaussian_env(:)), ...
    100*range(Y_simple_gaussian_env(:))/range(Y_simple(:)));
fprintf('  Freqdisp STW: max=%.3f, min=%.3f, range=%.3f (%.1f%% of original)\n', ...
    max(Y_freqdisp_gaussian_env(:)), min(Y_freqdisp_gaussian_env(:)), range(Y_freqdisp_gaussian_env(:)), ...
    100*range(Y_freqdisp_gaussian_env(:))/range(Y_freqdisp(:)));

%% 10. 3D Visualization
fprintf('\n10. Creating 3D Visualizations\n');
fprintf('------------------------------\n');

figure('Name', 'STW Models with Dispersion - 3D View', 'Position', [400, 400, 1200, 800]);

subplot(2, 3, 1);
surf(X_mesh, T_mesh, Y_simple);
title('Original Simple STW'); xlabel('x'); ylabel('t'); zlabel('Amplitude');
shading interp; colorbar;

subplot(2, 3, 2);
surf(X_mesh, T_mesh, Y_simple_exp_x);
title('Simple STW + Exp Spatial Dispersion'); xlabel('x'); ylabel('t'); zlabel('Amplitude');
shading interp; colorbar;

subplot(2, 3, 3);
surf(X_mesh, T_mesh, Y_simple_gaussian_env);
title('Simple STW + Gaussian Envelope'); xlabel('x'); ylabel('t'); zlabel('Amplitude');
shading interp; colorbar;

subplot(2, 3, 4);
surf(X_mesh, T_mesh, Y_freqdisp);
title('Original Freqdisp STW'); xlabel('x'); ylabel('t'); zlabel('Amplitude');
shading interp; colorbar;

subplot(2, 3, 5);
surf(X_mesh, T_mesh, Y_freqdisp_exp_x);
title('Freqdisp STW + Exp Spatial Dispersion'); xlabel('x'); ylabel('t'); zlabel('Amplitude');
shading interp; colorbar;

subplot(2, 3, 6);
surf(X_mesh, T_mesh, Y_freqdisp_gaussian_env);
title('Freqdisp STW + Gaussian Envelope'); xlabel('x'); ylabel('t'); zlabel('Amplitude');
shading interp; colorbar;

fprintf('3D visualizations complete!\n');

fprintf('\n=== Example Script Complete ===\n');
fprintf('Key observations:\n');
fprintf('1. Linear dispersion creates sharp cutoffs\n');
fprintf('2. Exponential dispersion provides smooth decay\n');
fprintf('3. Power law dispersion offers intermediate behavior\n');
fprintf('4. Gaussian bump creates localized enhancement at x=%.1f\n', x_center);
fprintf('5. Spatial dispersion affects wave propagation along x\n');
fprintf('6. Temporal dispersion affects wave evolution over time\n');
fprintf('7. Spatiotemporal dispersion can create localized wave packets\n');
fprintf('8. Different STW models respond differently to the same dispersion\n\n');
