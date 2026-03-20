%% ME 4056 - SystemID/Controls HW
%Simulink Help File
%Last Edited By: Alana Homa
%Last Edited: 05/23/2022
close all
clear
clc


%% Step 1: Define Model Values
K_m = 6.23; %motor gain constant
T_m_s = 0.09; %motor time constant
upperLin = 8; %saturation voltage limit

%use controls_lab_gain_calculator.m
K_m = 6.23; % (Calculated); 
T_m = 0.09; % (Calculated); 
M_p = 10;  % (Problem Statement)
t_s = 0.5; % (Problem Statement)
n = 1; % (Problem Statement)

% Proportional Controller
  P_Kp = 1.27587;

% PD Controller
  PD_Kp = 2.64565;
  PD_Kd = 0.070626;

% For PID Controller:
  PID_Kp = 4.49476;
  PID_Kd = 0.186196;
  PID_Ki = 21.1652;
  
  %% Step 2: Run Simulink Model and Plot
  out = sim('SimulinkPIDControllers');
  
  % Establish figure names to be called and plotted on in for loop below
  plot_Linear = figure;
  plot_Nonlinear = figure;

% Establish variable names (due to use of eval function w/in for loop)
  time_linear = [];
  thetaDesired_linear = [];
  thetaActual_linear = [];
  
  time_saturation = [];
  thetaDesired_saturation = [];
  thetaActual_saturation = [];


% Create Cell Vector of Names to be used in plotting Data
  names_dataSets = {'P', 'PD', 'PID'};
  
for i = 1:3
% Get name of current data set
currentDataSet = names_dataSets{i};                                     
  
  % Linear Data
    % Extract time from the structure array at index
    eval(['time_linear = out.', currentDataSet, 'Lin_Time;']) 
    % Extract desired angle output from the structure array at index
    eval(['thetaDesired_linear = out.Lin_DesPos;'])                         
    % Extract actual angle output from the structure array at index
    eval(['thetaActual_linear = out.', currentDataSet, 'Lin_ActPos;'])      
    
  % Saturation Data
    % Extract time from the structure array at index
    eval(['time_saturation = out.', currentDataSet, 'Sat_Time;'])           
    % Extract desired angle output from the structure array at index
    eval(['thetaDesired_saturation = out.Sat_DesPos;'])                     
    % Extract actual angle output from the structure array at index
    eval(['thetaActual_saturation = out.', currentDataSet, 'Sat_ActPos;'])  
    
    desiredOutputString = 'Actual';
  % Plot to Linear
    % Call linear figure plot
    figure(plot_Linear);                                                    
    % If first iteration of foor loop, plot the desired output plot in addition to the actual
    if i == 1                                                               
        % Desired angle output
        plot(time_linear, thetaDesired_linear, '-b', 'LineWidth', 0.5, 'DisplayName', desiredOutputString) 
        hold on
        % Actual Angle Output
        plot(time_linear, thetaActual_linear, 'LineWidth', 0.5, 'DisplayName', currentDataSet) 
    else
        % Actual Angle Output
        plot(time_linear, thetaActual_linear, 'LineWidth', 0.5, 'DisplayName', currentDataSet)
    end

 
    
  % Plot to Saturated
    % Call nonlinear figure plot
    figure(plot_Nonlinear);                                                  
    % If first iteration of foor loop, plot the desired output plot in addition to the actual
    if i == 1                                                               
        % Desired angle output
        plot(time_saturation, thetaDesired_saturation, '-b', 'LineWidth', 0.5, 'DisplayName', desiredOutputString) 
        hold on
        % Actual Angle Output
        plot(time_saturation, thetaActual_saturation, 'LineWidth', 0.5, 'DisplayName', currentDataSet) 
    else
        % Actual Angle Output
        plot(time_saturation, thetaActual_saturation, 'LineWidth', 0.5, 'DisplayName', currentDataSet)
    end
    

end

%% Step 3: Plot Formatting
  size_text = 12;
  size_axes = 10;
  size_marker = 50;
  width_line = 1;
  size_cap = 18;
  colors = {[0.8500 0.3250 0.0980], [0.9290 0.6940 0.1250], [0.4940 0.1840 0.5560]};
  figure(plot_Linear);
  legend('AutoUpdate','off')
  title('Linear Simulink Model Response', 'FontSize', size_text)         

% Hardcoded x-limit to improve visibility
    xlim([0, 7.5])
    ylim([-2, 6])

  grid on                                                                   % Turn on Grid 
  xlabel('Time [s]', 'FontSize', size_text)                                 % Subplot x-axis Label
  ylabel('\theta [rad]', 'FontSize', size_text)                             % Subplot y-axis Label

  ax = gca;                                                                 % Subplot Axis handle
  ax.FontSize = size_axes;                                                  % Adjust subplot's axes label size
  hold off
  
  % Nonlinear Plot
% =========================================================================
  figure(plot_Nonlinear);
  legend('AutoUpdate','off')
  title('Nonlinear Simulink Model Response','FontSize', size_text)         

% Hardcoded x-limit to improve visibility
    xlim([0, 7.5])
    ylim([-2, 6])
    
  grid on                                                                   % Turn on Grid
  xlabel('Time [s]', 'FontSize', size_text)                                 % Subplot x-axis Label
  ylabel('\theta [rad]', 'FontSize', size_text)                             % Subplot y-axis Label

  % Hardcoded x-limit to improve visibility
    xlim([0, 7.5])

  ax = gca;                                                                 % Subplot Axis handle
  ax.FontSize = size_axes;                                                  % Adjust subplot's axes label size
  hold off