function test_STW_models()
    % test_STW_models - Script to test and visualize STW model outputs
    %
    % This script demonstrates how to:
    % 1. Generate input data (x and t vectors)
    % 2. Use simple_STW_model and freqdisp_STW_model functions
    % 3. Visualize the results as [nt, nx] matrices
    
    fprintf('=== STW Models Testing Script ===\n\n');
    
    %% 1. Generate test data
    fprintf('1. Generating test data...\n');
    
    % Create spatial and temporal vectors
    x = linspace(0, 10, 50);
    t = linspace(0, 5, 30);
    
    fprintf('   Data vectors:\n');
    fprintf('   x: %d points from %.1f to %.1f\n', length(x), min(x), max(x));
    fprintf('   t: %d points from %.1f to %.1f\n\n', length(t), min(t), max(t));
    
    %% 2. Test Simple STW Model
    fprintf('2. Testing Simple STW Model...\n');
    
    % Parameters: [A, k, b, o, c]
    params_simple = [2, 1.5, 2, pi/4, 0.5];
    
    fprintf('   Parameters: A=%.1f, k=%.1f, b=%.1f, o=%.2f, c=%.1f\n', ...
            params_simple);
    
    % Calculate model output
    Y_simple = simple_STW_model(params_simple, x, t);
    
    fprintf('   Output size: [%d, %d] (nt x nx)\n', size(Y_simple, 1), size(Y_simple, 2));
    fprintf('   Output range: [%.2f, %.2f]\n\n', min(Y_simple(:)), max(Y_simple(:)));
    
    %% 3. Test Frequency Dispersion STW Model (Reduced)
    fprintf('3. Testing Frequency Dispersion STW Model (Reduced)...\n');
    
    % Parameters: [A, k0, k1, b0, b1, mu, o, c]
    params_freqdisp = [1.5, 1, 0.2, 2, 0.1, 0.3, 0, 0];
    
    fprintf('   Parameters: A=%.1f, k0=%.1f, k1=%.1f, b0=%.1f, b1=%.1f, mu=%.1f, o=%.1f, c=%.1f\n', ...
            params_freqdisp);
    
    % Calculate model output
    Y_freqdisp = freqdisp_STW_model(params_freqdisp, x, t);
    
    fprintf('   Output size: [%d, %d] (nt x nx)\n', size(Y_freqdisp, 1), size(Y_freqdisp, 2));
    fprintf('   Output range: [%.2f, %.2f]\n\n', min(Y_freqdisp(:)), max(Y_freqdisp(:)));
    
    %% 4. Visualize Results
    fprintf('4. Creating visualizations...\n');
    
    % Create meshgrids for surface plots
    [X_grid, T_grid] = meshgrid(x, t);
    
    % Create figure
    figure('Name', 'STW Models Comparison', 'Position', [100, 100, 1200, 800]);
    
    % Input data plot
    subplot(2, 3, 1);
    plot(x, ones(size(x)), 'bo', 'MarkerSize', 4, 'DisplayName', 'x points');
    hold on;
    plot(ones(size(t)) * mean(x), t, 'ro', 'MarkerSize', 4, 'DisplayName', 't points');
    xlabel('X'); ylabel('T'); title('Input Vectors');
    legend; grid on;
    
    % Simple model - 2D image
    subplot(2, 3, 2);
    imagesc(x, t, Y_simple);
    xlabel('X'); ylabel('T'); title('Simple STW Model');
    colorbar; axis xy;
    
    % Simple model - 3D surface
    subplot(2, 3, 3);
    surf(X_grid, T_grid, Y_simple);
    xlabel('X'); ylabel('T'); zlabel('Y');
    title('Simple STW (3D)');
    shading interp; colorbar;
    
    % Freqdisp model - 2D image
    subplot(2, 3, 5);
    imagesc(x, t, Y_freqdisp);
    xlabel('X'); ylabel('T'); title('Freqdisp STW Model');
    colorbar; axis xy;
    
    % Freqdisp model - 3D surface
    subplot(2, 3, 6);
    surf(X_grid, T_grid, Y_freqdisp);
    xlabel('X'); ylabel('T'); zlabel('Y');
    title('Freqdisp STW (3D)');
    shading interp; colorbar;
    
    % Comparison plot - central slices
    subplot(2, 3, 4);
    mid_t = round(size(Y_simple, 1)/2);
    mid_x = round(size(Y_simple, 2)/2);
    
    plot(x, Y_simple(mid_t, :), 'b-', 'LineWidth', 2, 'DisplayName', 'Simple (x-slice)');
    hold on;
    plot(x, Y_freqdisp(mid_t, :), 'r-', 'LineWidth', 2, 'DisplayName', 'Freqdisp (x-slice)');
    xlabel('X'); ylabel('Y');
    title('Spatial Profiles Comparison');
    legend; grid on;
    
    fprintf('   Visualization complete!\n\n');
    
    %% 5. Save results (optional)
    save_option = input('Save results to file? (y/n): ', 's');
    if strcmpi(save_option, 'y')
        save('STW_model_test_results.mat', 'X', 'Y_simple', 'Y_freqdisp', ...
             'params_simple', 'params_freqdisp', 'X_grid', 'T_grid');
        fprintf('Results saved to STW_model_test_results.mat\n');
    end
    
    fprintf('=== Testing Complete ===\n');

%     % Main execution
%     if ~nargout
%         % Run main test if script is executed directly
%         test_STW_models();
%         
%         % Ask if user wants to see parameter effects
%         demo_choice = input('\nRun parameter effects demo? (y/n): ', 's');
%         if strcmpi(demo_choice, 'y')
%             demo_parameter_effects();
%         end
%         
%         % Ask if user wants to launch interactive tool
%         interactive_choice = input('\nLaunch interactive visualizer? (y/n): ', 's');
%         if strcmpi(interactive_choice, 'y')
%             run_interactive_demo();
%         end
%     end

end

function demo_parameter_effects()
    % demo_parameter_effects - Show how different parameters affect the models
    
    fprintf('\n=== Parameter Effects Demo ===\n');
    
    % Generate simple test data
    x = linspace(0, 5, 60);
    t = linspace(0, 3, 40);
    
    %% Simple Model Parameter Effects
    figure('Name', 'Simple Model Parameter Effects', 'Position', [150, 150, 1000, 600]);
    
    base_params = [1, 2, 3, 0, 0]; % [A, k, b, o, c]
    param_names = {'Amplitude (A)', 'Wave number (k)', 'Frequency (b)', 'Phase (o)', 'Offset (c)'};
    param_variations = {[0.5, 1, 2], [1, 2, 4], [1, 3, 5], [-pi/2, 0, pi/2], [-1, 0, 1]};
    
    for i = 1:5
        subplot(2, 3, i);
        
        for j = 1:3
            params = base_params;
            params(i) = param_variations{i}(j);
            
            Y = simple_STW_model(params, x, t);
            
            contour(x, t, Y, 10);
            hold on;
        end
        
        title(param_names{i});
        xlabel('X'); ylabel('T');
        grid on;
    end
    
    %% Freqdisp Model Parameter Effects
    figure('Name', 'Freqdisp Model Parameter Effects', 'Position', [200, 200, 1200, 800]);
    
    base_params_freq = [1, 1, 0.1, 2, 0.1, 0.1, 0, 0]; % [A, k0, k1, b0, b1, mu, o, c]
    param_names_freq = {'Amplitude (A)', 'Base k (k0)', 'k variation (k1)', ...
                       'Base freq (b0)', 'freq variation (b1)', 'Coupling (mu)', 'Phase (o)', 'Offset (c)'};
    
    for i = 1:8
        subplot(2, 4, i);
        
        params = base_params_freq;
        
        % Show effect of varying this parameter
        if i == 1 % A
            param_vals = [0.5, 1, 2];
        elseif i == 6 % mu
            param_vals = [-0.3, 0, 0.3];
        else
            param_vals = params(i) * [0.5, 1, 2];
        end
        
        for j = 1:3
            params = base_params_freq;
            params(i) = param_vals(j);
            
            Y = freqdisp_STW_model(params, x, t);
            
            contour(x, t, Y, 8);
            hold on;
        end
        
        title(param_names_freq{i});
        xlabel('X'); ylabel('T');
        grid on;
    end
    
    fprintf('Parameter effects demonstration complete!\n');
end

function run_interactive_demo()
    % Quick function to launch the interactive visualizer
    fprintf('\nLaunching Interactive STW Visualizer...\n');
    interactive_STW_visualizer();
end


