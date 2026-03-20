function [X_axis_m2K4, Y_axis_W, Uc_X_axis_m2K4, Uc_Y_axis_W] = BBR_Calculations(T_amb_C, d_2_m, L_off_m, T_1_C, L_meas_m, d_1_m, d_1_test_m, Q_dot_12_W,use_caliper_test_data)

%% DOCUMENTATION 
% Blackbody Radiation Homework Calculations Function 
% Written by David MacNair
% Last Modified: 05-18-2022
% Last Modified By: David MacNair

% Variable Naming Guide:
% Quantity: Variable_Subscript_Units
% Uncertainty: Uxy_Variable_Subscript_Units
% -- x = K Value (Coverage Factor) (Undefined = 1)
% -- y = Uncertainty Type
% -- y -- a = Accuracy
% -- y -- p = Precision
% -- y -- c = Combined

% Gauge Resolution: r_Variable_Subscript_Units
% Gauge Precision: p_Variable_Subscript_Units

% Units: (* = Preferred Units)
% -- C = deg C
% -- K *
% -- m *
% -- W *
% -- m2 = m^2 *
% -- m2K4 = m^2*K^4 *
% -- Wm2K4 = W/(m^2*K^4)

% Notes:
% 1) Every section of code needs a comment explaining the purpose
% 2) Every line of code needs a comment explaining the function/variable
% 3) Don't forget to use . in front of operators (.*, ./, .^) when working
%    with vector data

%% Inputs:

% T_amb_C = Ambient temperature [deg C]
% d_2_m = Sensor aperture diameter [m]
% L_off_m = Distance from sensor base to senor aperture [m]
% T_1_C = Blackbody source temperature [deg C]
% L_meas_m = Distance from blackbody aperture to sensor base [m]
% d_1_m = Blackbody source aperture diameter [m]
% d_1_test_m = Blackbody source aperture diameter precision uncertainty test values [m]
% Q_dot_12_W = Radiated power measurement [W]
% use_caliper_test_data = Selector for using published caliper precision or test data []

%% Outputs: 

% X_axis_m2K4 = York Regression X Axis [m^2 * K^4]
% Y_axis_W = York Regression Y Axis [W]
% Uc_X_axis_m2K4 = York Regression X-Axis Uncertainty (for k = 1, 68.2% confidence)
% Uc_Y_axis_W = York Regression Y-Axis Uncertainty (for k = 1, 68.2% confidence)


%% Calculations

% Distance Offset Calculation
L_m = L_meas_m + .044; % Power meter distance [m] + sensor offset distance

% Temperature Unit Conversion Calculations
T_1_K = T_1_C + 273.15; % Blackbody Source temperature [K], conversion to Kelvin
T_amb_K = T_amb_C + 273.15; % Ambient temperature [K]
T_2_K = T_amb_K; % Sensor 2 temperature (Ambient by assumption) [K]

% Aperture Radius Calculations
r_1_m = d_1_m ./ 2; % Blackbody source aperture radius [m], divide diameter by 2
r_2_m = d_2_m ./ 2; % Power meter aperture radius [m]

% Aperture Area Calculation
A_1_m2 = pi * r_1_m .^ 2; % Source aperture area [m^2]

% View Factor Source to Power Meter Calculation
R_1 = r_1_m ./ L_m; % Portion of view factor calculation [N/A]
R_2 = r_2_m ./ L_m; % Portion of view factor calculation [N/A]
S = 1 + R_2 .^ 2 ./ R_1 .^ 2; % Portion of view factor calculation [N/A]
F_12 = (S - sqrt(S .^ 2 - 4 *((r_2_m ./ r_1_m) .^ 2))) ./2; % View factor source to power meter [N/A]

%% Uncertainty

% Uncertainty in Measurements (for k = 1, 68.2% confidence)
Up_Q_W  = .00003; % Precision uncertainty of power meter [W]
Ua_Q_W = .01 .* Q_dot_12_W ./ 1000; % Accuracy uncertainty of power meter [W]

if use_caliper_test_data == 0
    % Using published caliper precision
    p_calip_m = .00001 / 2; % Precision of digital calipers [m]
    Up_calip_m = p_calip_m ./ sqrt(3); % Precision uncertainty of digital calipers based on published precision [m]
else
    % Using caliper test data for caliper precision uncertainty
    %    (This content of this else statement is already complete)
    n_calip_test = length(d_1_test_m); % Total number of caliper readings at the same aperture to test precision uncertainty []
    mu_calip_test_m = sum(d_1_test_m)/n_calip_test; % Mean (Average) of the same aperture diameter measurement[m]

    % Note: This portion could be optimized, but a for-loop is easier to follow
    d_1_test_sum_squares_m2 = 0; % Set start for sumation of the squares for calculating precision uncertainty from caliper readings at the same aperture [m^2]
    for i_d_1_test_m = 1:length(d_1_test_m)
     d_1_test_sum_squares_m2 = d_1_test_sum_squares_m2 + (mu_calip_test_m - d_1_test_m(i_d_1_test_m))^2; % Add the next sum of squares term [m^2]
    end
    Up_calip_m = sqrt(d_1_test_sum_squares_m2 / (n_calip_test - 1) );
end

% Remaining Uncertainty in Measurements Calculations (for k = 1, 68.2% confidence)
Ua_calip_m = .00003; % Accuracy uncertainty of digital calipers [m]
p_ruler_m = .001 / 2; % Precision of analog ruler [m]
Up_ruler_m = p_ruler_m / sqrt(6); % Precision uncertainty of analog ruler [m]
Ua_ruler_m = .001; % Accuracy uncertainty of analog ruler [m]
p_T_1_C =  .1 / 2; % Precision of the blackbody source temperature [deg C]
Up_T_1_C =  p_T_1_C / sqrt(3); % Precision uncertainty of the blackbody source temperature [deg C]
Ua_T_1_C =  1; % Accuracy uncertainty of the blackbody source temperature [deg C]
Uc_T_1_C =  sqrt((Ua_T_1_C .^ 2) + (Up_T_1_C .^ 2)); % Combined uncertainty of the blackbody source temperature [deg C]
p_T_amb_C = .5; % Precision of the ambient temperature [deg C]
Up_T_amb_C = p_T_amb_C / sqrt(6); % Precision uncertainty of the ambient temperature [deg C]
Ua_T_amb_C = 1; % Accuracy uncertainty of the ambient temperature [deg C]
Uc_T_amb_C =  sqrt(Up_T_amb_C .^ 2 + Ua_T_amb_C .^ 2); % Combined uncertainty of the ambient temperature [deg °C]
Uc_Q_W = sqrt(((.01 * Q_dot_12_W) .^ 2) + (.00003 .^ 2)); % Combined uncertainty of the power meter [W]
Uc_calip_m = sqrt((Up_calip_m .^ 2) + (Ua_calip_m .^ 2)); % Combined uncertainty of the calipers [m]
Uc_ruler_m = sqrt((Ua_ruler_m .^ 2) + (Up_ruler_m .^ 2)); % Combined uncertainty of the ruler [m]
Uc_d_1_m = Uc_calip_m; % Combined uncertainty of the blackbody source aperture diameter [m]
Uc_d_2_m = Uc_calip_m; % Combined uncertainty of the power meter aperture diameter [m]
Uc_L_meas_m = Uc_ruler_m; % Combined uncertainty of the uncorrected power meter distance [m]
Uc_L_off_m = Uc_calip_m; % Combined uncertainty of the power meter aperture offset [m]
Uc_L_m =  sqrt((Uc_ruler_m .^ 2) + (Uc_calip_m .^ 2)); % Combined uncertainty of the power meter distance [m]
Uc_r_1_m = .5 * Uc_d_1_m; % Combined uncertainty of the blackbody aperture radius [m]
Uc_r_2_m = .5 * Uc_d_2_m; % Combined uncertainty of the power meter aperture radius [m]

% EPA Aperture Area Uncertainty (for k = 1, 68.2% confidence)
Uc_A_1_m2 = 2 .* pi .* r_1_m .* Uc_r_1_m; % Combined uncertainty of the source aperture area [m^2]

% Partial Derivative of F_12 with respect to r_1_m [1/m]
%   --  This is already complete
delF_12_del_r_1_m = -(L_m .^ 2 + r_2_m .^ 2) ./ r_1_m.^3 + (L_m.^4 - r_1_m.^2 .* r_2_m.^2 + r_2_m.^4 + L_m.^2 .* (r_1_m.^2 + 2.*r_2_m.^2))./( r_1_m.^5.*sqrt((L_m.^4 + (r_1_m.^2 - r_2_m.^2).^2 + 2.*L_m.^2 .* (r_1_m.^2 + r_2_m.^2))./r_1_m.^4));

% Partial Derivative of F_12 with respect to r_1_m [1/m]
%   --  This is already complete
delF_12_del_r_2_m = r_2_m./r_1_m.^2 - (r_2_m .* (L_m.^2 - r_1_m.^2 + r_2_m.^2))./( r_1_m.^4 .* sqrt((L_m.^4 + (r_1_m.^2 - r_2_m.^2).^2 + 2 .* L_m.^2 .* (r_1_m.^2 + r_2_m.^2))./r_1_m.^4));

% Partial Derivative of F_12 with respect to L_m [1/m]
%   --  This is already complete
delF_12_del_L_m = -((L_m .* (L_m.^2 + r_1_m.^2 + r_2_m.^2 - r_1_m.^2 .* sqrt((L_m.^4 + (r_1_m.^2 - r_2_m.^2).^2 + 2 .* L_m.^2 .* (r_1_m.^2 + r_2_m.^2))./r_1_m.^4)))./( r_1_m.^4 .* sqrt((L_m.^4 + (r_1_m.^2 - r_2_m.^2).^2 + 2 .* L_m.^2 .* (r_1_m.^2 + r_2_m.^2))./r_1_m.^4)));

% EPA View Factor Uncertainty (for k = 1, 68.2% confidence)
%   --  This is already complete
Uc_F_12 = sqrt(((delF_12_del_r_1_m.*Uc_r_1_m).^2)+((delF_12_del_r_2_m.*Uc_r_2_m).^2)+((delF_12_del_L_m.*Uc_L_m).^2)); % Combined uncertainty of the view factor [N/A]

% EPA Temperature Unit Conversion (for k = 1, 68.2% confidence)
Uc_T_1_K = sqrt(((.05 / sqrt(3)) .^ 2) + (.2 .^ 2)); % Combined uncertainty of the blackbody source temperature [K]
Uc_T_2_K = sqrt(((.5 / sqrt(6)) .^ 2) + (1 .^ 2)); % Combined uncertainty of the ambient temperature [K]

%% Regression Setup

% York Regression X Axis [m^2 * K^4]
X_axis_m2K4 = (A_1_m2) .* F_12 .* ((T_1_K .^ 4) - (T_2_K .^ 4));
% York Regression Y Axis [W]
Y_axis_W = Q_dot_12_W;

% York Regression Y-Axis Uncertainty (for k = 1, 68.2% confidence)
Uc_Y_axis_W = Uc_Q_W; % Regression Y combined uncertainty

% Partial Derivative of Regression X-Axis with respect to A_1_m2
%   --  This is already complete
del_X_del_A_1_m2 = F_12.*((T_1_K.^4)-(T_2_K.^4)); % Regression X partial with respect to A_1_m2
% Partial Derivative of Regression X-Axis with respect to F_12
%   --  This is already complete
del_X_del_F_12 = A_1_m2.*((T_1_K.^4)-(T_2_K.^4)); % Regression X partial with respect to F_12
% Partial Derivative of Regression X-Axis with respect to T_1_K
%   --  This is already complete
del_X_del_T_1_K = 4.*A_1_m2.*F_12.*(T_1_K.^3); % Regression X partial with respect to T_1_K
% Partial Derivative of Regression X-Axis with respect to T_2_K
%   --  This is already complete
del_X_del_T_2_K = -4.*A_1_m2.*F_12.*(T_2_K.^3); % Regression X partial with respect to T_2_K

% York Regression X-Axis Uncertainty (for k = 1, 68.2% confidence)
%   --  This is already complete
Uc_X_axis_m2K4 = sqrt(((del_X_del_A_1_m2.*Uc_A_1_m2).^2)+((del_X_del_F_12.*Uc_F_12).^2)+((del_X_del_T_1_K.*Uc_T_1_K).^2)+((del_X_del_T_2_K.*Uc_T_2_K).^2)); % Regression X combined uncertainty
