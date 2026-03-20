% =============================================================================
% ME 4056 Systems Lab 
% HW 1 Blackbody Radiation
% Kim, Eugene 
% GTID: 903403715
% =============================================================================

% Blackbody Radiation Homework Solution 
% Written by David MacNair
% Last Modified: 05-19-2022
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

% Reset Console
clc
clear

%% Read Data and Set Known Quantities

% Given or Measured Quantities (Constant)
T_amb_C = 21; % Ambient temperature [deg C] (GIVEN)
d_2_m = 0.01094; % Sensor aperture diameter [m]
L_off_m = 0.044; % Distance from sensor base to senor aperture [m]

% Measured Quantities (Changing)

% FILLIN =====================================================================
% import from BBR_Data_F22.xlsx
% ADJUST UNITS!!!
table = readtable('BBR_Data_F22.xlsx'); 

T_1_C = table.temp_C; % Blackbody source temperature [deg C]
L_meas_m = table.dist_cm; % Distance from blackbody aperture to sensor base [m]
d_1_m = table.apt_dia_mm; % Blackbody source aperture diameter [m]
Q_dot_12_W = table.Qdot_mW; % Radiated power measurement [W]


% Use Published Caliper Precision (use_caliper_test_data = 0) or Test Data (use_caliper_test_data = 1) for Caliper Precision Uncertainty
use_caliper_test_data = 0; % Selector for using published caliper precision or test data []

% FILLIN =====================================================================
% Blackbody source aperture diameter precision uncertainty test values
d_1_test_m = .00001 / 2; % Precision uncertainty test values [m] (Note: Later function requires this to be defined even if unused)


%% END OF EDITING
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
%

%% Code is complete below this point  
% Be sure to fill in function BBR_Calculations.m to make this script functional
% ---- %

%% For Loop to Go Through Full and Segmented Data Sets

%Full Data Set (This will be index 1 in each cell array; Remember to use {} instead of () to access cell array values)
i_seg = 1;
T_1_C_seg{i_seg} = T_1_C;
L_meas_m_seg{i_seg} = L_meas_m;
d_1_m_seg{i_seg} = d_1_m;
Q_dot_12_W_seg{i_seg} = Q_dot_12_W;

% Segment the data based on values in d_1_m
seg_vect = d_1_m; % Create a separate vector used for tracking what values have already been handled

while sum(seg_vect) ~= 0 % While the segment vector doesn't have all zeros
    
    i_seg = i_seg + 1; % First segmented data set will be index 2 and they will iterate from there
    
    % Find the first non-zero value in seg_vect, and returns indicies of all values in the vector with that same value
    temp_indicies = find(seg_vect == seg_vect(find(seg_vect,1)));
    %   Note: This only works if the array doesn't have any 0 values.  For
    %   an array with 0 values, you can add the machine error eps (see
    %   'help eps') to every element first.  Do this when defining the
    %   tracking vector (eg. 'seg_vect = d_1_m + eps;').
    
    % Put the associated rows of the data vectors into a cell array
    T_1_C_seg{i_seg} = T_1_C(temp_indicies);
    L_meas_m_seg{i_seg} = L_meas_m(temp_indicies);
    d_1_m_seg{i_seg} = d_1_m(temp_indicies);
    Q_dot_12_W_seg{i_seg} = Q_dot_12_W(temp_indicies);
    
    % Set the rows of the of the tracking vector to 0 so they will be 
    seg_vect(temp_indicies)=0;

end

%% Run Calculation Function for Each Data Set (Full and Segmented Sets)

for i_seg = 1:length(d_1_m_seg)
    
    % Edit the BBR_Calculations Function to add the equations
    [X_axis_m2K4{i_seg}, Y_axis_W{i_seg}, Uc_X_axis_m2K4{i_seg}, Uc_Y_axis_W{i_seg}] = BBR_Calculations(T_amb_C, d_2_m, L_off_m, T_1_C_seg{i_seg}, L_meas_m_seg{i_seg}, d_1_m_seg{i_seg}, d_1_test_m, Q_dot_12_W_seg{i_seg},use_caliper_test_data);
    
end

%% Plot Data Points and Error Ellipses for Full Data Set

% Set up Plot
Current_Figure{1}=figure(1);
clf
hold on
% Set MatLab to Reset the Color Order: This Allows for Plotting Data Points and Regression Lines in the Same Color Without Directly Controlling the Colors
set(get(Current_Figure{1},'CurrentAxes'),'ColorOrderIndex',1);

% Set Plot Properties for Plotting Data Points
Plot_Properties{1} = '.';

% Use plot_ellipse_data function to plot experimental data and uncertainty ellipses:
% plot_ellipse_data(X, Y, Uc_X, Uc_Y, Current_Figure, Plot_Properties);
Current_Figure{1} = plot_ellipse_data(X_axis_m2K4{1}, Y_axis_W{1}, Uc_X_axis_m2K4{1}, Uc_Y_axis_W{1}, Current_Figure{1}, Plot_Properties{1});

%% Plot Data Points and Error Ellipses for Segmented Data Set (All on Same Figure)

% Set up Plot
Current_Figure{2}=figure(2);
clf
hold on

% Set Plot Properties for Plotting Data Points
Plot_Properties{2} = '.';
Plot_ColorIndex = 1;

for i_seg = 2:length(d_1_m_seg)

    % Set MatLab to Reset the Color Order: This Allows for Plotting Data Points and Regression Lines in the Same Color Without Directly Controlling the Colors
    set(get(Current_Figure{2},'CurrentAxes'),'ColorOrderIndex',Plot_ColorIndex); % Set the ColorOrderIndex
    Plot_ColorIndex = Plot_ColorIndex + 1; % Iterate the ColorOrderIndex
    
    % Use plot_ellipse_data function to plot experimental data and uncertainty ellipses:
    % plot_ellipse_data(X, Y, Uc_X, Uc_Y, Current_Figure, Plot_Properties);
    Current_Figure{2} = plot_ellipse_data(X_axis_m2K4{i_seg}, Y_axis_W{i_seg}, Uc_X_axis_m2K4{i_seg}, Uc_Y_axis_W{i_seg}, Current_Figure{2}, Plot_Properties{2});
    
end

%% Perform York Regressions

for i_seg = 1:length(d_1_m_seg)

    % York Linear Regression: [Intercept, Slope, Uc_Intercept, Uc_Slope] = york_fit(X, Y, Uc_X, Uc_Y)
    [B_W{i_seg}, M_Wm2K4{i_seg}, Uc_B_W{i_seg}, Uc_M_Wm2K4{i_seg}] = york_fit(X_axis_m2K4{i_seg}, Y_axis_W{i_seg}, Uc_X_axis_m2K4{i_seg}, Uc_Y_axis_W{i_seg});

    %Multiply Uncertainty by 2 for K=2 or 95.4%
    Uc_M_Wm2K4_K2{i_seg} = Uc_M_Wm2K4{i_seg}*2;
    Uc_B_W_K2{i_seg} = Uc_B_W{i_seg}*2;

end

%% Plot York Regression Results for Full Data Set

% Set Up Plot for Linear Regression Results (Regression Line)
figure(Current_Figure{1}); %Plot onto the Figure With the Full Data Set
set(get(Current_Figure{1},'CurrentAxes'),'ColorOrderIndex',1); %Reset the Color Order: This Allows for Plotting Data Points and Regression Lines in the Same Color Without Directly Controlling the Colors

% Set Plot Properties for Plotting Data Points
PlotRegression_Properties{1} = '-r'; % Setting a color property in this plot function overides the automatic coloring (if you want the regression line a different color from data points)

% Find Regression Result Y Points for Each Given X Value
Reg_Y_axis_W{1} = X_axis_m2K4{1} .* M_Wm2K4{1} + B_W{1};

% Plot Linear Regression Results (Regression Line)
plot(X_axis_m2K4{1}, Reg_Y_axis_W{1},PlotRegression_Properties{1});

% Strings to Print Regression Equation in Legend
Reg_Data_str{1} = 'Full Set Regression Data';
Reg_Eqn_str{1} = ['$\dot{Q}_{12} = $', num2str(M_Wm2K4{1}), '$ * A_1 \cdot F_{12} \cdot \left( T_1^4 - T_2^4\right) + $', num2str(B_W{1})];

% Print Legend on Plot
legend(Reg_Data_str{1},Reg_Eqn_str{1},'Location','northwest','interpreter','latex')

% Axis Labels
xlabel('$A_1 \cdot F_{12} \cdot \left( T_1^4 - T_2^4\right) [m^2 \cdot K^4]$','interpreter','latex');
ylabel('$\dot{Q}_{12} [W]$','interpreter','latex');

%% Plot York Regression Results for Segmented Data Sets

% Set Up Plot for Linear Regression Results (Regression Line)
figure(Current_Figure{2}); %Plot onto the Figure With the Full Data Set

% Set Plot Properties for Plotting Data Points
PlotRegression_Properties{2} = '-';
Plot_ColorIndex = 1;

for i_seg = 2:length(d_1_m_seg)

    % Set MatLab to Reset the Color Order: This Allows for Plotting Data Points and Regression Lines in the Same Color Without Directly Controlling the Colors
    set(get(Current_Figure{2},'CurrentAxes'),'ColorOrderIndex',Plot_ColorIndex); % Set the ColorOrderIndex
    Plot_ColorIndex = Plot_ColorIndex + 1; % Iterate the ColorOrderIndex
    
    % Find Regression Result Y Points for Each Given X Value
    Reg_Y_axis_W{i_seg} = X_axis_m2K4{i_seg} .* M_Wm2K4{i_seg} + B_W{i_seg};

    % Plot Linear Regression Results (Regression Line)
    plot(X_axis_m2K4{i_seg}, Reg_Y_axis_W{i_seg}, PlotRegression_Properties{2});

    % String to Print Regression Equation in Legend
    Reg_Data_str{i_seg} = [num2str(d_1_m_seg{i_seg}(1)),'m Diameter Aperture Regression Data'];
    Reg_Eqn_str{i_seg} = ['$\dot{Q}_{12} = $', num2str(M_Wm2K4{i_seg}), '$ * A_1 \cdot F_{12} \cdot \left( T_1^4 - T_2^4\right) + $', num2str(B_W{i_seg})];

end

% Print Legend on Plot
legend(Reg_Data_str{2:length(d_1_m_seg)},Reg_Eqn_str{2:length(d_1_m_seg)},'Location','northwest','interpreter','latex')

% Axis Labels
xlabel('$A_1 \cdot F_{12} \cdot \left( T_1^4 - T_2^4\right) [m^2 \cdot K^4]$','interpreter','latex');
ylabel('$\dot{Q}_{12} [W]$','interpreter','latex');


%% Print Results for Full Data Set to Console

% String to Print Theory Value to Console
SB_Theory_Wm2K4 = 5.67374 .* 10 .^ (-8);
Reg_Theory_str = ['Theoretical SB Constant = ', num2str(SB_Theory_Wm2K4), ' [W/(m^2*K^4)]\n'];

% String to Print If Caliper Published Precsion or Caliper Test Precision Uncertainty is Used
if use_caliper_test_data == 0
    Reg_Caliper_Test_String = 'Using Published Caliper Precision';
else
    Reg_Caliper_Test_String = 'Using Caliper Test Precision Uncertainty';
end

% String to Print Slope (M) and Uncertainty in Slope (Uc_M) to Console
Reg_M_str{1} = ['M = ', num2str(M_Wm2K4{1}), ' [W/(m^2*K^4)]  <-- Experimental SB Constant\n','Uc_M = ', num2str(Uc_M_Wm2K4_K2{1}), ' [W/(m^2*K^4)] (K=2)\n'];

% String to Print Intercept (B) and Uncertainty in Intercept (Uc_B) to Console
Reg_B_str{1} = ['B = ', num2str(B_W{1}), ' [W]\n','Uc_B = ', num2str(Uc_B_W_K2{1}), ' [W] (K=2)\n'];

% Write Strings to Console
fprintf('\n');
fprintf(Reg_Caliper_Test_String);
fprintf('\n\n');
fprintf(Reg_Theory_str);
fprintf('\n');
fprintf(Reg_Data_str{1});
fprintf('\n');
fprintf(Reg_M_str{1});
fprintf('\n');
fprintf(Reg_B_str{1});
fprintf('\n');

% Conclusion:
if SB_Theory_Wm2K4 >= (M_Wm2K4{1} - Uc_M_Wm2K4_K2{1}) && SB_Theory_Wm2K4 <= (M_Wm2K4{1} + Uc_M_Wm2K4_K2{1})
    fprintf('Theory SB Constant falls within K=2 uncertainty bounds.');
else
    fprintf('Theory SB Constant falls outside K=2 uncertainty bounds.');
end

fprintf('\n\n ------ \n');

%% Print Results for Full Data Set to Console

for i_seg = 2:length(d_1_m_seg)

    % String to Print Slope (M) and Uncertainty in Slope (Uc_M) to Console
    Reg_M_str{i_seg} = ['M = ', num2str(M_Wm2K4{i_seg}), ' [W/(m^2*K^4)]  <-- Experimental SB Constant\n','Uc_M = ', num2str(Uc_M_Wm2K4_K2{i_seg}), ' [W/(m^2*K^4)] (K=2)\n'];

    % Write Strings to Console
    fprintf('\n');
    fprintf(Reg_Data_str{i_seg});
    
    fprintf('\n');
    fprintf(Reg_M_str{i_seg});
    
    fprintf('\n');

    % Conclusion:
    if SB_Theory_Wm2K4 >= (M_Wm2K4{i_seg} - Uc_M_Wm2K4_K2{i_seg}) && SB_Theory_Wm2K4 <= (M_Wm2K4{i_seg} + Uc_M_Wm2K4_K2{i_seg})
        fprintf('Theory SB Constant falls within K=2 uncertainty bounds.');
    else
        fprintf('Theory SB Constant falls outside K=2 uncertainty bounds.');
    end
    
    fprintf('\n\n ------ \n');

end