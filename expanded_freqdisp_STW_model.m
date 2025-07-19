function  Y= expanded_freqdisp_STW_model(params, X)
    % expanded_freqdisp_STW_model - 
    %   Defines a sinusoidal function for nonlinear regression. 
    %   Includes higher-order "frequency dispersion" terms.
    %
    %   EXPANDED MODEL:
    %   sinterm = sin((k0 + k1 * X(:,1) + k2 * X(:,2)) * X(:,1) + ...
    %                 (b0 + b1 * X(:,1) + b2 * X(:,2)) * X(:,2) + o);
    %   Y = A * sinterm + c;
    %
    % Syntax: Y = expanded_freqdisp_STW_model(params, X)
    %
    % Inputs:
    %   params - Parameter vector for the model:
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
    %
    % Output:
    %   Y - The model output, a sinusoidal function evaluated at (X, T)
    
    
    % EXPANDED MODEL: Original implementation
    if length(params) ~= 9
        error('For expanded freqdisp model, parameter vector "params" must have exactly 9 elements: [A, k0, k1, k2, b0, b1, b2, o, c]');
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
