# WDEL Formula 2 (Aminpour et al. 2023) Evaluation Report

## Overview
This report evaluates the performance of the WDEL (Wind Drift and Evaporation Losses) Formula 2 based on Aminpour et al. (2023) dimensional analysis approach against experimental data from Sanchez et al. (2011).

## Methodology

### Formula Description
The Aminpour et al. (2023) formula uses dimensional analysis to derive dimensionless parameters:

- **π₁ = d/Dn**: Diameter ratio (auxiliary to main nozzle)
- **π₂ = RH**: Relative humidity
- **π₃ = U/√(gh)**: Froude number
- **π₄ = SR√(ρ/(ρgDn)³)**: Solar radiation parameter
- **π₅ = P/(ρgDn)**: Pressure parameter

The functional relationship is expressed as:
```
WDEL = f(π₁, π₂, π₃, π₄, π₅)
```

### Experimental Dataset
The evaluation uses 14 test cases from Sanchez et al. (2011) loaded from an external data file:
- **Data Source**: `data/experimental_data.txt`
- **Nozzle configuration**: 4.0mm main + 2.4mm auxiliary
- **Pressures**: 240, 320, 420 kPa
- **Wind speeds**: 0.4 - 8.0 m/s
- **Temperatures**: 5 - 24°C
- **Relative humidity**: 43 - 85%
- **Measured WDEL**: 3.5 - 35.6%

*Note: Experimental data is loaded from external file to maintain data separation from source code.*

## Results

### Key Findings

⚠️ **Critical Issue Identified**: The current implementation produces unrealistic results with predicted WDEL values ranging from 184,000% to 322,000%, which are several orders of magnitude higher than the measured values (3.5% to 35.6%).

### Performance Metrics

| Implementation | MAE (%) | RMSE (%) | MBE (%) | r | R² |
|---------------|---------|----------|---------|---|-----|
| MATLAB/Octave | 220,220.54 | 223,938.32 | 220,220.54 | -0.356 | -613,816,928.659 |
| C++ | 220,220.54 | 223,938.32 | 220,220.54 | -0.356 | -613,816,928.659 |

### Detailed Test Results

*Note: Detailed test results are loaded from external data file and processed programmatically. The following shows a sample of the unrealistic predictions generated by the current formula implementation:*

- **240 kPa tests**: Predicted WDEL ~184,000% vs Measured 6.6-35.6%
- **320 kPa tests**: Predicted WDEL ~245,000% vs Measured 3.5-25.3%  
- **420 kPa tests**: Predicted WDEL ~322,000% vs Measured 10.5%

*Complete results are available in the generated output files from both implementations.*

## Problem Analysis

### Root Cause
The unrealistic results are caused by:

1. **Placeholder coefficients**: The original paper by Aminpour et al. (2023) provides the dimensional analysis framework but not the actual functional relationship coefficients.

2. **Pressure parameter dominance**: The π₅ parameter (P/(ρgDn)) produces extremely large values:
   - For 240 kPa: π₅ ≈ 6,116
   - For 320 kPa: π₅ ≈ 8,155  
   - For 420 kPa: π₅ ≈ 10,694

3. **Coefficient scaling**: The current implementation uses arbitrary coefficients:
   ```
   WDEL = 0.1×π₁ + 0.05×π₂ + 0.2×π₃ + 0.15×π₄ + 0.3×π₅
   ```

### Dimensional Analysis Verification
The dimensionless parameters calculate as:
- π₁ = 0.6 (reasonable)
- π₂ = 0.43-0.85 (reasonable)
- π₃ = 0.128-2.554 (reasonable)
- π₄ = 48.9-61.0 (reasonable)
- π₅ = 6,116-10,694 (unreasonably large)

## Recommendations

### Immediate Actions Required
1. **Obtain actual coefficients**: Contact the authors or find the complete functional relationship from Aminpour et al. (2023)
2. **Coefficient calibration**: Use the experimental data to calibrate realistic coefficients
3. **Unit verification**: Ensure consistent units in pressure parameter calculation
4. **Alternative formulation**: Consider logarithmic or power-law relationships for the pressure parameter

### Alternative Approaches
1. **Use established empirical formulas**: Consider well-validated formulas like Playán et al. (2005) equations
2. **Hybrid approach**: Combine dimensional analysis with empirical calibration
3. **Machine learning**: Use the experimental data to train a predictive model

## Conclusion

The current implementation of the Aminpour et al. (2023) dimensional analysis formula is not suitable for practical use due to unrealistic predictions. The formula framework appears sound, but the functional relationship coefficients require proper calibration or derivation from the original source material.

The evaluation successfully demonstrates the implementation consistency between MATLAB/Octave and C++ versions, but both produce identical unrealistic results, confirming that the issue lies in the formula parameterization rather than implementation errors.

## Technical Details

### Implementation Files
- **MATLAB/Octave**: `evaluate_wdel_formula2.m` (reads from external data file)
- **C++**: `evaluate_wdel_formula2_external.cpp` (reads from external data file)
- **Data Source**: `data/experimental_data.txt` (Sanchez et al. 2011, Table 2)

### Data Management
- **External Data File**: Experimental data is stored in a separate CSV file for maintainability
- **Data Format**: CSV with header comments describing each field
- **Data Separation**: Sensitive experimental data is kept separate from source code
- **Reproducibility**: Both implementations read from the same external data source

### Dependencies
- **MATLAB/Octave**: Statistics toolbox for correlation analysis
- **C++**: Standard library with C++11 support

### Execution Environment
- **OS**: Linux
- **Compiler**: GCC with C++11 standard
- **MATLAB/Octave**: Octave 6.x (command-line interface)

---

*Report generated on July 6, 2025*
*Evaluation conducted using 14 experimental test cases from Sanchez et al. (2011)*
