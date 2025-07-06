#include <iostream>
#include <cmath>
using namespace std;

int main() {
    double d = 2.4e-3;        // 2.4mm in meters
    double Dn = 4.0e-3;       // 4.0mm in meters
    double U = 0.4;           // 0.4 m/s
    double h = 1.0;           // 1.0 m
    double P_kPa = 240;       // 240 kPa
    double RH = 0.8;          // 80%
    double SR = 380;          // estimated solar radiation
    
    double g = 9.81;
    double rho = 1000;
    double P_Pa = P_kPa * 1000;
    
    double pi1 = d / Dn;
    double pi2 = RH;
    double pi3 = U / sqrt(g * h);
    double pi4 = SR * sqrt(rho / pow(rho * g * Dn, 3));
    double pi5 = P_Pa / (rho * g * Dn);
    
    cout << "pi1 = " << pi1 << endl;
    cout << "pi2 = " << pi2 << endl;
    cout << "pi3 = " << pi3 << endl;
    cout << "pi4 = " << pi4 << endl;
    cout << "pi5 = " << pi5 << endl;
    
    double loss = 0.1 * pi1 + 0.05 * pi2 + 0.2 * pi3 + 0.15 * pi4 + 0.3 * pi5;
    cout << "loss = " << loss << endl;
    cout << "loss (%) = " << loss * 100 << endl;
    
    return 0;
}
