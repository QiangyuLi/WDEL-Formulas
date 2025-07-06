// Consolidated C++ implementations of WDEL equations E1 to E29
// Based on Playán et al. (2005): Day and night wind drift and evaporation losses in sprinkler solid-sets and moving laterals.
// DOI: https://doi.org/10.1016/j.agwat.2005.01.015

#include <iostream>
#include <cmath>

// Solid-set, All (Eq. E15)
double wdel_E15(double U, double RH) {
    return 20.3 + 0.214 * U * U - 2.29e-3 * RH * RH;
}
// Solid-set, All (Eq. E14)
double wdel_E14(double U, double RH) {
    return 26.1 + 1.64 * U - 0.274 * RH;
}
// Solid-set, All (Eq. E5)
double wdel_E5(double RH) {
    return 38.6 - 0.407 * RH;
}
// Solid-set, All (Eq. E23)
double wdel_E23(double U) {
    return 4.4 + 3.60 * std::pow(U, 0.9);
}
// Solid-set, All (Eq. E4)
double wdel_E4(double U) {
    return 5.2 + 2.90 * U;
}
// Solid-set, Day (Eq. E13)
double wdel_E13(double U, double RH) {
    return 20.7 + 0.185 * U * U - 2.14e-3 * RH * RH;
}
// Solid-set, Day (Eq. E12)
double wdel_E12(double U, double RH) {
    return 24.1 + 1.41 * U - 0.216 * RH;
}
// Solid-set, Day (Eq. E21)
double wdel_E21(double U) {
    return 12.3 + 0.552 * std::pow(U, 1.6);
}
// Solid-set, Day (Eq. E1)
double wdel_E1(double U) {
    return 13.0 + 0.246 * U * U;
}
// Solid-set, Day (Eq. E20)
double wdel_E20(double U) {
    return 10.5 + 1.89 * U;
}
// Solid-set, Night (Eq. E22)
double wdel_E22(double U) {
    return 3.2 + 1.84 * std::pow(U, 1.7);
}
// Solid-set, Night (Eq. E2)
double wdel_E2(double U) {
    return 3.7 + 1.31 * U * U;
}
// Solid-set, Night (Eq. E3)
double wdel_E3(double RH) {
    return 29.9 - 0.300 * RH;
}

// Moving lateral, All (Eq. E18)
double wdel_E18(double U, double T) {
    return -2.1 + 1.91 * U + 0.231 * T;
}
// Moving lateral, All (Eq. E7)
double wdel_E7(double U) {
    return 2.7 + 2.31 * U;
}
// Moving lateral, All (Eq. E27)
double wdel_E27(double U) {
    return 2.4 + 2.70 * std::pow(U, 0.9);
}
// Moving lateral, Day (Eq. E17)
double wdel_E17(double U, double RH) {
    return 7.0 + 1.65 * U - 1.16e-3 * RH * RH;
}
// Moving lateral, Day (Eq. E16)
double wdel_E16(double U, double RH) {
    return 8.9 + 1.67 * U - 0.097 * RH;
}
// Moving lateral, Day (Eq. E25)
double wdel_E25(double U) {
    return 5.1 + 1.78 * std::pow(U, 0.9);
}
// Moving lateral, Day (Eq. E24)
double wdel_E24(double U) {
    return 5.4 + 1.48 * U;
}
// Moving lateral, Night (Eq. E26)
double wdel_E26(double U) {
    return 3.1 + 0.00600 * std::pow(U, 9.2);
}
// Moving lateral, Night (Eq. E6)
double wdel_E6(double RH) {
    return 239.0 / RH;
}

// Both irrigation systems, All (Eq. E11)
double wdel_E11(double U) {
    return 3.1 + 2.95 * U;
}
// Both irrigation systems, Day (Eq. E8)
double wdel_E8(double U) {
    return 8.6 + 0.337 * U * U;
}
// Both irrigation systems, Day (Eq. E28)
double wdel_E28(double U) {
    return 8.4 + 0.409 * std::pow(U, 1.9);
}
// Both irrigation systems, Day (Eq. E19)
double wdel_E19(double U) {
    return 5.7 + 2.29 * U;
}
// Both irrigation systems, Night (Eq. E29)
double wdel_E29(double U) {
    return 3.2 + 0.761 * std::pow(U, 2.6);
}
// Both irrigation systems, Night (Eq. E9)
double wdel_E9(double U) {
    return 3.4 + 0.512 * std::pow(U, 3.0);
}
// Both irrigation systems, Night (Eq. E10)
double wdel_E10(double RH) {
    return (10.3 - 8.97) * 1e-4 * RH * RH;
}

// Empirical formula: Trimmer (1987)
double wdel_Trimmer1987(double Dn, double VPD, double P, double U) {
    double term = 1.98 * std::pow(Dn, -0.72)
        + 0.22 * std::pow(VPD, 0.63)
        + 3.6e-4 * std::pow(P, 1.16)
        + 0.4 * std::pow(U, 0.7);
    return std::pow(term, 4.2);
}

// Empirical formula: Faci and Bercero (1991)
double wdel_FaciBercero1991(double U) {
    return 20.44 + 0.75 * U;
}

// Empirical formula: Montero (1999)
double wdel_Montero1999(double VPD, double U) {
    return 7.63 * std::pow(VPD, 0.5) + 1.62 * U;
}

// Empirical formula: Tarjuelo et al. (2000)
double wdel_Tarjuelo2000(double P, double VPD, double U) {
    return 0.007 * P + 7.38 * std::pow(VPD, 0.5) + 0.844 * U;
}

// Empirical formula: Faci et al. (2001)
double wdel_Faci2001(double Dn, double U, double T) {
    return -0.74 * Dn + 2.58 * U + 0.47 * T;
}

// Empirical formula: Dechmi et al. (2003)
double wdel_Dechmi2003(double U) {
    return 7.479 + 5.287 * U;
}

// Empirical formula: Playán et al. (2004)
double wdel_Playan2004(double U) {
    return 1.55 + 1.13 * U;
}

int main() {
    double U = 3.5;      // wind speed (m/s)
    double RH = 50.0;    // relative humidity (%)
    double T = 25.0;     // air temperature (°C)

    std::cout << "E15: " << wdel_E15(U, RH) << std::endl;
    std::cout << "E14: " << wdel_E14(U, RH) << std::endl;
    std::cout << "E5:  " << wdel_E5(RH)   << std::endl;
    std::cout << "E23: " << wdel_E23(U)   << std::endl;
    // add other prints as desired
    return 0;
}
