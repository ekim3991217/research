clear 
clc 
close

%%
table1 = readtable('Step_dummy_2_25.xlsx'); 

t = table1.time; 
omega = table1.omega; 

plot(t, omega)

%% 
table2 = readtable('V_OmegaSS_t_dummy_data.xlsx'); 

V = table2.Voltage; % voltage
omega = table2.Omega_ss; 
time = table2.Time_Omega_Star; 

type = 'poly1'; 

figure
plot(V, omega, 'o')
xlabel('Voltage (V)'); 
ylabel('Omega_ss'); 
title('Omega Star v. Input Voltage'); 

min = .2;
max = 8; 
mask = min <= V & V <= max; 

V = V(mask); 
omega = omega(mask); 
time = time(mask); 

figure
plot(V, omega, 'o')
xlabel('Voltage (V)'); 
ylabel('Omega_ss'); 
title('Omega Star v. Input Voltage (Linear Region)'); 

[p3 S mu] = fit(V, omega, type); 
disp(p3)
disp(S)
disp(mu)

% disp(std(omega)); 

disp(mean(time)); 
