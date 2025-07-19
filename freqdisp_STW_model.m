function Y = freqdisp_STW_model(params, varargin)
    % freqdisp_STW_model - 
    %   Defines a sinusoidal function for nonlinear regression. 
    %   Includes higher-order "frequency dispersion" terms.
    %
    %   REDUCED MODEL:
    %   Y = A * sin((k0 + k1*x)*x + (b0 + b1*t)*t + mu*x*t + o) + c
    %
    % Syntax: 
    %   Y = freqdisp_STW_model(params, x, t)     % Vector inputs
    %   Y = freqdisp_STW_model(params, X, T)     % Meshgrid inputs
    %
    % Inputs:
    %   params - Parameter vector for the model:
    %       REDUCED (8 params): [A, k0, k1, b0, b1, mu, o, c]
    %           A    - Amplitude
    %           k0  - Base wave number
    %           k1  - Linear wave number coefficient
    %           b0  - Base frequency
    %           b1  - Linear frequency coefficient
    %           mu   - Cross-term coupling coefficient
    %           o    - Phase shift
    %           c    - Constant offset
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

    
    % REDUCED MODEL: Y = A * sin((k0 + k1*x)*x + (b0 + b1*t)*t + mu*x*t + o) + c
    if length(params) ~= 8
        error('For reduced model, parameter vector "params" must have exactly 8 elements: [A, k_0, k_1, b_0, b_1, mu, o, c]');
    end
    
    % Parse input arguments
    if nargin ~= 3
        error('freqdisp_STW_model requires exactly 3 inputs: params, x/X, t/T');
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
    
    fprintf('Using REDUCED freqdisp model.\n');
    fprintf('Parameters:\n');
    fprintf('  A     = %g\n', params(1));
    fprintf('  k0    = %g\n', params(2));
    fprintf('  k1    = %g\n', params(3));
    fprintf('  b0    = %g\n', params(4));
    fprintf('  b1    = %g\n', params(5));
    fprintf('  mu    = %g\n', params(6));
    fprintf('  o     = %g\n', params(7));
    fprintf('  c     = %g\n\n', params(8));
    
    % Extract parameters
    A = params(1);
    k0 = params(2);
    k1 = params(3);
    b0 = params(4);
    b1 = params(5);
    mu = params(6);
    o = params(7);
    c = params(8);
    
    % Calculate model output
    sinterm = sin((k0 + k1 * X) .* X + (b0 + b1 * T) .* T + mu * X .* T + o);
    Y = A * sinterm + c;
        
    
    
end
