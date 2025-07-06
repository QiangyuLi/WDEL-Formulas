% MATLAB/Octave implementations of WDEL equations E1 to E29

% Solid-set, All (Eq. E15)
function loss = wdel_E15(U, RH)
    loss = 20.3 + 0.214 * U.^2 - 2.29e-3 * RH.^2;
end

% Solid-set, All (Eq. E14)
function loss = wdel_E14(U, RH)
    loss = 26.1 + 1.64 * U - 0.274 * RH;
end

% Solid-set, All (Eq. E5)
function loss = wdel_E5(RH)
    loss = 38.6 - 0.407 * RH;
end

% Solid-set, All (Eq. E23)
function loss = wdel_E23(U)
    loss = 4.4 + 3.60 * U.^0.9;
end

% Solid-set, All (Eq. E4)
function loss = wdel_E4(U)
    loss = 5.2 + 2.90 * U;
end

% Solid-set, Day (Eq. E13)
function loss = wdel_E13(U, RH)
    loss = 20.7 + 0.185 * U.^2 - 2.14e-3 * RH.^2;
end

% Solid-set, Day (Eq. E12)
function loss = wdel_E12(U, RH)
    loss = 24.1 + 1.41 * U - 0.216 * RH;
end

% Solid-set, Day (Eq. E21)
function loss = wdel_E21(U)
    loss = 12.3 + 0.552 * U.^1.6;
end

% Solid-set, Day (Eq. E1)
function loss = wdel_E1(U)
    loss = 13.0 + 0.246 * U.^2;
end

% Solid-set, Day (Eq. E20)
function loss = wdel_E20(U)
    loss = 10.5 + 1.89 * U;
end

% Solid-set, Night (Eq. E22)
function loss = wdel_E22(U)
    loss = 3.2 + 1.84 * U.^1.7;
end

% Solid-set, Night (Eq. E2)
function loss = wdel_E2(U)
    loss = 3.7 + 1.31 * U.^2;
end

% Solid-set, Night (Eq. E3)
function loss = wdel_E3(RH)
    loss = 29.9 - 0.300 * RH;
end

% Moving lateral, All (Eq. E18)
function loss = wdel_E18(U, T)
    loss = -2.1 + 1.91 * U + 0.231 * T;
end

% Moving lateral, All (Eq. E7)
function loss = wdel_E7(U)
    loss = 2.7 + 2.31 * U;
end

% Moving lateral, All (Eq. E27)
function loss = wdel_E27(U)
    loss = 2.4 + 2.70 * U.^0.9;
end

% Moving lateral, Day (Eq. E17)
function loss = wdel_E17(U, RH)
    loss = 7.0 + 1.65 * U - 1.16e-3 * RH.^2;
end

% Moving lateral, Day (Eq. E16)
function loss = wdel_E16(U, RH)
    loss = 8.9 + 1.67 * U - 0.097 * RH;
end

% Moving lateral, Day (Eq. E25)
function loss = wdel_E25(U)
    loss = 5.1 + 1.78 * U.^0.9;
end

% Moving lateral, Day (Eq. E24)
function loss = wdel_E24(U)
    loss = 5.4 + 1.48 * U;
end

% Moving lateral, Night (Eq. E26)
function loss = wdel_E26(U)
    loss = 3.1 + 0.00600 * U.^9.2;
end

% Moving lateral, Night (Eq. E6)
function loss = wdel_E6(RH)
    loss = 239 ./ RH;
end

% Both irrigation systems, All (Eq. E11)
function loss = wdel_E11(U)
    loss = 3.1 + 2.95 * U;
end

% Both irrigation systems, Day (Eq. E8)
function loss = wdel_E8(U)
    loss = 8.6 + 0.337 * U.^2;
end

% Both irrigation systems, Day (Eq. E28)
function loss = wdel_E28(U)
    loss = 8.4 + 0.409 * U.^1.9;
end

% Both irrigation systems, Day (Eq. E19)
function loss = wdel_E19(U)
    loss = 5.7 + 2.29 * U;
end

% Both irrigation systems, Night (Eq. E29)
function loss = wdel_E29(U)
    loss = 3.2 + 0.761 * U.^2.6;
end

% Both irrigation systems, Night (Eq. E9)
function loss = wdel_E9(U)
    loss = 3.4 + 0.512 * U.^3;
end

% Both irrigation systems, Night (Eq. E10)
function loss = wdel_E10(RH)
    loss = (10.3 - 8.97) * 1e-4 * RH.^2;
end

% Empirical formula: Trimmer (1987)
function loss = wdel_Trimmer1987(Dn, VPD, P, U)
    term = 1.98 * Dn.^(-0.72) ...
         + 0.22 * VPD.^0.63 ...
         + 3.6e-4 * P.^1.16 ...
         + 0.4 * U.^0.7;
    loss = term.^4.2;
end

% Empirical formula: Faci and Bercero (1991)
function loss = wdel_FaciBercero1991(U)
    loss = 20.44 + 0.75 * U;
end

% Empirical formula: Montero (1999)
function loss = wdel_Montero1999(VPD, U)
    loss = 7.63 * VPD.^0.5 + 1.62 * U;
end

% Empirical formula: Tarjuelo et al. (2000)
function loss = wdel_Tarjuelo2000(P, VPD, U)
    loss = 0.007 * P + 7.38 * VPD.^0.5 + 0.844 * U;
end

% Empirical formula: Faci et al. (2001)
function loss = wdel_Faci2001(Dn, U, T)
    loss = -0.74 * Dn + 2.58 * U + 0.47 * T;
end

% Based on Playán et al. (2005): Day and night wind drift and evaporation losses in sprinkler solid-sets and moving laterals.
% DOI: https://doi.org/10.1016/j.agwat.2005.01.015

% Empirical formula: Dechmi et al. (2003)
function loss = wdel_Dechmi2003(U)
    loss = 7.479 + 5.287 * U;
end

% Empirical formula: Playán et al. (2004)
function loss = wdel_Playan2004(U)
    loss = 1.55 + 1.13 * U;
end
