% Name: Eugene Kim 
% GTID: 903403715
% Fall 2022 ME 4056 Systems Lab 
% Lab: IC Engine
% HW

clear 
clc
close all

%% data import
calib = readtable('IC_Engine_HW_Fall2022_modded.xlsx', 'Sheet', 'sheet1'); 
accel = readtable('IC_Engine_HW_Fall2022_modded.xlsx', 'Sheet', 'sheet2'); 
SS = readtable('IC_Engine_HW_Fall2022_modded.xlsx', 'Sheet', 'sheet3'); 

%% calibration plot 

voltage = calib.voltage; 
mass_num = calib.mass_num; 

% constants
mass_kg = calib.mass_each_kg; 
mass_kg = mass_kg(~isnan(mass_kg));
moment_m = calib.moment_m; 
moment_m = moment_m(~isnan(moment_m));

moment_force = mass_num * mass_kg * moment_m * 9.81; 

% plotting
figure(1)
plot(voltage, moment_force, 'o')
hold on
grid on

type = 'poly1'; 
[fit1 rsme] = fit(voltage, moment_force, type); 
% disp(rsme)
gain = fit1.p1;
fprintf('G = %.4d\n', gain)

plot(fit1, '--')

% labels 
xlabel('Voltage [V]')
ylabel('Moment Force [N * m]')
title('Calibration Equation: Voltage v. Force')
legend('Data Point', 'T = 1.28 * V + 1.171')
hold off

% uncertainty calculation 


%% average angular velocity v. angular position 
angular_vel_avg = accel.Avg_EncoderVelocity___sec__Plot0;
angular_vel_avg = angular_vel_avg(~isnan(angular_vel_avg)); 
angular_pos = accel.x10_BucketNumber_Plot0_1 * 10; 
angular_pos = angular_pos(~isnan(angular_pos)); 

figure(2)
plot(angular_pos, angular_vel_avg)
% labels 
xlabel('Incremental Angular Position [deg]')
ylabel('Angular Velocity [deg/s]')
title('Averaged Velocity Data v. Angular Position')
legend('Averaged Velocity Data')

%% average torque v. angular posiion 
torque_avg = accel.Avg_ForceTrans_Voltage_V__Plot0 * 1.28 - 1.171; 
torque_avg = torque_avg(~isnan(torque_avg)); 
% torque_avg = accel.ForceTransducerVoltage_V__Plot0; 

figure(3)
plot(angular_pos, torque_avg)
% labels 
xlabel('Incremental Angular Position [deg]')
ylabel('Torque [N * m]')
title('Averaged Torque Data v. Angular Position')
legend('Averaged Torque Data')

%% energy analysis 
% work by a to b 
work_ab = sum(torque_avg * 10 * (pi./180)); 
fprintf('W_a,b = %.4d\n', work_ab)

% motor work uncertainty 

% friction due to torque 
torque_friction = - mean(torque_avg(find(angular_pos == 1780):end)); 
fprintf('T_friction = %.4d\n', torque_friction)

% moment of inertia 

%% representative cycle
angular_vel_avg = SS.Avg_EncoderVelocity___sec__Plot0;
angular_vel_avg = angular_vel_avg(~isnan(angular_vel_avg)); 
angular_pos = SS.x10_BucketNumber_Plot0_1 * 10; 
angular_pos = angular_pos(~isnan(angular_pos)); 

figure(4)
plot(angular_pos, angular_vel_avg)
% labels 
xlabel('Incremental Angular Position [deg]')
ylabel('Angular Velocity [deg/s]')
title('All Stroke: Averaged Velocity Data v. Angular Position')
legend('Averaged Velocity Data')

%% average torque v. angular posiion 
torque_avg = SS.Avg_ForceTrans_Voltage_V__Plot0 * 1.28 - 1.171; 
torque_avg = torque_avg(~isnan(torque_avg)); 
% torque_avg = accel.ForceTransducerVoltage_V__Plot0; 

figure(5)
plot(angular_pos, torque_avg)
% labels 
xlabel('Incremental Angular Position [deg]')
ylabel('Torque [N * m]')
title('All Stroke: Averaged Torque Data v. Angular Position')
legend('Averaged Torque Data')

start_ind = find(angular_pos == 1190); 
end_ind = find(angular_pos == 2000); 

figure(6)
plot(0:end_ind - start_ind, angular_vel_avg(start_ind:end_ind)')
xlabel('Incremental Angular Position [deg]')
ylabel('Angular Velocity [deg/s]')
title('Representative Stroke: Averaged Velocity Data v. Angular Position')
legend('Averaged Velocity Data', 'Location', 'southeast')

start_ind = find(angular_pos == 1850); 
end_ind = find(angular_pos == 2720); 
angular_pos = 0:end_ind - start_ind; 

figure(7)
plot(angular_pos, torque_avg(start_ind:end_ind)')
xlabel('Incremental Angular Position [deg]')
ylabel('Torque [N * m]')
title('Representative Stroke: Averaged Torque Data v. Angular Position')
legend('Averaged Torque Data', 'Location', 'southeast')

torque_avg = torque_avg(start_ind:end_ind); 

ind1 = find(angular_pos == 17);
ind2 = find(angular_pos == 45);
ind3 = find(angular_pos == 68);


work_intake = sum(torque_avg(1:ind1) .* 10 .* (pi./180)); 
% fprintf('W_intake = %.4d\n', work_intake)
disp(work_intake)

work_compression = sum(torque_avg(ind1:ind2) .* 10 .* (pi./180)); 
% fprintf('W_compression = %.4d\n', work_compression)
disp(work_compression)

work_ignition = sum(torque_avg(ind2:ind3) .* 10 .* (pi./180)); 
% fprintf('W_ignition = %.4d\n', work_ignition)
disp(-work_ignition)

work_exhaustion = sum(torque_avg(ind3:end) .* 10 .* (pi./180)); 
% fprintf('W_exhaustion = %.4d\n', work_exhaustion)
disp(-work_exhaustion)




