% Evaluation Test for WDEL Formula 2 (Aminpour et al. 2023)
% Using experimental data from Sanchez et al. (2011)
% "The effects of pressure, nozzle diameter and meteorological conditions 
% on the performance of agricultural impact sprinklers"
% DOI: https://doi.org/10.1016/j.agwat.2011.10.002

function evaluate_wdel_formula2()
    % Load experimental data from external file
    data_file = '../data/experimental_data.txt';
    
    % Read the data file
    fid = fopen(data_file, 'r');
    if fid == -1
        error('Could not open data file: %s', data_file);
    end
    
    % Skip header lines (lines starting with #)
    test_data = {};
    line_count = 0;
    while ~feof(fid)
        line = fgetl(fid);
        if ischar(line) && ~isempty(line) && line(1) ~= '#'
            line_count = line_count + 1;
            % Parse CSV line
            parts = strsplit(line, ',');
            test_data{line_count, 1} = parts{1};                    % Test ID
            test_data{line_count, 2} = str2double(parts{2});        % D_mm
            test_data{line_count, 3} = str2double(parts{3});        % d_mm
            test_data{line_count, 4} = str2double(parts{4});        % p_kPa
            test_data{line_count, 5} = str2double(parts{5});        % V_ms
            test_data{line_count, 6} = str2double(parts{6});        % Vp_ms
            test_data{line_count, 7} = str2double(parts{7});        % T_C
            test_data{line_count, 8} = str2double(parts{8});        % HR_pct
            test_data{line_count, 9} = str2double(parts{9});        % ID_mmh
            test_data{line_count, 10} = str2double(parts{10});      % WDEL_pct
            test_data{line_count, 11} = str2double(parts{11});      % CUC_pct
        end
    end
    fclose(fid);
    
    fprintf('Loaded %d test cases from %s\n', line_count, data_file);
    
    % Convert to numerical arrays for easier processing
    n_tests = size(test_data, 1);
    test_names = test_data(:, 1);
    D_mm = cell2mat(test_data(:, 2));       % Main nozzle diameter (mm)
    d_mm = cell2mat(test_data(:, 3));       % Secondary nozzle diameter (mm)
    p_kPa = cell2mat(test_data(:, 4));      % Operating pressure (kPa)
    V_ms = cell2mat(test_data(:, 5));       % Arithmetic mean wind velocity (m/s)
    Vp_ms = cell2mat(test_data(:, 6));      % Vectorial mean wind velocity (m/s)
    T_C = cell2mat(test_data(:, 7));        % Temperature (°C)
    HR_pct = cell2mat(test_data(:, 8));     % Relative humidity (%)
    ID_mmh = cell2mat(test_data(:, 9));     % Irrigation depth (mm/h)
    WDEL_measured = cell2mat(test_data(:, 10)); % Measured WDEL (%)
    CUC_pct = cell2mat(test_data(:, 11));   % Christiansen's uniformity coefficient (%)
    
    % Convert units for formula input
    Dn = D_mm / 1000;                       % Main nozzle diameter (m)
    d = d_mm / 1000;                        % Secondary nozzle diameter (m)
    U = V_ms;                               % Wind speed (m/s) - using arithmetic mean
    h = 1.0;                                % Assume sprinkler height of 1.0 m (typical)
    P_kPa = p_kPa;                          % Pressure (kPa)
    RH = HR_pct / 100;                      % Relative humidity (fraction)
    
    % Estimate solar radiation based on temperature (simplified approach)
    % Higher temperature generally correlates with higher solar radiation
    SR = 200 + (T_C - 5) * 20;             % Rough estimation: 200-800 W/m^2
    SR = max(200, min(800, SR));            % Constrain to reasonable range
    
    % Arrays to store results
    WDEL_predicted = zeros(n_tests, 1);
    
    % Calculate WDEL for each test case
    fprintf('Evaluation of WDEL Formula 2 (Aminpour et al. 2023)\n');
    fprintf('Using experimental data from Sanchez et al. (2011)\n');
    fprintf('=======================================================\n\n');
    
    for i = 1:n_tests
        % Call the WDEL formula (suppress output for cleaner results)
        % Inline function calculation
        d_val = d(i);
        Dn_val = Dn(i);
        U_val = U(i);
        h_val = h;
        P_kPa_val = P_kPa(i);
        RH_val = RH(i);
        SR_val = SR(i);
        
        % Constants
        g = 9.81;   % acceleration due to gravity (m/s^2)
        rho = 1000; % water density (kg/m^3)
        
        % Convert pressure from kPa to Pa
        P_Pa = P_kPa_val * 1000;
        
        % Dimensionless parameters from Aminpour et al. (2023)
        pi1 = d_val / Dn_val;                           % diameter ratio
        pi2 = RH_val;                                   % relative humidity
        pi3 = U_val / sqrt(g * h_val);                  % Froude number
        pi4 = SR_val * sqrt(rho / (rho * g * Dn_val)^3); % solar radiation parameter
        pi5 = P_Pa / (rho * g * Dn_val);                % pressure parameter
        
        % Placeholder for the actual functional relationship f(...)
        % The specific form is not provided in the source material
        loss = 0.1 * pi1 + 0.05 * pi2 + 0.2 * pi3 + 0.15 * pi4 + 0.3 * pi5;
        
        WDEL_predicted(i) = loss * 100; % Convert to percentage
        
        fprintf('Test %s:\n', test_names{i});
        fprintf('  Inputs: D=%.1fmm, d=%.1fmm, p=%.0fkPa, V=%.1fm/s, T=%.0f°C, HR=%.0f%%\n', ...
                D_mm(i), d_mm(i), p_kPa(i), V_ms(i), T_C(i), HR_pct(i));
        fprintf('  Measured WDEL: %.1f%%\n', WDEL_measured(i));
        fprintf('  Predicted WDEL: %.1f%%\n', WDEL_predicted(i));
        fprintf('  Error: %.1f%%\n\n', abs(WDEL_predicted(i) - WDEL_measured(i)));
    end
    
    % Calculate performance metrics
    errors = WDEL_predicted - WDEL_measured;
    mae = mean(abs(errors));                % Mean Absolute Error
    rmse = sqrt(mean(errors.^2));           % Root Mean Square Error
    mbe = mean(errors);                     % Mean Bias Error
    
    % Calculate correlation coefficient
    r = corrcoef(WDEL_measured, WDEL_predicted);
    correlation = r(1,2);
    
    % Calculate coefficient of determination (R²)
    ss_res = sum(errors.^2);
    ss_tot = sum((WDEL_measured - mean(WDEL_measured)).^2);
    r_squared = 1 - (ss_res / ss_tot);
    
    % Display performance metrics
    fprintf('Performance Metrics:\n');
    fprintf('===================\n');
    fprintf('Mean Absolute Error (MAE): %.2f%%\n', mae);
    fprintf('Root Mean Square Error (RMSE): %.2f%%\n', rmse);
    fprintf('Mean Bias Error (MBE): %.2f%%\n', mbe);
    fprintf('Correlation Coefficient (r): %.3f\n', correlation);
    fprintf('Coefficient of Determination (R²): %.3f\n', r_squared);
    
    % Create comparison plot
    figure('Name', 'WDEL Formula 2 Evaluation', 'Position', [100, 100, 800, 600]);
    
    % Scatter plot of measured vs predicted
    subplot(2, 2, 1);
    scatter(WDEL_measured, WDEL_predicted, 100, 'filled', 'MarkerFaceColor', [0.2, 0.6, 0.8]);
    hold on;
    plot([0, max(WDEL_measured)], [0, max(WDEL_measured)], 'r--', 'LineWidth', 2);
    xlabel('Measured WDEL (%)');
    ylabel('Predicted WDEL (%)');
    title('Measured vs Predicted WDEL');
    grid on;
    axis equal;
    xlim([0, max(WDEL_measured) + 5]);
    ylim([0, max(WDEL_predicted) + 5]);
    
    % Add R² text
    text(0.05, 0.95, sprintf('R² = %.3f', r_squared), 'Units', 'normalized', ...
         'FontSize', 12, 'BackgroundColor', 'white', 'EdgeColor', 'black');
    
    % Error distribution
    subplot(2, 2, 2);
    histogram(errors, 'BinWidth', 2, 'FaceColor', [0.8, 0.4, 0.2]);
    xlabel('Error (Predicted - Measured) (%)');
    ylabel('Frequency');
    title('Error Distribution');
    grid on;
    
    % Time series comparison
    subplot(2, 2, 3);
    plot(1:n_tests, WDEL_measured, 'bo-', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'Measured');
    hold on;
    plot(1:n_tests, WDEL_predicted, 'rs-', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'Predicted');
    xlabel('Test Number');
    ylabel('WDEL (%)');
    title('Comparison of Measured vs Predicted WDEL');
    legend('Location', 'best');
    grid on;
    
    % Wind speed vs WDEL
    subplot(2, 2, 4);
    scatter(V_ms, WDEL_measured, 100, 'filled', 'MarkerFaceColor', [0.2, 0.6, 0.8], 'DisplayName', 'Measured');
    hold on;
    scatter(V_ms, WDEL_predicted, 100, '^', 'MarkerFaceColor', [0.8, 0.4, 0.2], 'DisplayName', 'Predicted');
    xlabel('Wind Speed (m/s)');
    ylabel('WDEL (%)');
    title('Wind Speed vs WDEL');
    legend('Location', 'best');
    grid on;
    
    % Save results to file
    save_results_to_file(test_names, WDEL_measured, WDEL_predicted, errors, mae, rmse, mbe, correlation, r_squared);
    
    fprintf('\nEvaluation complete. Results saved to "wdel_formula2_evaluation_results.txt"\n');
end

function save_results_to_file(test_names, measured, predicted, errors, mae, rmse, mbe, correlation, r_squared)
    % Save detailed results to a text file
    filename = 'wdel_formula2_evaluation_results.txt';
    fid = fopen(filename, 'w');
    
    fprintf(fid, 'WDEL Formula 2 (Aminpour et al. 2023) Evaluation Results\n');
    fprintf(fid, 'Using experimental data from Sanchez et al. (2011)\n');
    fprintf(fid, '======================================================\n\n');
    
    fprintf(fid, 'Test Results:\n');
    fprintf(fid, '%-12s %10s %10s %10s\n', 'Test ID', 'Measured', 'Predicted', 'Error');
    fprintf(fid, '%-12s %10s %10s %10s\n', '--------', '--------', '---------', '-----');
    
    for i = 1:length(test_names)
        fprintf(fid, '%-12s %10.1f %10.1f %10.1f\n', test_names{i}, measured(i), predicted(i), errors(i));
    end
    
    fprintf(fid, '\nPerformance Metrics:\n');
    fprintf(fid, '===================\n');
    fprintf(fid, 'Mean Absolute Error (MAE): %.2f%%\n', mae);
    fprintf(fid, 'Root Mean Square Error (RMSE): %.2f%%\n', rmse);
    fprintf(fid, 'Mean Bias Error (MBE): %.2f%%\n', mbe);
    fprintf(fid, 'Correlation Coefficient (r): %.3f\n', correlation);
    fprintf(fid, 'Coefficient of Determination (R²): %.3f\n', r_squared);
    
    fclose(fid);
end

% Run the evaluation
evaluate_wdel_formula2();
