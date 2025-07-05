% Simplified WDEL Formula
% MATLAB/Octave implementation based on dimensionless analysis

function loss = wdel_formula2(d, Dn, U, h, P_kPa)
    % Constants
    g = 9.81;   % acceleration due to gravity (m/s^2)
    rho = 1000; % water density (kg/m^3)

    % Convert pressure from kPa to Pa
    P_Pa = P_kPa * 1000;

    % Dimensionless parameters
    pi1 = d / Dn;
    pi3 = U / sqrt(g * h);
    pi5 = P_Pa / (rho * g * Dn);

    % Placeholder for the actual formula relationship f(...)
    % Using a simple linear combination for demonstration purposes
    loss = 0.1 * pi1 + 0.2 * pi3 + 0.3 * pi5;

    fprintf('WDEL (dimensionless): %f\n', loss);
    fprintf('WDEL (%%): %f\n', loss * 100);
end

% Example usage:
% aux_nozzle_diameter = 0.0;   % m (d)
% main_nozzle_diameter = 0.008;  % m (Dn)
% wind_speed = 3.5;         % m/s (U)
% sprinkler_height = 1.0;   % m (h)
% pressure_kPa = 300.0;        % kPa (P)
% wdel_formula2(aux_nozzle_diameter, main_nozzle_diameter, wind_speed, sprinkler_height, pressure_kPa);
