#include <iostream>
#include <vector>
#include <string>
#include <cmath>
#include <fstream>
#include <iomanip>
#include <algorithm>
#include <sstream>

// WDEL Formula 2: Aminpour et al. (2023) dimensionless approach
double wdel_aminpour2023(double d, double Dn, double U, double h, double P_kPa, double RH, double SR) {
    // Constants
    const double g = 9.81;   // acceleration due to gravity (m/s^2)
    const double rho = 1000; // water density (kg/m^3)
    
    // Convert pressure from kPa to Pa
    double P_Pa = P_kPa * 1000;
    
    // Dimensionless parameters from Aminpour et al. (2023)
    double pi1 = d / Dn;                                    // diameter ratio
    double pi2 = RH;                                        // relative humidity
    double pi3 = U / sqrt(g * h);                           // Froude number
    double pi4 = SR * sqrt(rho / pow(rho * g * Dn, 3));     // solar radiation parameter
    double pi5 = P_Pa / (rho * g * Dn);                     // pressure parameter
    
    // Placeholder functional relationship (using same coefficients as MATLAB version)
    double loss = 0.1 * pi1 + 0.05 * pi2 + 0.2 * pi3 + 0.15 * pi4 + 0.3 * pi5;
    
    return loss; // Return as fraction (0-1)
}

// Test data structure
struct TestData {
    std::string test_id;
    double D_mm;        // Main nozzle diameter (mm)
    double d_mm;        // Secondary nozzle diameter (mm)
    double p_kPa;       // Operating pressure (kPa)
    double V_ms;        // Arithmetic mean wind velocity (m/s)
    double Vp_ms;       // Vectorial mean wind velocity (m/s)
    double T_C;         // Temperature (°C)
    double HR_pct;      // Relative humidity (%)
    double ID_mmh;      // Irrigation depth (mm/h)
    double WDEL_pct;    // Measured WDEL (%)
    double CUC_pct;     // Christiansen's uniformity coefficient (%)
};

// Performance metrics structure
struct PerformanceMetrics {
    double mae;         // Mean Absolute Error
    double rmse;        // Root Mean Square Error
    double mbe;         // Mean Bias Error
    double correlation; // Correlation coefficient
    double r_squared;   // Coefficient of determination
};

// Function to split string by delimiter
std::vector<std::string> split(const std::string& str, char delimiter) {
    std::vector<std::string> tokens;
    std::stringstream ss(str);
    std::string token;
    while (std::getline(ss, token, delimiter)) {
        tokens.push_back(token);
    }
    return tokens;
}

// Function to load test data from file
std::vector<TestData> loadTestData(const std::string& filename) {
    std::vector<TestData> data;
    std::ifstream file(filename);
    
    if (!file.is_open()) {
        std::cerr << "Error: Could not open data file: " << filename << std::endl;
        return data;
    }
    
    std::string line;
    while (std::getline(file, line)) {
        // Skip comment lines and empty lines
        if (line.empty() || line[0] == '#') {
            continue;
        }
        
        // Parse CSV line
        std::vector<std::string> tokens = split(line, ',');
        if (tokens.size() >= 11) {
            TestData test;
            test.test_id = tokens[0];
            test.D_mm = std::stod(tokens[1]);
            test.d_mm = std::stod(tokens[2]);
            test.p_kPa = std::stod(tokens[3]);
            test.V_ms = std::stod(tokens[4]);
            test.Vp_ms = std::stod(tokens[5]);
            test.T_C = std::stod(tokens[6]);
            test.HR_pct = std::stod(tokens[7]);
            test.ID_mmh = std::stod(tokens[8]);
            test.WDEL_pct = std::stod(tokens[9]);
            test.CUC_pct = std::stod(tokens[10]);
            
            data.push_back(test);
        }
    }
    
    file.close();
    std::cout << "Loaded " << data.size() << " test cases from " << filename << std::endl;
    return data;
}

// Calculate performance metrics
PerformanceMetrics calculateMetrics(const std::vector<double>& measured, const std::vector<double>& predicted) {
    PerformanceMetrics metrics;
    int n = measured.size();
    
    // Calculate errors
    std::vector<double> errors(n);
    for (int i = 0; i < n; i++) {
        errors[i] = predicted[i] - measured[i];
    }
    
    // Mean Absolute Error
    double sum_abs_errors = 0;
    for (double error : errors) {
        sum_abs_errors += std::abs(error);
    }
    metrics.mae = sum_abs_errors / n;
    
    // Root Mean Square Error
    double sum_squared_errors = 0;
    for (double error : errors) {
        sum_squared_errors += error * error;
    }
    metrics.rmse = std::sqrt(sum_squared_errors / n);
    
    // Mean Bias Error
    double sum_errors = 0;
    for (double error : errors) {
        sum_errors += error;
    }
    metrics.mbe = sum_errors / n;
    
    // Correlation coefficient
    double mean_measured = 0, mean_predicted = 0;
    for (int i = 0; i < n; i++) {
        mean_measured += measured[i];
        mean_predicted += predicted[i];
    }
    mean_measured /= n;
    mean_predicted /= n;
    
    double numerator = 0, denom_measured = 0, denom_predicted = 0;
    for (int i = 0; i < n; i++) {
        double diff_measured = measured[i] - mean_measured;
        double diff_predicted = predicted[i] - mean_predicted;
        numerator += diff_measured * diff_predicted;
        denom_measured += diff_measured * diff_measured;
        denom_predicted += diff_predicted * diff_predicted;
    }
    metrics.correlation = numerator / std::sqrt(denom_measured * denom_predicted);
    
    // Coefficient of determination (R²)
    double ss_res = sum_squared_errors;
    double ss_tot = 0;
    for (int i = 0; i < n; i++) {
        double diff = measured[i] - mean_measured;
        ss_tot += diff * diff;
    }
    metrics.r_squared = 1 - (ss_res / ss_tot);
    
    return metrics;
}

int main() {
    // Load test data from external file
    std::string data_file = "../data/experimental_data.txt";
    std::vector<TestData> test_data = loadTestData(data_file);
    
    if (test_data.empty()) {
        std::cerr << "No test data loaded. Exiting." << std::endl;
        return 1;
    }
    
    int n_tests = test_data.size();
    std::vector<double> measured_wdel(n_tests);
    std::vector<double> predicted_wdel(n_tests);
    
    std::cout << "Evaluation of WDEL Formula 2 (Aminpour et al. 2023) - C++ Version\n";
    std::cout << "Using experimental data from Sanchez et al. (2011)\n";
    std::cout << "=======================================================\n\n";
    
    // Process each test case
    for (int i = 0; i < n_tests; i++) {
        TestData& test = test_data[i];
        
        // Convert units for formula input
        double Dn = test.D_mm / 1000.0;        // Main nozzle diameter (m)
        double d = test.d_mm / 1000.0;         // Secondary nozzle diameter (m)
        double U = test.V_ms;                  // Wind speed (m/s)
        double h = 1.0;                        // Assume sprinkler height of 1.0 m
        double P_kPa = test.p_kPa;             // Pressure (kPa)
        double RH = test.HR_pct / 100.0;       // Relative humidity (fraction)
        
        // Estimate solar radiation based on temperature
        double SR = 200 + (test.T_C - 5) * 20;
        SR = std::max(200.0, std::min(800.0, SR));
        
        // Calculate WDEL using formula
        double loss_fraction = wdel_aminpour2023(d, Dn, U, h, P_kPa, RH, SR);
        double predicted_pct = loss_fraction * 100;
        
        // Store results
        measured_wdel[i] = test.WDEL_pct;
        predicted_wdel[i] = predicted_pct;
        
        // Display results
        std::cout << "Test " << test.test_id << ":\n";
        std::cout << "  Inputs: D=" << std::fixed << std::setprecision(1) << test.D_mm 
                  << "mm, d=" << test.d_mm << "mm, p=" << std::setprecision(0) 
                  << test.p_kPa << "kPa, V=" << std::setprecision(1) << test.V_ms 
                  << "m/s, T=" << std::setprecision(0) << test.T_C << "°C, HR=" 
                  << test.HR_pct << "%\n";
        std::cout << "  Measured WDEL: " << std::setprecision(1) << test.WDEL_pct << "%\n";
        std::cout << "  Predicted WDEL: " << predicted_pct << "%\n";
        std::cout << "  Error: " << std::abs(predicted_pct - test.WDEL_pct) << "%\n\n";
    }
    
    // Calculate performance metrics
    PerformanceMetrics metrics = calculateMetrics(measured_wdel, predicted_wdel);
    
    // Display performance metrics
    std::cout << "Performance Metrics:\n";
    std::cout << "===================\n";
    std::cout << std::fixed << std::setprecision(2);
    std::cout << "Mean Absolute Error (MAE): " << metrics.mae << "%\n";
    std::cout << "Root Mean Square Error (RMSE): " << metrics.rmse << "%\n";
    std::cout << "Mean Bias Error (MBE): " << metrics.mbe << "%\n";
    std::cout << std::setprecision(3);
    std::cout << "Correlation Coefficient (r): " << metrics.correlation << "\n";
    std::cout << "Coefficient of Determination (R²): " << metrics.r_squared << "\n";
    
    // Save results to file
    std::ofstream outfile("wdel_formula2_evaluation_results_cpp.txt");
    outfile << "WDEL Formula 2 (Aminpour et al. 2023) Evaluation Results - C++ Version\n";
    outfile << "Using experimental data from Sanchez et al. (2011)\n";
    outfile << "Data loaded from: " << data_file << "\n";
    outfile << "======================================================\n\n";
    
    outfile << "Test Results:\n";
    outfile << std::setw(12) << "Test ID" << std::setw(10) << "Measured" 
            << std::setw(10) << "Predicted" << std::setw(10) << "Error" << "\n";
    outfile << std::setw(12) << "--------" << std::setw(10) << "--------" 
            << std::setw(10) << "---------" << std::setw(10) << "-----" << "\n";
    
    for (int i = 0; i < n_tests; i++) {
        double error = predicted_wdel[i] - measured_wdel[i];
        outfile << std::setw(12) << test_data[i].test_id 
                << std::setw(10) << std::fixed << std::setprecision(1) << measured_wdel[i]
                << std::setw(10) << predicted_wdel[i] 
                << std::setw(10) << error << "\n";
    }
    
    outfile << "\nPerformance Metrics:\n";
    outfile << "===================\n";
    outfile << std::fixed << std::setprecision(2);
    outfile << "Mean Absolute Error (MAE): " << metrics.mae << "%\n";
    outfile << "Root Mean Square Error (RMSE): " << metrics.rmse << "%\n";
    outfile << "Mean Bias Error (MBE): " << metrics.mbe << "%\n";
    outfile << std::setprecision(3);
    outfile << "Correlation Coefficient (r): " << metrics.correlation << "\n";
    outfile << "Coefficient of Determination (R²): " << metrics.r_squared << "\n";
    
    outfile.close();
    
    std::cout << "\nEvaluation complete. Results saved to \"wdel_formula2_evaluation_results_cpp.txt\"\n";
    
    return 0;
}
