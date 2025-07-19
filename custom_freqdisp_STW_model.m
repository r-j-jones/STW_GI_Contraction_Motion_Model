function  Y= custom_freqdisp_STW_model(params, X, varargin)
    % custom_freqdisp_STW_model - 
    %   Defines a sinusoidal function for nonlinear regression. 
    %   Includes higher-order "frequency dispersion" terms.
    %
    %   REDUCED MODEL (default):
    %   Y = A * sin((k0 + k1*x)*x + (b0 + b1*t)*t + mu*x*t + o) + c
    %
    %   EXPANDED MODEL:
    %   sinterm = sin((k0 + k1 * X(:,1) + k2 * X(:,2)) * X(:,1) + ...
    %                 (b0 + b1 * X(:,1) + b2 * X(:,2)) * X(:,2) + o);
    %   Y = A * sinterm + c;
    %
    % Syntax: Y = custom_freqdisp_STW_model(params, X)
    %          Y = custom_freqdisp_STW_model(params, X, model_type)
    %
    % Inputs:
    %   params - Parameter vector (length depends on model type):
    %       REDUCED (8 params): [A, k0, k1, b0, b1, mu, o, c]
    %           A    - Amplitude
    %           k0  - Base wave number
    %           k1  - Linear wave number coefficient
    %           b0  - Base frequency
    %           b1  - Linear frequency coefficient
    %           mu   - Cross-term coupling coefficient
    %           o    - Phase shift
    %           c    - Constant offset
    %       EXPANDED (9 params): [A, k0, k1, k2, b0, b1, b2, o, c]
    %           A  - Amplitude
    %           k0 - Base wave number (frequency along x)
    %           k1 - Linear term for wave number variation with x
    %           k2 - Linear term for wave number variation with t
    %           b0 - Base frequency along t (temporal/phase angle freq)
    %           b1 - Linear term for frequency variation with x
    %           b2 - Linear term for frequency variation with t
    %           o  - Phase shift
    %           c  - Constant offset
    %   X - An Nx2 matrix where:
    %       X(:,1) represents x-values
    %       X(:,2) represents t-values
    %   model_type - Optional string: 'reduced' (default) or 'expanded'
    %
    % Output:
    %   Y - The model output, a sinusoidal function evaluated at (X, T)

    % Parse optional input argument for model type
    if isempty(varargin)
        model_type = 'reduced';  % Default to reduced model
    else
        model_type = varargin{1};
        if ~ischar(model_type) && ~isstring(model_type)
            error('Model type must be a string: ''reduced'' or ''expanded''');
        end
        model_type = lower(char(model_type));
    end
    
    % Validate model type
    if ~ismember(model_type, {'reduced', 'expanded'})
        error('Model type must be ''reduced'' or ''expanded''');
    end
    
    % Process based on model type
    if strcmp(model_type, 'reduced')
        % REDUCED MODEL: Y = A * sin((k0 + k1*x)*x + (b0 + b1*t)*t + mu*x*t + o) + c
        if length(params) ~= 8
            error('For reduced model, parameter vector "params" must have exactly 8 elements: [A, k_0, k_1, b_0, b_1, mu, o, c]');
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
        A = params(1);
        k0 = params(2);
        k1 = params(3);
        b0 = params(4);
        b1 = params(5);
        mu = params(6);
        o = params(7);
        c = params(8);
        
        x = X(:,1);
        t = X(:,2);
        
        sinterm = sin((k0 + k1 * x) .* x + (b0 + b1 * t) .* t + mu * x .* t + o);
        Y = A * sinterm + c;
        
    else  % expanded model
        % EXPANDED MODEL: Original implementation
        if length(params) ~= 9
            error('For expanded model, parameter vector "params" must have exactly 9 elements: [A, k0, k1, k2, b0, b1, b2, o, c]');
        end
        fprintf('Using EXPANDED freqdisp model.\n');
        fprintf('Parameters:\n');
        fprintf('  A   = %g\n', params(1));
        fprintf('  k0  = %g\n', params(2));
        fprintf('  k1  = %g\n', params(3));
        fprintf('  k2  = %g\n', params(4));
        fprintf('  b0  = %g\n', params(5));
        fprintf('  b1  = %g\n', params(6));
        fprintf('  b2  = %g\n', params(7));
        fprintf('  o   = %g\n', params(8));
        fprintf('  c   = %g\n\n', params(9));
        
        A = params(1);
        k0 = params(2);
        k1 = params(3);
        k2 = params(4);
        b0 = params(5);
        b1 = params(6);
        b2 = params(7);
        o = params(8);
        c = params(9);
        
        sinterm = sin( (k0 + k1 * X(:,1) + k2 * X(:,2)) .* X(:,1) + ...
            (b0 + b1 * X(:,1) + b2 * X(:,2)) .* X(:,2) + o );
        Y = A * sinterm + c;
    end
    
end
