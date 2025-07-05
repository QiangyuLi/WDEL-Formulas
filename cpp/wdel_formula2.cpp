// C++ implementation of the simplified WDEL formula
#include <iostream>
#include <cmath>

// Constants
const double g = 9.81; // acceleration due to gravity (m/s^2)
const double rho = 1000; // water density (kg/m^3)

// Function to calculate WDEL based on the simplified dimensionless parameters
// Note: The actual relationship f(...) is not specified in the provided text.
// This implementation uses a placeholder linear combination.
double wdel_formula2(double d, double Dn, double U, double h, double P_kPa) {
    // Convert pressure from kPa to Pa
    double P_Pa = P_kPa * 1000.0;

    // Dimensionless parameters
    double pi1 = d / Dn;
    double pi3 = U / std::sqrt(g * h);
    double pi5 = P_Pa / (rho * g * Dn);

    // Placeholder for the actual formula - assuming a simple linear combination for demonstration
    double wdel = 0.1 * pi1 + 0.2 * pi3 + 0.3 * pi5;

    return wdel;
}

int main() {
    // Example usage with placeholder values
    double aux_nozzle_diameter = 0.0;   // m (d)
    double main_nozzle_diameter = 0.008; // m (Dn)
    double wind_speed = 3.5;             // m/s (U)
    double sprinkler_height = 1.0;       // m (h)
    double pressure_kPa = 300.0;         // kPa (P)

    double loss = wdel_formula2(aux_nozzle_diameter, main_nozzle_diameter, wind_speed, sprinkler_height, pressure_kPa);

    std::cout << "WDEL (dimensionless): " << loss << std::endl;
    std::cout << "WDEL (%): " << loss * 100 << std::endl;

    return 0;
}
