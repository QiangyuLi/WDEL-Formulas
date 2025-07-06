# Wind Drift and Evaporation Losses (WDEL) Formulas

This repository contains MATLAB/Octave and C++ implementations of formulas for estimating **wind drift and evaporation losses (WDEL)** in sprinkler irrigation systems, based on the study:

> Younes Aminpour, Darya Dehghan, Enrique Playán, Eisa Maroufpoor (2023).  
> Estimation of wind drift and evaporation losses of sprinkler irrigation systems using dimensional analysis.  
> *Agricultural Water Management, Volume 286, 2023, 108518*.  
> [https://doi.org/10.1016/j.agwat.2023.108518](https://doi.org/10.1016/j.agwat.2023.108518)  
>  
> © 2023 The Author(s). Published by Elsevier B.V. This is an open access article under the CC BY-NC-ND license.

## Repository Structure

- `matlab_octave/` – MATLAB/Octave implementations of the WDEL formulas.
- `cpp/` – C++ versions of the same models.
- `references/` – Metadata and citation for the original research paper.

## License

This repository contains **original implementations** of formulas derived from a scientific publication. The formulas themselves are factual/mathematical and not copyrighted.  
See `LICENSE` and `DISCLAIMER.md` for more details.

## Additional References

- Aminpour, Y., Dehghan, D., Playán, E., Maroufpoor, E. (2023). Estimation of wind drift and evaporation losses of sprinkler irrigation systems using dimensional analysis. *Agricultural Water Management*, 286, 108518. DOI: https://doi.org/10.1016/j.agwat.2023.108518

- Playán, E., Salvador, R., Faci, J.M., Zapata, N., Martínez-Cob, A., Sánchez, I. (2005). Day and night wind drift and evaporation losses in sprinkler solid-sets and moving laterals. *Agricultural Water Management*, 76(3), 139-159. DOI: https://doi.org/10.1016/j.agwat.2005.01.015

## Parameters

- **Dn** (Dnozzle): Nozzle diameter, in millimeters (mm)
- **d**: Auxiliary nozzle diameter, in meters (m)
- **U**: Wind speed, in meters per second (m/s)
- **h**: Riser height, in meters (m)
- **P**: Operating pressure, in kilopascals (kPa)
- **RH**: Relative humidity, in percent (%)
- **VPD**: Vapour pressure deficit (es − ea), in kilopascals (kPa)
- **T**: Air temperature, in degrees Celsius (°C)
- **ET0**: Reference evapotranspiration, in millimeters per day (mm/day)
- **SR**: Solar radiation, in Watts per square meter (W/m²)
- **ρ** (rho): Water density, in kilograms per cubic meter (kg/m³)
- **g**: Acceleration due to gravity, in meters per second squared (m/s²)
- **μ** (mu): Dynamic viscosity of water, in Newton-seconds per square meter (N·s/m²)

## Implemented Formulas

This repository contains implementations of 36 different empirical formulas for estimating wind drift and evaporation losses in sprinkler irrigation systems.

### Playán et al. (2005) Equations (E1-E29)

**Solid-set Sprinkler Systems:**
- **All conditions:** E15, E14, E5, E23, E4
- **Day conditions:** E13, E12, E21, E1, E20
- **Night conditions:** E22, E2, E3

**Moving Lateral Systems:**
- **All conditions:** E18, E7, E27
- **Day conditions:** E17, E16, E25, E24
- **Night conditions:** E26, E6

**Both Irrigation Systems:**
- **All conditions:** E11
- **Day conditions:** E8, E28, E19
- **Night conditions:** E29, E9, E10

### Dimensional Analysis Formula

**Aminpour et al. (2023):** Multi-dimensional formula incorporating diameter ratio, relative humidity, Froude number, solar radiation parameter, and pressure parameter

### Historical Empirical Formulas
- **Trimmer (1987):** Complex multi-parameter formula involving nozzle diameter, VPD, pressure, and wind speed
- **Faci and Bercero (1991):** Simple linear relationship with wind speed
- **Montero (1999):** Combination of VPD and wind speed effects
- **Tarjuelo et al. (2000):** Incorporates pressure, VPD, and wind speed
- **Faci et al. (2001):** Includes nozzle diameter, wind speed, and temperature effects
- **Dechmi et al. (2003):** Linear wind speed relationship
- **Playán et al. (2004):** Simplified wind speed formula

## Formula Categories

### By Input Parameters:
1. **Wind Speed Only:** E4, E20, E22, E2, E7, E27, E11, E23, E21, E25, E24, E8, E28, E19, E29, E9
2. **Wind Speed + Relative Humidity:** E15, E14, E12, E13, E17, E16
3. **Wind Speed + Temperature:** E18, Faci2001
4. **Relative Humidity Only:** E5, E3, E6, E10
5. **Multi-parameter:** Trimmer1987, Tarjuelo2000, Montero1999

### By Complexity:
- **Simple Linear:** E4, E20, E7, E11, E19, FaciBercero1991, Dechmi2003, Playan2004
- **Quadratic:** E15, E1, E2, E8, E13, E10
- **Power Functions:** E23, E21, E22, E27, E25, E26, E28, E29, E9, Trimmer1987
- **Combined Effects:** E14, E12, E16, E17, E18, Montero1999, Tarjuelo2000, Faci2001

## Usage Examples

### MATLAB/Octave Example:
```matlab
% Load the formulas
% Example: Calculate WDEL using equation E15
U = 3.5;    % Wind speed (m/s)
RH = 60;    % Relative humidity (%)
loss = wdel_E15(U, RH);
fprintf('WDEL = %.2f%%\n', loss);
```

### C++ Example:
```cpp
#include "wdel_formulas.cpp"

int main() {
    double U = 3.5;    // Wind speed (m/s)
    double RH = 60;    // Relative humidity (%)
    double loss = wdel_E15(U, RH);
    std::cout << "WDEL = " << loss << "%" << std::endl;
    return 0;
}
```
