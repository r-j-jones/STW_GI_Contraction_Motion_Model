function D = A_dispersion_function(type, mu, alpha, beta, gamma, mu0, sigma)
    % A_DISPERSION_FUNCTION - Computes different types of dispersion functions
    %
    % Inputs:
    %   type  - String specifying the type of dispersion function:
    %           Univariate: 
    %               'linear', 'exponential', 'inverse_power_law', 'quadratic', 
    %               'gaussian', 'gaussian_bump', 'logarithmic', 'sigmoid', 'tanh'
    %           Bivariate (spatiotemporal): 
    %               'multiplicative', 'bivariate', 'gaussian_envelope', 'power_law'
    %   mu    - The variable (x or t) for which dispersion is computed.
    %           For spatiotemporal dispersion, mu should be an Nx2 matrix: [X, T].
    %   alpha - Dispersion parameter (scaling factor for decay/damping).
    %   beta  - Additional parameter for bivariate dispersion terms (optional).
    %   gamma - Exponent for power-law dispersion (optional).
    %   mu0   - Center location for Gaussian bump (optional).
    %   sigma - Standard deviation for Gaussian bump/envelope (optional).
    %
    % Output:
    %   D - The computed dispersion factor (same size as mu).
    
    switch lower(type)
        % --- Your Listed Dispersion Functions ---
        case 'linear' 
            % LINEAR DISPERSION: D_i(mu) = max(0, 1 - alpha * mu)
            % - Linearly decreases with mu.
            % - Prevents negative values using max(0, ...).
            D = max(0, 1 - alpha * mu);
        
        case 'exponential' 
            % EXPONENTIAL DISPERSION: D_i(mu) = exp(-alpha * mu)
            % - Decays exponentially as mu increases.
            % - Stronger decay for larger alpha.
            D = exp(-alpha * mu);
        
        case 'inverse_power_law'
            % INVERSE POWER LAW DISPERSION: D_i(mu) = (1 + alpha * mu^2)^(-1/2)
            % - Provides smooth, gradual decay.
            % - Slower decay than exponential for small mu.
            D = (1 + alpha * mu.^2).^(-1/2);
        
        % --- Additional Dispersion Functions ---
        case 'quadratic'
            % QUADRATIC DISPERSION: D_i(mu) = 1 - alpha * mu^2
            % - Quadratic decay; faster damping than linear.
            % - If alpha is too large, negative values may occur.
            D = 1 - alpha * mu.^2;
        
        case 'gaussian'
            % GAUSSIAN DISPERSION: D_i(mu) = exp(-alpha * mu^2)
            % - Decay follows a bell-curve shape.
            % - Smoother than exponential, used for natural damping.
            D = exp(-alpha * mu.^2);
        
        case 'gaussian_bump'
            % GAUSSIAN BUMP FUNCTION: D_i(mu) = exp(-((mu - mu0)^2) / (2 * sigma^2))
            % - Creates a localized "bump" effect at mu0.
            % - sigma controls the spread of the bump.
            D = exp(-((mu - mu0).^2) / (2 * sigma^2));
        
        case 'logarithmic'
            % LOGARITHMIC DISPERSION: D_i(mu) = 1 / (1 + alpha * log(1 + |mu|))
            % - Decay is slower for small mu, faster for large mu.
            % - Useful for systems where decay should be minimal at small scales.
            D = 1 ./ (1 + alpha * log(1 + abs(mu)));
        
        case 'sigmoid'
            % SIGMOID DISPERSION: D_i(mu) = 1 / (1 + exp(alpha * mu))
            % - Smooth transition between high and low values.
            % - Avoids abrupt decay like in exponential dispersion.
            D = 1 ./ (1 + exp(alpha * mu));
        
        case 'tanh'
            % TANH DISPERSION: D_i(mu) = (1 - tanh(alpha * mu)) / 2
            % - Similar to sigmoid but with stronger saturation.
            % - Approaches 0.5 for small mu and saturates for large mu.
            D = (1 - tanh(alpha * mu)) / 2;
        
        % --- Spatiotemporal Dispersion Functions ---
        case 'multiplicative'
            % MULTIPLICATIVE DISPERSION: D_{x,t}(x,t) = Dx(x) * Dt(t)
            % - Separate dispersion effects for x and t, combined multiplicatively.
            D = A_dispersion_function('exponential', mu(:,1), alpha) .* ...
                A_dispersion_function('inverse_power_law', mu(:,2), alpha);
        
        case 'bivariate'
            % BIVARIATE DISPERSION: D_{x,t}(x,t) = exp(-alpha*x^2 - alpha*t^2 - beta*x*t)
            % - Cross-term beta*x*t introduces interaction between space and time.
            % - Controls how x and t influence each other’s decay.
            D = exp(-alpha * mu(:,1).^2 - alpha * mu(:,2).^2 - beta * mu(:,1) .* mu(:,2));
        
        case 'gaussian_envelope'
            % GAUSSIAN WAVE ENVELOPE: D_{x,t}(x,t) = exp(-(x^2 + t^2) / (2 * sigma^2))
            % - Spatial-temporal envelope that modulates wave amplitude.
            % - Similar to a Gaussian filter in image processing.
            D = exp(-((mu(:,1).^2 + mu(:,2).^2) / (2 * sigma^2)));
        
        case 'power_law'
            % SPATIOTEMPORAL POWER LAW DISPERSION: 
            % D_{x,t}(x,t) = (1 + alpha*x^2 + alpha*t^2)^(-gamma)
            % - Smooth decay in both x and t directions.
            % - Gamma controls how fast the decay occurs.
            D = (1 + alpha * mu(:,1).^2 + alpha * mu(:,2).^2).^(-gamma);
        
        otherwise
            error('Unknown dispersion type: %s', type);
    end
end
