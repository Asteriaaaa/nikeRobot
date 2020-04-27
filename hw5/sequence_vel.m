%Algolrithm motion_model_odometry with Normal Distribution hat

clc
close all

%Initial setting of mobile robot
x = 100;
y =100;
theta =0;

a1 = 0.0001;
a2 = 0.0001;
a3 = 0.0001;
a4 = 0.0001;
a5 = 0.0001;
a6 = 0.0001;

trajectory_data = zeros(3,500,30);
odom = zeros(3,30);
odom(:,:) = NaN;
odom(:,1:3)= 0;

trajectory_data(:,:,:) = NaN;
trajectory_data(:,:,1) = 0;

n = 1;
t = 2;

while (t <= 30 )
if t < 10
    v=10;
    w=0;
 
elseif (t >= 10)&&(t < 12)
    v=10;
    w=-pi/640;
       
elseif (t >= 12)&&(t < 20)
    v=10;
    w=0;
    
elseif (t >= 20)&&(t < 22)
    v=10;
    w=-pi/640;
       
elseif (t >= 22)&&(t <= 30)
    v=10;
    w=0;
end

for n = 1: 500   
    v_hat = v-normrnd(0,a1*abs(v)+a2*abs(w));
    w_hat = w-normrnd(0,a3*abs(v)+a4*abs(w));
    gamma_hat = normrnd(0,a5*abs(v)+a5*abs(w));

x = trajectory_data(1,n,t-1) - v_hat*sin(theta)/w_hat+v_hat*sin(theta+w_hat*1)/w_hat;
y = trajectory_data(2,n,t-1)  + v_hat*cos(theta)/w_hat-v_hat*cos(theta+w_hat*1)/w_hat;
theta = theta + w_hat*1 + gamma_hat*1;
trajectory_data(1,n,t) = x;
trajectory_data(2,n,t) = y;
trajectory_data(3,n,t) = theta;

n = n + 1;
end

t = t + 1;
    v=10;
    w=pi/4;
    odom(1,t) = odom(1,t-1) + v*cos(theta);
    odom(2,t) = odom(2,t-1) + v*sin(theta)
    odom(3,t) = theta;
end

plot(odom(1,:),odom(2,:),'r','LineWidth',1.5);
hold on 

for m = 1:30
  scatter(trajectory_data(1,5:500,m),trajectory_data(2,5:500,m),'.');
  pause(1);
  hold on
end