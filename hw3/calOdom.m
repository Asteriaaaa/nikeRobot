function u = calOdom(wL, wR, time)
wheelRadius = 1;
wheelDistance = 1;
accel = 0.1;
theta = 0;
iniPos = [0,0,0];
T = 10; % [sec]
V = 0.5*wheelRadius*(wL+wR); % [m/s]
omega = (wR-wL)*wheelRadius/wheelDistance; % [deg/s]
theta = ToRadian(theta);

thetat = theta + omega*time + iniPos(3);
xt_fun = @(delT)(V + accel*delT).*cos(theta+delT*omega);
xt = integral(xt_fun, 0, time) + iniPos(1);
yt_fun = @(delT)(V + accel*delT).*sin(theta+delT*omega);
yt = integral(yt_fun, 0, time)  + iniPos(2);

u =[ V*(1-exp(-time/T)) ToRadian(omega)*(1-exp(-time/T))]';
end
