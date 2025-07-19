function Y = simple_STW_model(params, varargin)
    % simple_STW_model - Defines a sinusoidal function for nonlinear regression
    %
    % Y = A * sin(k * x + b * t + o) + c;
    % 
    % Syntax: 
    %   Y = simple_STW_model(params, x, t)     % Vector inputs
    %   Y = simple_STW_model(params, X, T)     % Meshgrid inputs
    %
    % Inputs:
    %   params - A vector of parameters: [A, k, b, o, c]
    %       A  - Amplitude
    %       k  - Wave number (frequency along x) [spatial freq]
    %       b  - Frequency along t [temporal/phase angle freq]
    %       o  - Phase shift
    %       c  - Constant offset
    %   
    %   Input data (two options):
    %   Option 1: Vector inputs
    %       x - Vector of spatial values (length nx)
    %       t - Vector of temporal values (length nt)
    %   Option 2: Meshgrid inputs  
    %       X - Meshgrid of x-values (size [nt, nx])
    %       T - Meshgrid of t-values (size [nt, nx])
    %
    % Output:
    %   Y - The model output matrix (size [nt, nx])

    % Verify that params has 5 elements
    if length(params) ~= 5
        error('The parameter vector "params" must have exactly 5 elements.');
    end
    
    % Parse input arguments
    if nargin ~= 3
        error('simple_STW_model requires exactly 3 inputs: params, x/X, t/T');
    end
    
    x_input = varargin{1};
    t_input = varargin{2};
    
    % Determine input type and create meshgrids if needed
    if isvector(x_input) && isvector(t_input)
        % Vector inputs - create meshgrids
        x_input = x_input(:);  % Ensure column vector
        t_input = t_input(:);  % Ensure column vector
        [X, T] = meshgrid(x_input, t_input);
        nx = length(x_input);
        nt = length(t_input);
    elseif ismatrix(x_input) && ismatrix(t_input) && isequal(size(x_input), size(t_input))
        % Meshgrid inputs
        X = x_input;
        T = t_input;
        [nt, nx] = size(X);
    else
        error('Inputs must be either (x,t) vectors or (X,T) meshgrids of same size');
    end
    
    % Extract parameters
    A = params(1);
    k = params(2);
    b = params(3);
    o = params(4);
    c = params(5);

    % Calculate model output
    Y = A * sin(k * X + b * T + o) + c;
end



% % Example usage with nlinfit
% beta0 = [1, 2, 3, 0, 0];  % Initial parameter guesses
% opts = statset('nlinfit', 'RobustWgtFun', 'bisquare');  % Robust fitting options

% params_fit = nlinfit(Xdata, Ydata, @sin_model, beta0, opts);

