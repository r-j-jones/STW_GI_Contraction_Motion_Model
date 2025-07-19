# Sinusoidal Time-Wave (STW) Models Documentation

This documentation provides an overview of Sinusoidal Time-Wave (STW) models used for nonlinear regression. Each model defines a sinusoidal function with varying complexity and parameters. The models now support flexible input formats with vector or meshgrid inputs and return matrix outputs.

## Models Overview

### 1. `simple_STW_model`

The `simple_STW_model` defines a basic sinusoidal function for nonlinear regression.

#### Function Definition

```matlab
function Y = simple_STW_model(params, x, t)          % Vector inputs
function Y = simple_STW_model(params, X, T)          % Meshgrid inputs
```

#### Model Definition

$$ Y = A \cdot \sin(k \cdot x + b \cdot t + o) + c $$

#### Parameters

- `params`: A vector of parameters `[A, k, b, o, c]`
  - `A`: Amplitude
  - `k`: Wave number (frequency along x) [spatial freq]
  - `b`: Frequency along t [temporal/phase angle freq]
  - `o`: Phase shift
  - `c`: Constant offset

#### Input Options

**Option 1: Vector inputs**
- `x`: Vector of spatial values (length nx)
- `t`: Vector of temporal values (length nt)

**Option 2: Meshgrid inputs**
- `X`: Meshgrid of x-values (size [nt, nx])
- `T`: Meshgrid of t-values (size [nt, nx])

#### Output

- `Y`: The model output matrix (size [nt, nx])
  - `Y(i,j)` = output at time `t(i)` and position `x(j)`
  - `Y(i,:)` = spatial profile at time `t(i)`
  - `Y(:,j)` = temporal evolution at position `x(j)`

#### Example Usage

```matlab
% Vector input example
x = linspace(0, 10, 50);
t = linspace(0, 5, 30);
params = [2.0, 1.5, 2.0, pi/4, 0.1];  % [A, k, b, o, c]
Y = simple_STW_model(params, x, t);    % Returns [30, 50] matrix

% Meshgrid input example
[X, T] = meshgrid(x, t);
Y = simple_STW_model(params, X, T);    % Same result

% For fitting with nlinfit (requires conversion to vector format)
beta0 = [1, 2, 3, 0, 0];  % Initial parameter guesses
% Convert matrix data to vector format for fitting
wrapper = @(params, data) simple_STW_model(params, data(:,1), data(:,2));
params_fit = nlinfit(data_matrix, y_vector, wrapper, beta0);
```

### 2. `freqdisp_STW_model`

The `freqdisp_STW_model` defines a sinusoidal function that includes higher-order "frequency dispersion" terms. It now uses a reduced model by default with improved parameterization.

#### Function Signatures

```matlab
function Y = freqdisp_STW_model(params, x, t)        % Vector inputs
function Y = freqdisp_STW_model(params, X, T)        % Meshgrid inputs
```

#### Model Definition (Reduced Model - Default)

$$ Y = A \cdot \sin((k_0 + k_1 \cdot x) \cdot x + (f_0 + f_1 \cdot t) \cdot t + \mu \cdot x \cdot t + \phi_0) + c $$

This simplified model reduces the cross-terms to a single coupling parameter μ, making it more tractable while maintaining the essential frequency dispersion behavior.

#### Parameters (Reduced Model)

- `params`: A vector of parameters `[A, k_0, k_1, f_0, f_1, μ, φ_0, c]` (8 parameters)
  - `A`: Amplitude
  - `k_0`: Base wave number
  - `k_1`: Linear wave number coefficient  
  - `f_0`: Base frequency
  - `f_1`: Linear frequency coefficient
  - `μ`: Cross-term coupling coefficient
  - `φ_0`: Phase shift
  - `c`: Constant offset

#### Input Options

- **Option 1: Vector inputs**
  - `x`: Vector of spatial values (length nx)
  - `t`: Vector of temporal values (length nt)

- **Option 2: Meshgrid inputs**
  - `X`: Meshgrid of x-values (size [nt, nx])
  - `T`: Meshgrid of t-values (size [nt, nx])

#### Output

- `Y`: The model output matrix (size [nt, nx])

#### Example Usage

```matlab
% Vector input example
x = linspace(0, 8, 100);
t = linspace(0, 4, 60);
params = [1.8, 1.2, 0.3, 2.2, 0.2, 0.4, pi/6, 0.0];  % [A, k0, k1, f0, f1, mu, phi0, c]
Y = freqdisp_STW_model(params, x, t);    % Returns [60, 100] matrix

% Meshgrid input example
[X, T] = meshgrid(x, t);
Y = freqdisp_STW_model(params, X, T);    % Same result

% Visualization
figure;
imagesc(x, t, Y);
xlabel('X'); ylabel('T'); title('Freqdisp STW Model');
colorbar; axis xy;
```

### 3. `custom_freqdisp_STW_model`

The `custom_freqdisp_STW_model` is a customizable version of the frequency-dispersed STW model that provides detailed parameter feedback and supports both reduced and expanded model variants.

#### Function Signature

```matlab
function Y = custom_freqdisp_STW_model(params, X, model_type)
```

#### Model Variants

**Reduced Model (Default - 8 parameters):**

```matlab
Y = A * sin((k0 + k1*x)*x + (b0 + b1*t)*t + mu*x*t + o) + c
```

**Expanded Model (9 parameters):**

```matlab
Y = A * sin((k0 + k1*x + k2*t)*x + (b0 + b1*x + b2*t)*t + o) + c
```

#### Custom Model Parameters

**Reduced Model Parameters (8):**

- `[A, k0, k1, b0, b1, mu, o, c]`
  - `A`: Amplitude
  - `k0`: Base wave number
  - `k1`: Linear wave number coefficient  
  - `b0`: Base frequency
  - `b1`: Linear frequency coefficient
  - `mu`: Cross-term coupling coefficient
  - `o`: Phase shift
  - `c`: Constant offset

**Expanded Model Parameters (9):**

- `[A, k0, k1, k2, b0, b1, b2, o, c]`
  - `A`: Amplitude
  - `k0`: Base wave number
  - `k1`: Linear term for wave number variation with x
  - `k2`: Linear term for wave number variation with t
  - `b0`: Base frequency along t
  - `b1`: Linear term for frequency variation with x
  - `b2`: Linear term for frequency variation with t
  - `o`: Phase shift
  - `c`: Constant offset

#### Usage Examples

```matlab
% Using reduced model (default)
params_reduced = [1.8, 1.2, 0.3, 2.2, 0.2, 0.4, pi/6, 0.0];
Y_reduced = custom_freqdisp_STW_model(params_reduced, X);

% Using expanded model
params_expanded = [1.8, 1.2, 0.3, 0.1, 2.2, 0.2, 0.15, pi/6, 0.0];
Y_expanded = custom_freqdisp_STW_model(params_expanded, X, 'expanded');

% With parameter feedback
Y = custom_freqdisp_STW_model(params_reduced, X, 'reduced');
% Outputs parameter values to console for verification
```

### 4. `A_dispersion_function`

The `A_dispersion_function` provides various amplitude dispersion functions that can be applied to STW model outputs to simulate wave attenuation, enhancement, or localization effects.

#### Dispersion Function Interface

```matlab
function D = A_dispersion_function(type, mu, alpha, beta, gamma, mu0, sigma)
```

#### Supported Dispersion Types

**Univariate Dispersion Functions:**

- `'linear'`: Linear decay with distance
- `'exponential'`: Exponential decay  
- `'inverse_power_law'`: Smooth power-law decay
- `'quadratic'`: Quadratic decay
- `'gaussian'`: Gaussian decay
- `'gaussian_bump'`: Localized Gaussian enhancement
- `'logarithmic'`: Logarithmic decay
- `'sigmoid'`: Sigmoid transition
- `'tanh'`: Hyperbolic tangent decay

**Bivariate (Spatiotemporal) Dispersion Functions:**

- `'multiplicative'`: Separable x and t dispersion
- `'bivariate'`: Coupled spatiotemporal dispersion
- `'gaussian_envelope'`: Gaussian wave envelope
- `'power_law'`: Spatiotemporal power-law decay

#### Usage with STW Models

```matlab
% Generate STW model output
x = linspace(0, 8, 100);
t = linspace(0, 4, 60);
Y_original = simple_STW_model(params, x, t);

% Apply spatial dispersion
alpha = 0.3;
D_spatial = A_dispersion_function('exponential', x, alpha);
Y_dispersed = Y_original .* D_spatial;  % Apply to all time steps

% Apply localized enhancement
x_center = 4.0;
sigma_bump = 1.5;
D_bump = A_dispersion_function('gaussian_bump', x, alpha, [], [], x_center, sigma_bump);
Y_enhanced = Y_original .* D_bump;
```

### 5. Interactive Tools and Examples

#### Available Scripts

- **`example_updated_STW.m`**: Comprehensive demonstration of vector/meshgrid inputs
- **`example_A_dispersion.m`**: Complete dispersion function examples
- **`quick_A_dispersion_demo.m`**: Focused dispersion demonstration
- **`test_STW_models.m`**: Testing and validation script
- **`interactive_STW_visualizer.m`**: GUI tool for interactive exploration

#### Key Features

- **Flexible Input Formats**: Vector inputs `(x, t)` or meshgrid inputs `(X, T)`
- **Matrix Outputs**: Returns `[nt, nx]` matrices for easy visualization
- **Amplitude Dispersion**: Apply various dispersion effects to model outputs
- **Interactive Visualization**: Real-time parameter adjustment with sliders
- **Multiple Model Types**: Simple and frequency-dispersed models

## Conclusion

The updated STW models provide enhanced flexibility and functionality:

1. **`simple_STW_model`**: Basic sinusoidal model with flexible input/output
2. **`freqdisp_STW_model`**: Advanced model with frequency dispersion (reduced parameterization)
3. **`custom_freqdisp_STW_model`**: Customizable variant with parameter feedback and model selection
4. **`A_dispersion_function`**: Comprehensive amplitude dispersion effects
5. **Interactive Tools**: Scripts and GUI for exploration and analysis

The models now support modern MATLAB workflows with intuitive vector inputs and matrix outputs, making them ideal for spatiotemporal analysis and visualization.
