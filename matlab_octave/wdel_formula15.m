% WDEL Equation 15
% MATLAB/Octave implementation
% WDEL = 20.3 + 0.214 * U^2 - 2.29e-3 * RH^2

function loss = wdel_formula15(U, RH)
    loss = 20.3 + 0.214 * U.^2 - 2.29e-3 * RH.^2;

    fprintf('WDEL (%%): %f\n', loss);
end

% Example usage:
% wind_speed = 3.5;      % m/s (U)
% relative_humidity = 50; % %% (RH)
% wdel_formula15(wind_speed, relative_humidity);
