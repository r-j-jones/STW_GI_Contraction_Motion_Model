%% Quick A_dispersion_function Demo
% Focused demonstration of amplitude dispersion effects on STW models

clear; clc; close all;

fprintf('Quick A_dispersion_function Demonstration\n');
fprintf('========================================\n\n');

%% 1. Setup spatial and temporal domains
x = linspace(0, 8, 100);
t = linspace(0, 4, 60);

fprintf('Domain: x[%.1f, %.1f], t[%.1f, %.1f]\n', min(x), max(x), min(t), max(t));
fprintf('Resolution: %d x %d points\n\n', length(x), length(t));

%% 2. Generate STW model outputs
% Simple STW parameters: [A, k, b, o, c]
params_simple = [2.0, 1.5, 2.5, 0, 0];

% Freqdisp STW parameters: [A, k0, k1, b0, b1, mu, o, c]  
params_freqdisp = [1.8, 1.0, 0.4, 2.0, 0.3, 0.5, 0, 0];

% Generate spatiotemporal profiles
Y_simple = simple_STW_model(params_simple, x, t);
Y_freqdisp = freqdisp_STW_model(params_freqdisp, x, t);

fprintf('STW models generated:\n');
fprintf('  Simple: range [%.3f, %.3f]\n', min(Y_simple(:)), max(Y_simple(:)));
fprintf('  Freqdisp: range [%.3f, %.3f]\n\n', min(Y_freqdisp(:)), max(Y_freqdisp(:)));

%% 3. Create amplitude dispersion functions
alpha = 0.4;  % Dispersion parameter

% Linear dispersion: D(x) = max(0, 1 - alpha*x)
D_linear = A_dispersion_function('linear', x, alpha);

% Exponential dispersion: D(x) = exp(-alpha*x)
D_exponential = A_dispersion_function('exponential', x, alpha);

% Inverse power law: D(x) = (1 + alpha*x^2)^(-1/2)
D_inverse_power = A_dispersion_function('inverse_power_law', x, alpha);

fprintf('Dispersion functions created with alpha = %.2f\n\n', alpha);

%% 4. Apply dispersion to STW outputs
% Apply spatial dispersion (varies with x, constant over t)
Y_simple_linear = Y_simple .* D_linear;
Y_simple_exp = Y_simple .* D_exponential;
Y_simple_power = Y_simple .* D_inverse_power;

Y_freqdisp_linear = Y_freqdisp .* D_linear;
Y_freqdisp_exp = Y_freqdisp .* D_exponential;
Y_freqdisp_power = Y_freqdisp .* D_inverse_power;

fprintf('Amplitude dispersion applied to STW outputs\n\n');

%% 5. Visualization
fprintf('Creating visualizations...\n');

% Figure 1: Dispersion functions
figure('Name', 'Amplitude Dispersion Functions', 'Position', [100, 100, 1200, 400]);

subplot(1, 3, 1);
plot(x, D_linear, 'b-', 'LineWidth', 3);
title('Linear Dispersion'); xlabel('x'); ylabel('D(x)');
grid on; ylim([0, 1.1]); set(gca, 'FontSize', 12);

subplot(1, 3, 2);
plot(x, D_exponential, 'r-', 'LineWidth', 3);
title('Exponential Dispersion'); xlabel('x'); ylabel('D(x)');
grid on; ylim([0, 1.1]); set(gca, 'FontSize', 12);

subplot(1, 3, 3);
plot(x, D_inverse_power, 'g-', 'LineWidth', 3);
title('Inverse Power Law Dispersion'); xlabel('x'); ylabel('D(x)');
grid on; ylim([0, 1.1]); set(gca, 'FontSize', 12);

% Figure 2: Simple STW with dispersion
figure('Name', 'Simple STW Model - Dispersion Effects', 'Position', [150, 150, 1400, 1000]);

% Original
subplot(2, 4, 1);
imagesc(x, t, Y_simple);
title('Original Simple STW', 'FontSize', 14); xlabel('x'); ylabel('t');
colorbar; axis xy; set(gca, 'FontSize', 12);

% With dispersion
subplot(2, 4, 2);
imagesc(x, t, Y_simple_linear);
title('+ Linear Dispersion', 'FontSize', 14); xlabel('x'); ylabel('t');
colorbar; axis xy; set(gca, 'FontSize', 12);

subplot(2, 4, 3);
imagesc(x, t, Y_simple_exp);
title('+ Exponential Dispersion', 'FontSize', 14); xlabel('x'); ylabel('t');
colorbar; axis xy; set(gca, 'FontSize', 12);

subplot(2, 4, 4);
imagesc(x, t, Y_simple_power);
title('+ Power Law Dispersion', 'FontSize', 14); xlabel('x'); ylabel('t');
colorbar; axis xy; set(gca, 'FontSize', 12);

% Cross-sections at middle time
mid_t = round(length(t)/2);
subplot(2, 4, [5, 6]);
plot(x, Y_simple(mid_t, :), 'k-', 'LineWidth', 3, 'DisplayName', 'Original');
hold on;
plot(x, Y_simple_linear(mid_t, :), 'b-', 'LineWidth', 2, 'DisplayName', 'Linear');
plot(x, Y_simple_exp(mid_t, :), 'r-', 'LineWidth', 2, 'DisplayName', 'Exponential');
plot(x, Y_simple_power(mid_t, :), 'g-', 'LineWidth', 2, 'DisplayName', 'Power Law');
xlabel('x'); ylabel('Amplitude'); title('Spatial Profiles at t=2.0', 'FontSize', 14);
legend('Location', 'best'); grid on; set(gca, 'FontSize', 12);

% Cross-sections at middle position
mid_x = round(length(x)/2);
subplot(2, 4, [7, 8]);
plot(t, Y_simple(:, mid_x), 'k-', 'LineWidth', 3, 'DisplayName', 'Original');
hold on;
plot(t, Y_simple_linear(:, mid_x), 'b-', 'LineWidth', 2, 'DisplayName', 'Linear');
plot(t, Y_simple_exp(:, mid_x), 'r-', 'LineWidth', 2, 'DisplayName', 'Exponential');
plot(t, Y_simple_power(:, mid_x), 'g-', 'LineWidth', 2, 'DisplayName', 'Power Law');
xlabel('t'); ylabel('Amplitude'); title('Temporal Profiles at x=4.0', 'FontSize', 14);
legend('Location', 'best'); grid on; set(gca, 'FontSize', 12);

% Figure 3: Freqdisp STW with dispersion
figure('Name', 'Freqdisp STW Model - Dispersion Effects', 'Position', [200, 200, 1400, 1000]);

% Original
subplot(2, 4, 1);
imagesc(x, t, Y_freqdisp);
title('Original Freqdisp STW', 'FontSize', 14); xlabel('x'); ylabel('t');
colorbar; axis xy; set(gca, 'FontSize', 12);

% With dispersion
subplot(2, 4, 2);
imagesc(x, t, Y_freqdisp_linear);
title('+ Linear Dispersion', 'FontSize', 14); xlabel('x'); ylabel('t');
colorbar; axis xy; set(gca, 'FontSize', 12);

subplot(2, 4, 3);
imagesc(x, t, Y_freqdisp_exp);
title('+ Exponential Dispersion', 'FontSize', 14); xlabel('x'); ylabel('t');
colorbar; axis xy; set(gca, 'FontSize', 12);

subplot(2, 4, 4);
imagesc(x, t, Y_freqdisp_power);
title('+ Power Law Dispersion', 'FontSize', 14); xlabel('x'); ylabel('t');
colorbar; axis xy; set(gca, 'FontSize', 12);

% Cross-sections
subplot(2, 4, [5, 6]);
plot(x, Y_freqdisp(mid_t, :), 'k-', 'LineWidth', 3, 'DisplayName', 'Original');
hold on;
plot(x, Y_freqdisp_linear(mid_t, :), 'b-', 'LineWidth', 2, 'DisplayName', 'Linear');
plot(x, Y_freqdisp_exp(mid_t, :), 'r-', 'LineWidth', 2, 'DisplayName', 'Exponential');
plot(x, Y_freqdisp_power(mid_t, :), 'g-', 'LineWidth', 2, 'DisplayName', 'Power Law');
xlabel('x'); ylabel('Amplitude'); title('Spatial Profiles at t=2.0', 'FontSize', 14);
legend('Location', 'best'); grid on; set(gca, 'FontSize', 12);

subplot(2, 4, [7, 8]);
plot(t, Y_freqdisp(:, mid_x), 'k-', 'LineWidth', 3, 'DisplayName', 'Original');
hold on;
plot(t, Y_freqdisp_linear(:, mid_x), 'b-', 'LineWidth', 2, 'DisplayName', 'Linear');
plot(t, Y_freqdisp_exp(:, mid_x), 'r-', 'LineWidth', 2, 'DisplayName', 'Exponential');
plot(t, Y_freqdisp_power(:, mid_x), 'g-', 'LineWidth', 2, 'DisplayName', 'Power Law');
xlabel('t'); ylabel('Amplitude'); title('Temporal Profiles at x=4.0', 'FontSize', 14);
legend('Location', 'best'); grid on; set(gca, 'FontSize', 12);

% Figure 4: Side-by-side comparison
figure('Name', 'STW Models Comparison with Exponential Dispersion', 'Position', [250, 250, 1200, 600]);

subplot(2, 3, 1);
imagesc(x, t, Y_simple);
title('Simple STW (Original)', 'FontSize', 14); xlabel('x'); ylabel('t');
colorbar; axis xy; set(gca, 'FontSize', 12);

subplot(2, 3, 2);
imagesc(x, t, Y_simple_exp);
title('Simple STW + Exp Dispersion', 'FontSize', 14); xlabel('x'); ylabel('t');
colorbar; axis xy; set(gca, 'FontSize', 12);

subplot(2, 3, 3);
plot(x, Y_simple(mid_t, :), 'k-', 'LineWidth', 2, 'DisplayName', 'Original');
hold on;
plot(x, Y_simple_exp(mid_t, :), 'r-', 'LineWidth', 2, 'DisplayName', 'With Dispersion');
xlabel('x'); ylabel('Amplitude'); title('Simple STW Comparison', 'FontSize', 14);
legend; grid on; set(gca, 'FontSize', 12);

subplot(2, 3, 4);
imagesc(x, t, Y_freqdisp);
title('Freqdisp STW (Original)', 'FontSize', 14); xlabel('x'); ylabel('t');
colorbar; axis xy; set(gca, 'FontSize', 12);

subplot(2, 3, 5);
imagesc(x, t, Y_freqdisp_exp);
title('Freqdisp STW + Exp Dispersion', 'FontSize', 14); xlabel('x'); ylabel('t');
colorbar; axis xy; set(gca, 'FontSize', 12);

subplot(2, 3, 6);
plot(x, Y_freqdisp(mid_t, :), 'k-', 'LineWidth', 2, 'DisplayName', 'Original');
hold on;
plot(x, Y_freqdisp_exp(mid_t, :), 'r-', 'LineWidth', 2, 'DisplayName', 'With Dispersion');
xlabel('x'); ylabel('Amplitude'); title('Freqdisp STW Comparison', 'FontSize', 14);
legend; grid on; set(gca, 'FontSize', 12);

%% 6. Summary
fprintf('\nSummary of Dispersion Effects:\n');
fprintf('==============================\n');
fprintf('Linear Dispersion:\n');
fprintf('  - Creates sharp cutoff at x = %.1f\n', 1/alpha);
fprintf('  - Amplitude reduced to %.1f%% of original\n', 100*max(Y_simple_linear(:))/max(Y_simple(:)));

fprintf('\nExponential Dispersion:\n');
fprintf('  - Smooth exponential decay\n');
fprintf('  - Amplitude reduced to %.1f%% of original\n', 100*max(Y_simple_exp(:))/max(Y_simple(:)));

fprintf('\nInverse Power Law Dispersion:\n');
fprintf('  - Gradual, slower decay\n');
fprintf('  - Amplitude reduced to %.1f%% of original\n', 100*max(Y_simple_power(:))/max(Y_simple(:)));

fprintf('\nKey Observations:\n');
fprintf('- Dispersion reduces wave amplitude with distance\n');
fprintf('- Different dispersion types create different decay patterns\n');
fprintf('- Both STW models respond similarly to the same dispersion\n');
fprintf('- Spatial dispersion affects wave propagation along x-direction\n\n');

fprintf('Demo complete! Try adjusting alpha parameter for different effects.\n');
