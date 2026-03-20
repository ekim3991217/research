Km = input('Km = ');
Tm = input('Tm = ');
Mp = input('Mp, in percent = ');
ts = input('ts, (sec) = ');
n_vector = input('Enter vector of n-value [n] = ');
Mp = Mp/100;

zeta = sqrt((log(Mp))^2/((log(Mp))^2+pi^2));
P_Kp = (1/(4*zeta^2))*(1/(Km*Tm));

wn = 4/(zeta*ts);
PD_Kp = (wn^2*Tm)/Km;
PD_Kd = (2*zeta*wn*Tm - 1)/Km;

for j = 1
    n = n_vector(j);
    sigma = n*zeta*wn;
    PID_Kp(j) = ((2*sigma*zeta*wn + wn^2)*Tm)/Km;
    PID_Ki(j) = (sigma*wn^2*Tm)/Km;
    PID_Kd(j) = ((2*zeta*wn + sigma)*Tm - 1)/Km;
end

fprintf('Proportional Controller\n');
fprintf('Kp = %g\n\n',P_Kp);
fprintf('PD Controller\n');
fprintf('Kp = %g\n',PD_Kp);
fprintf('Kd = %g\n\n',PD_Kd);

for j = 1;
    n = n_vector(j);
    fprintf('PID Controller n = %i\n',n);
    fprintf('Kp = %g\n',PID_Kp(j));
    fprintf('Kd = %g\n',PID_Kd(j));
    fprintf('Ki = %g\n\n',PID_Ki(j));
end

gains.P.Kp = P_Kp;
gains.PD.Kp = PD_Kp;
gains.PD.Kd = PD_Kd;
gains.PID.Kp = PID_Kp;
gains.PID.Ki = PID_Ki;
gains.PID.Kd = PID_Kd;

save('gains.mat','gains');