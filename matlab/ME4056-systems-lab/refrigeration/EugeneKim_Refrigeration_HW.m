% Name: Eugene Kim 
% GTID: 903403715
% Fall 2022 ME 4056 Systems Lab 
% Lab: IC Engine
% HW

clear 
clc
close all

%% data import
data = readtable('Refrigeration HW.xlsx'); 

PSI_nom = data.NominalPSI; 
P3_gauge = data.P3_PSIGauge_ * 6895; 

T4_hot_F = data.T_4hot__F_; 
T4_cold_F = data.T_4cold__F_; 
T_load_F = data.T_load__F_; 
T5_F = data.T_5__F_; 

V_cold_L_min = data.V__cold_L_min_; 
V_hot_L_min  = data.V__hot_L_min_; 

R = 287; 

%% CONVERSION 
% tempertaure calculation 
T4_hot_K = (5/9) .* (T4_hot_F - 32) + 273.15; 
T4_cold_K = (5/9) .* (T4_cold_F - 32) + 273.15;  
T_load_K = (5/9) .* (T_load_F - 32) + 273.15; 
T5_K = (5/9) .* (T5_F - 32) + 273.15; 

disp(T4_hot_K)

% volume conversion 
V_cold = V_cold_L_min .* (1/60000); 
V_hot = V_hot_L_min .* (1/60000); 

% pressure conversion 
P_amb = P3_gauge .* 100; 

% mass rate conversion 
m_rate_cold = P_amb .* V_cold ./ (R .* T5_K);
m_rate_hot = P_amb .* V_hot ./ (R .* T4_hot_K);

% display result
disp(T4_cold_K)
disp(T_load_K)
disp(T5_K)

disp(m_rate_cold)
disp(m_rate_hot)
disp(P_amb)

%% REGRESSION FIT
type  = 'poly1'; 

[a1 b1] = fit(P3_gauge, T4_cold_K, type); 
[a2 b2] = fit(P3_gauge,T4_hot_K, type); 
[a3 b3] = fit(P3_gauge, m_rate_cold, type); 
[a4 b4] = fit(P3_gauge, m_rate_hot, type);

disp(a1)
disp(a2)
disp(a3)
disp(a4)

%% PLOTTING
figure(1)
plot(P3_gauge, T4_cold_K, 'o')
hold on 
plot(a1, '--')
hold off
grid on
% labels 
ylabel('Cold side temperautre [K]')
xlabel('Pressure [N/m^2]')
title('Cold side temperature  v. Pressure')
legend('y  = -3.711e-05*x + 292')
292
figure(2)
plot(P3_gauge, T4_hot_K, 'o')
hold on 
plot(a2, '--')
hold off
grid on
% labels 
ylabel('Hot side temperautre [K]')
xlabel('Pressure [N/m^2]')
title('Hot side temperature  v. Pressure')
legend('y  = 9.234e-05*x + 294.4')

figure(3)
plot(P3_gauge, m_rate_cold, 'o')
hold on 
plot(a3, '--')
hold off
grid on
% labels 
ylabel('Cold side mass flow rate [kg/s]')
xlabel('Pressure [N/m^2]')
title('Cold side mass flow rate v. Pressure')
legend('y  =  5.903e-07*x - 0.03733')

figure(4)
plot(P3_gauge, m_rate_hot, 'o')
hold on 
plot(a4, '--')
hold off
grid on
% labels 
ylabel('Hot side mass flow rate [kg/s]')
xlabel('Pressure [N/m^2]')
title('Hot side mass flow rate v. Pressure')
legend('y  = 2.77e-07*x - 0.0126')

%% CALCULATE RESISTANCE
c_p = 1006; 
c_load = 900; 

Q_amb = m_rate_cold .* c_p .* (T5_K - T4_cold_K); 
R_ins = 1 ./ Q_amb .* (21 + 273.15 - T_load_K);
% disp(Q_amb)
disp(R_ins)

% accel = readtable('IC_Engine_HW_Fall2022_modded.xlsx', 'Sheet', 'sheet2'); 
% SS = readtable('IC_Engine_HW_Fall2022_modded.xlsx', 'Sheet', 'sheet3'); 
% 
% %% calibration plot 
% 
% voltage = calib.voltage; 
% mass_num = calib.mass_num; 
% 
% % constants
% mass_kg = calib.mass_each_kg; 
% mass_kg = mass_kg(~isnan(mass_kg));
% moment_m = calib.moment_m; 
% moment_m = moment_m(~isnan(moment_m));
% 
% moment_force = mass_num * mass_kg * moment_m * 9.81; 
% 
% % plotting
% figure(1)
% plot(voltage, moment_force, 'o')
% hold on
% grid on
% 
% type = 'poly1'; 
% [fit1 rsme] = fit(voltage, moment_force, type); 
% % disp(rsme)
% gain = fit1.p1;
% fprintf('G = %.4d\n', gain)
% 
% plot(fit1, '--')
% 
% % labels 
% xlabel('Voltage [V]')
% ylabel('Moment Force [N * m]')
% title('Calibration Equation: Voltage v. Force')
% legend('Data Point', 'T = 1.28 * V + 1.171')
% hold off
% 
% % uncertainty calculation 
% 
% 
% %% average angular velocity v. angular position 
% angular_vel_avg = accel.Avg_EncoderVelocity___sec__Plot0;
% angular_vel_avg = angular_vel_avg(~isnan(angular_vel_avg)); 
% angular_pos = accel.x10_BucketNumber_Plot0_1 * 10; 
% angular_pos = angular_pos(~isnan(angular_pos)); 
% 
% figure(2)
% plot(angular_pos, angular_vel_avg)
% % labels 
% xlabel('Incremental Angular Position [deg]')
% ylabel('Angular Velocity [deg/s]')
% title('Averaged Velocity Data v. Angular Position')
% legend('Averaged Velocity Data')
% 
% %% average torque v. angular posiion 
% torque_avg = accel.Avg_ForceTrans_Voltage_V__Plot0 * 1.28 - 1.171; 
% torque_avg = torque_avg(~isnan(torque_avg)); 
% % torque_avg = accel.ForceTransducerVoltage_V__Plot0; 
% 
% figure(3)
% plot(angular_pos, torque_avg)
% % labels 
% xlabel('Incremental Angular Position [deg]')
% ylabel('Torque [N * m]')
% title('Averaged Torque Data v. Angular Position')
% legend('Averaged Torque Data')
% 
% %% energy analysis 
% % work by a to b 
% work_ab = sum(torque_avg * 10 * (pi./180)); 
% fprintf('W_a,b = %.4d\n', work_ab)
% 
% % motor work uncertainty 
% 
% % friction due to torque 
% torque_friction = - mean(torque_avg(find(angular_pos == 1780):end)); 
% fprintf('T_friction = %.4d\n', torque_friction)
% 
% % moment of inertia 
% 
% %% representative cycle
% angular_vel_avg = SS.Avg_EncoderVelocity___sec__Plot0;
% angular_vel_avg = angular_vel_avg(~isnan(angular_vel_avg)); 
% angular_pos = SS.x10_BucketNumber_Plot0_1 * 10; 
% angular_pos = angular_pos(~isnan(angular_pos)); 
% 
% figure(4)
% plot(angular_pos, angular_vel_avg)
% % labels 
% xlabel('Incremental Angular Position [deg]')
% ylabel('Angular Velocity [deg/s]')
% title('All Stroke: Averaged Velocity Data v. Angular Position')
% legend('Averaged Velocity Data')
% 
% %% average torque v. angular posiion 
% torque_avg = SS.Avg_ForceTrans_Voltage_V__Plot0 * 1.28 - 1.171; 
% torque_avg = torque_avg(~isnan(torque_avg)); 
% % torque_avg = accel.ForceTransducerVoltage_V__Plot0; 
% 
% figure(5)
% plot(angular_pos, torque_avg)
% % labels 
% xlabel('Incremental Angular Position [deg]')
% ylabel('Torque [N * m]')
% title('All Stroke: Averaged Torque Data v. Angular Position')
% legend('Averaged Torque Data')
% 
% start_ind = find(angular_pos == 1190); 
% end_ind = find(angular_pos == 2000); 
% 
% figure(6)
% plot(0:end_ind - start_ind, angular_vel_avg(start_ind:end_ind)')
% xlabel('Incremental Angular Position [deg]')
% ylabel('Angular Velocity [deg/s]')
% title('Representative Stroke: Averaged Velocity Data v. Angular Position')
% legend('Averaged Velocity Data', 'Location', 'southeast')
% 
% start_ind = find(angular_pos == 1850); 
% end_ind = find(angular_pos == 2720); 
% angular_pos = 0:end_ind - start_ind; 
% 
% figure(7)
% plot(angular_pos, torque_avg(start_ind:end_ind)')
% xlabel('Incremental Angular Position [deg]')
% ylabel('Torque [N * m]')
% title('Representative Stroke: Averaged Torque Data v. Angular Position')
% legend('Averaged Torque Data', 'Location', 'southeast')
% 
% torque_avg = torque_avg(start_ind:end_ind); 
% 
% ind1 = find(angular_pos == 17);
% ind2 = find(angular_pos == 45);
% ind3 = find(angular_pos == 68);
% 
% 
% work_intake = sum(torque_avg(1:ind1) .* 10 .* (pi./180)); 
% % fprintf('W_intake = %.4d\n', work_intake)
% disp(work_intake)
% 
% work_compression = sum(torque_avg(ind1:ind2) .* 10 .* (pi./180)); 
% % fprintf('W_compression = %.4d\n', work_compression)
% disp(work_compression)
% 
% work_ignition = sum(torque_avg(ind2:ind3) .* 10 .* (pi./180)); 
% % fprintf('W_ignition = %.4d\n', work_ignition)
% disp(-work_ignition)
% 
% work_exhaustion = sum(torque_avg(ind3:end) .* 10 .* (pi./180)); 
% % fprintf('W_exhaustion = %.4d\n', work_exhaustion)
% disp(-work_exhaustion)