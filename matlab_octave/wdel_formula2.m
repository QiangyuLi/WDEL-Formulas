% Dimensionless WDEL Formula
% MATLAB/Octave implementation based on dimensional analysis
% From: Aminpour et al. (2023). Estimation of wind drift and evaporation losses 
% of sprinkler irrigation systems using dimensional analysis. 
% Agricultural Water Management, 286, 108518.
% DOI: https://doi.org/10.1016/j.agwat.2023.108518

function loss = wdel_aminpour2023(d, Dn, U, h, P_kPa, RH, SR)
    % Constants
    g = 9.81;   % acceleration due to gravity (m/s^2)
    rho = 1000; % water density (kg/m^3)

    % Convert pressure from kPa to Pa
    P_Pa = P_kPa * 1000;

    % Dimensionless parameters from Aminpour et al. (2023)
    pi1 = d / Dn;                           % diameter ratio
    pi2 = RH;                               % relative humidity
    pi3 = U / sqrt(g * h);                  % Froude number
    pi4 = SR * sqrt(rho / (rho * g * Dn)^3); % solar radiation parameter
    pi5 = P_Pa / (rho * g * Dn);            % pressure parameter

    % Placeholder for the actual functional relationship f(...)
    % The specific form is not provided in the source material
    loss = 0.1 * pi1 + 0.05 * pi2 + 0.2 * pi3 + 0.15 * pi4 + 0.3 * pi5;

    fprintf('WDEL (dimensionless): %f\n', loss);
    fprintf('WDEL (%%): %f\n', loss * 100);
end

% Example usage:
% aux_nozzle_diameter = 0.0;     % m (d)
% main_nozzle_diameter = 0.008;  % m (Dn)
% wind_speed = 3.5;              % m/s (U)
% sprinkler_height = 1.0;        % m (h)
% pressure_kPa = 300.0;          % kPa (P)
% relative_humidity = 60;        % % (RH)
% solar_radiation = 800;         % W/m^2 (SR)
% wdel_aminpour2023(aux_nozzle_diameter, main_nozzle_diameter, wind_speed, sprinkler_height, pressure_kPa, relative_humidity, solar_radiation);
