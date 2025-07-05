# MATLAB/Octave Implementations

This folder contains MATLAB/Octave implementations of the wind drift and evaporation loss (WDEL) estimation formulas.

Each `.m` file corresponds to a specific empirical or analytical equation from the original article.

### Requirements

- MATLAB R2018+ or
- GNU Octave 6.0+ (free, open-source)

### Example Usage

```matlab
v = 3.5; % wind speed in m/s
d = 8;   % nozzle diameter in mm
loss = wdel_formula1(v, d);
