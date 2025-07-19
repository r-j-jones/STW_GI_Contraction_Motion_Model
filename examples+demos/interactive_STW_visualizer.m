function interactive_STW_visualizer()
    % interactive_STW_visualizer - Interactive tool for visualizing STW models
    %
    % This script provides an interactive interface to:
    % 1. Generate or load input data (X matrix or separate x,t vectors)
    % 2. Select STW model type (simple or freqdisp)
    % 3. Adjust model parameters with sliders
    % 4. Visualize input data and model output in real-time
    
    % Initialize the main figure
    fig = figure('Name', 'Interactive STW Model Visualizer', ...
                 'Position', [100, 100, 1200, 800], ...
                 'NumberTitle', 'off', ...
                 'MenuBar', 'none', ...
                 'ToolBar', 'figure');
    
    % Use a structure to store data and handles, and store it with guidata
    handles = struct();
    handles.data_X = generate_default_data();
    handles.model_type = 'freqdisp';
    handles.fig = fig;
    
    % Create the GUI layout
    handles = create_gui_layout(handles);
    
    % Store handles structure
    guidata(fig, handles);
    
    % Initialize with default parameters
    update_model_display(fig);
end

function X = generate_default_data()
    % Generate default vector data
    x_range = linspace(0, 10, 50);
    t_range = linspace(0, 5, 30);
    X = {x_range, t_range};  % Store as cell array for vectors
end

function handles = create_gui_layout(handles)
    fig = handles.fig;
    
    % Create main panels
    data_panel = uipanel('Parent', fig, 'Title', 'Data Management', ...
                        'Position', [0.02, 0.7, 0.25, 0.28]);
    
    model_panel = uipanel('Parent', fig, 'Title', 'Model Selection', ...
                         'Position', [0.02, 0.5, 0.25, 0.18]);
    
    param_panel = uipanel('Parent', fig, 'Title', 'Parameters', ...
                         'Position', [0.02, 0.02, 0.25, 0.46]);
    
    plot_panel = uipanel('Parent', fig, 'Title', 'Visualization', ...
                        'Position', [0.3, 0.02, 0.68, 0.96]);
    
    % Data management controls
    handles = create_data_controls(handles, data_panel);
    
    % Model selection controls
    handles = create_model_controls(handles, model_panel);
    
    % Parameter controls
    handles = create_parameter_controls(handles, param_panel);
    
    % Plotting area
    handles = create_plot_area(handles, plot_panel);
end

function handles = create_data_controls(handles, parent)
    data_X = handles.data_X;
    
    % Data generation section
    uicontrol('Parent', parent, 'Style', 'text', ...
              'String', 'Generate Data:', 'FontWeight', 'bold', ...
              'Position', [10, 120, 100, 20], 'HorizontalAlignment', 'left');
    
    % X range controls
    uicontrol('Parent', parent, 'Style', 'text', ...
              'String', 'X range:', 'Position', [10, 100, 50, 15]);
    uicontrol('Parent', parent, 'Style', 'edit', 'Tag', 'x_min', ...
              'String', '0', 'Position', [65, 100, 30, 20]);
    uicontrol('Parent', parent, 'Style', 'text', ...
              'String', 'to', 'Position', [100, 100, 15, 15]);
    uicontrol('Parent', parent, 'Style', 'edit', 'Tag', 'x_max', ...
              'String', '10', 'Position', [120, 100, 30, 20]);
    uicontrol('Parent', parent, 'Style', 'edit', 'Tag', 'x_points', ...
              'String', '50', 'Position', [155, 100, 30, 20]);
    
    % T range controls
    uicontrol('Parent', parent, 'Style', 'text', ...
              'String', 'T range:', 'Position', [10, 80, 50, 15]);
    uicontrol('Parent', parent, 'Style', 'edit', 'Tag', 't_min', ...
              'String', '0', 'Position', [65, 80, 30, 20]);
    uicontrol('Parent', parent, 'Style', 'text', ...
              'String', 'to', 'Position', [100, 80, 15, 15]);
    uicontrol('Parent', parent, 'Style', 'edit', 'Tag', 't_max', ...
              'String', '5', 'Position', [120, 80, 30, 20]);
    uicontrol('Parent', parent, 'Style', 'edit', 'Tag', 't_points', ...
              'String', '30', 'Position', [155, 80, 30, 20]);
    
    % Generate button
    uicontrol('Parent', parent, 'Style', 'pushbutton', ...
              'String', 'Generate Grid', 'Position', [10, 55, 80, 25], ...
              'Callback', @(src,evt)generate_data_callback(src,evt,handles.fig));
    
    % Load data section
    uicontrol('Parent', parent, 'Style', 'text', ...
              'String', 'Load Data:', 'FontWeight', 'bold', ...
              'Position', [10, 30, 100, 20], 'HorizontalAlignment', 'left');
    
    uicontrol('Parent', parent, 'Style', 'pushbutton', ...
              'String', 'Load X Matrix', 'Position', [10, 5, 80, 25], ...
              'Callback', @(src,evt)load_data_callback(src,evt,handles.fig));
    
    % Data info display
    uicontrol('Parent', parent, 'Style', 'text', 'Tag', 'data_info', ...
              'String', sprintf('Current: x(%d), t(%d)', length(data_X{1}), length(data_X{2})), ...
              'Position', [100, 5, 120, 40], 'HorizontalAlignment', 'left');
end
              

function create_model_controls(parent)
    global model_type
    
    % Model selection
    uicontrol('Parent', parent, 'Style', 'text', ...
              'String', 'Select Model:', 'FontWeight', 'bold', ...
              'Position', [10, 50, 100, 20], 'HorizontalAlignment', 'left');
    
    uicontrol('Parent', parent, 'Style', 'radiobutton', 'Tag', 'radio_simple', ...
              'String', 'Simple STW', 'Value', 1, ...
              'Position', [10, 30, 100, 20], ...
              'Callback', @model_selection_callback);
    
    uicontrol('Parent', parent, 'Style', 'radiobutton', 'Tag', 'radio_freqdisp', ...
              'String', 'Freqdisp STW', 'Value', 0, ...
              'Position', [10, 10, 100, 20], ...
              'Callback', @model_selection_callback);
end

function create_parameter_controls(parent)
    global param_handles param_values
    
    % Initialize parameter structures
    param_handles = struct();
    param_values = struct();
    
    % Simple model parameters (default)
    create_simple_params(parent);
end

function create_simple_params(parent)
    global param_handles param_values
    
    % Clear existing controls
    delete(findobj(parent, 'Type', 'uicontrol'));
    
    % Simple model: [A, k, b, o, c]
    params = {'A', 'k', 'b', 'o', 'c'};
    defaults = [1, 2, 3, 0, 0];
    ranges = {[-5, 5], [0, 10], [0, 10], [-pi, pi], [-2, 2]};
    
    param_values.simple = defaults;
    
    y_pos = 320;
    for i = 1:length(params)
        % Parameter label
        uicontrol('Parent', parent, 'Style', 'text', ...
                  'String', sprintf('%s:', params{i}), ...
                  'Position', [10, y_pos, 20, 20]);
        
        % Value display
        param_handles.(params{i}).value = uicontrol('Parent', parent, 'Style', 'text', ...
                  'String', sprintf('%.2f', defaults(i)), ...
                  'Position', [35, y_pos, 40, 20]);
        
        % Slider
        param_handles.(params{i}).slider = uicontrol('Parent', parent, 'Style', 'slider', ...
                  'Min', ranges{i}(1), 'Max', ranges{i}(2), ...
                  'Value', defaults(i), ...
                  'Position', [80, y_pos, 150, 20], ...
                  'Tag', params{i}, ...
                  'Callback', @parameter_callback);
        
        y_pos = y_pos - 30;
    end
end

function create_freqdisp_params(parent)
    global param_handles param_values
    
    % Clear existing controls
    delete(findobj(parent, 'Type', 'uicontrol'));
    
    % Freqdisp model: [A, k0, k1, b0, b1, mu, o, c]
    params = {'A', 'k0', 'k1', 'b0', 'b1', 'mu', 'o', 'c'};
    defaults = [1, 2, 0.1, 3, 0.1, 0.1, 0, 0];
    ranges = {[-5, 5], [0, 10], [-1, 1], [0, 10], [-1, 1], [-1, 1], [-pi, pi], [-2, 2]};
    
    param_values.freqdisp = defaults;
    
    y_pos = 320;
    for i = 1:length(params)
        % Parameter label
        uicontrol('Parent', parent, 'Style', 'text', ...
                  'String', sprintf('%s:', params{i}), ...
                  'Position', [10, y_pos, 25, 20]);
        
        % Value display
        param_handles.(params{i}).value = uicontrol('Parent', parent, 'Style', 'text', ...
                  'String', sprintf('%.3f', defaults(i)), ...
                  'Position', [40, y_pos, 40, 20]);
        
        % Slider
        param_handles.(params{i}).slider = uicontrol('Parent', parent, 'Style', 'slider', ...
                  'Min', ranges{i}(1), 'Max', ranges{i}(2), ...
                  'Value', defaults(i), ...
                  'Position', [85, y_pos, 140, 20], ...
                  'Tag', params{i}, ...
                  'Callback', @parameter_callback);
        
        y_pos = y_pos - 35;
    end
end

function create_plot_area(parent)
    global axes_handles
    
    % Create subplot areas
    axes_handles.input = subplot(2, 2, 1, 'Parent', parent);
    title('Input Data (X,T)', 'Parent', axes_handles.input);
    
    axes_handles.output = subplot(2, 2, 2, 'Parent', parent);
    title('Model Output (Y)', 'Parent', axes_handles.output);
    
    axes_handles.surface = subplot(2, 2, [3, 4], 'Parent', parent);
    title('3D Surface Plot', 'Parent', axes_handles.surface);
end

function generate_data_callback(~, ~, fig)
    handles = guidata(fig);
    
    % Get values from GUI
    x_min = str2double(get(findobj('Tag', 'x_min'), 'String'));
    x_max = str2double(get(findobj('Tag', 'x_max'), 'String'));
    x_points = str2double(get(findobj('Tag', 'x_points'), 'String'));
    
    t_min = str2double(get(findobj('Tag', 't_min'), 'String'));
    t_max = str2double(get(findobj('Tag', 't_max'), 'String'));
    t_points = str2double(get(findobj('Tag', 't_points'), 'String'));
    
    % Generate new data as vectors
    x_range = linspace(x_min, x_max, x_points);
    t_range = linspace(t_min, t_max, t_points);
    handles.data_X = {x_range, t_range};
    
    % Update info display
    set(findobj('Tag', 'data_info'), 'String', ...
        sprintf('Current: x(%d), t(%d)\nX: [%.1f, %.1f]\nT: [%.1f, %.1f]', ...
        length(x_range), length(t_range), x_min, x_max, t_min, t_max));
    
    guidata(fig, handles);
    % Update display
    update_model_display(fig);
end
function load_data_callback(~, ~, fig)
    handles = guidata(fig);
    
    [filename, pathname] = uigetfile({'*.mat', 'MAT files (*.mat)'; ...
                                     '*.txt', 'Text files (*.txt)'; ...
                                     '*.csv', 'CSV files (*.csv)'}, ...
                                     'Select data file');
    
    if filename ~= 0
        try
            if endsWith(filename, '.mat')
                loaded = load(fullfile(pathname, filename));
                fields = fieldnames(loaded);
                if length(fields) >= 2
                    % Assume first two variables are x and t vectors
                    x_data = loaded.(fields{1});
                    t_data = loaded.(fields{2});
                    handles.data_X = {x_data(:)', t_data(:)'};  % Ensure row vectors
                else
                    error('MAT file must contain at least 2 variables (x and t vectors)');
                end
            else
                loaded_data = readmatrix(fullfile(pathname, filename));
                if size(loaded_data, 2) >= 2
                    handles.data_X = {loaded_data(:,1)', loaded_data(:,2)'};
                else
                    error('Data file must have at least 2 columns');
                end
            end
            
            % Update info display
            set(findobj('Tag', 'data_info'), 'String', ...
                sprintf('Loaded: x(%d), t(%d)\nX: [%.2f, %.2f]\nT: [%.2f, %.2f]', ...
                length(handles.data_X{1}), length(handles.data_X{2}), min(handles.data_X{1}), max(handles.data_X{1}), ...
                min(handles.data_X{2}), max(handles.data_X{2})));
            
            guidata(fig, handles);
            % Update display
            update_model_display(fig);
            
        catch ME
            errordlg(['Error loading data: ' ME.message], 'Load Error');
        end
    end
end
        

function model_selection_callback(src, ~)
    global model_type
    
    % Update radio buttons
    if strcmp(get(src, 'Tag'), 'radio_simple')
        model_type = 'simple';
        set(findobj('Tag', 'radio_simple'), 'Value', 1);
        set(findobj('Tag', 'radio_freqdisp'), 'Value', 0);
        create_simple_params(get(src, 'Parent'));
    else
        model_type = 'freqdisp';
        set(findobj('Tag', 'radio_simple'), 'Value', 0);
        set(findobj('Tag', 'radio_freqdisp'), 'Value', 1);
        create_freqdisp_params(get(src, 'Parent'));
    end
    
    % Update display
    update_model_display();
end

function parameter_callback(src, ~)
    global param_handles param_values model_type
    
    param_name = get(src, 'Tag');
    value = get(src, 'Value');
    
    % Update value display
    set(param_handles.(param_name).value, 'String', sprintf('%.3f', value));
    
    % Update stored parameters
    if strcmp(model_type, 'simple')
        param_idx = find(strcmp(param_name, {'A', 'k', 'b', 'o', 'c'}));
        param_values.simple(param_idx) = value;
    else
        param_idx = find(strcmp(param_name, {'A', 'k0', 'k1', 'b0', 'b1', 'mu', 'o', 'c'}));
        param_values.freqdisp(param_idx) = value;
    end
end
    
function update_model_display(fig)
    handles = guidata(fig);
    data_X = handles.data_X;
    model_type = handles.model_type;
    param_values = handles.param_values;
    axes_handles = handles.axes_handles;
    
    % Extract x and t vectors
    x = data_X{1};
    t = data_X{2};
    
    % Calculate model output
    if strcmp(model_type, 'simple')
        Y = simple_STW_model(param_values.simple, x, t);
    else
        Y = freqdisp_STW_model(param_values.freqdisp, x, t);
    end
    
    % Create meshgrids for plotting
    [X_grid, T_grid] = meshgrid(x, t);
    
    % Plot input data
    axes(axes_handles.input);
    plot(x, zeros(size(x)), 'bo', 'MarkerSize', 4, 'DisplayName', 'x points');
    hold on;
    plot(zeros(size(t)), t, 'ro', 'MarkerSize', 4, 'DisplayName', 't points');
    hold off;
    xlabel('X'); ylabel('T');
    title('Input Data Vectors');
    legend; grid on;
    
    % Plot model output as image
    axes(axes_handles.output);
    imagesc(x, t, Y);
    xlabel('X'); ylabel('T');
    title(sprintf('Model Output (%s)', model_type));
    colorbar; axis xy;
    
    % Plot 3D surface
    axes(axes_handles.surface);
    surf(X_grid, T_grid, Y);
    xlabel('X'); ylabel('T'); zlabel('Y');
    title(sprintf('3D Surface - %s Model', model_type));
    colorbar;
    shading interp;
end
