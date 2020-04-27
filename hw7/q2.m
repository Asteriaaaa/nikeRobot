clc;
clear;
close all;


x = [0,0,300,300,600,600]
y = [0,400,0,400,0,400];
x=x';
y=y';
hold on;
axis([0 600 0 400]);
set(gca,'PlotBoxAspectRatio',[6 4 1]);
circleplot(300,200,20,0);
scatter(x, y, 'filled', 'r');
sigma = 10;
sample_times = 5000;
X = 600 * abs(randn(sample_times, 1));
Y = 400 * abs(randn(sample_times, 1));
ang = atan2(y-200, x-300);
dis  = pdist2([300, 200], [x, y]);
theta = 2 * pi * abs(randn(sample_times, 1));
w = zeros(sample_times, 1);
sum = 0;
figure(2);
hold on;
axis([0 600 0 400]);
set(gca,'PlotBoxAspectRatio',[6 4 1]);
circleplot(300,200,20,0);
scatter(x, y, 'filled', 'r');


for i = 1:sample_times
    a = atan2(y-Y(i), x-X(i)) - theta(i);
    w(i) = prod(normpdf(a, ang, sigma));
    rg = pdist2([X(i) Y(i)], [x y]);
    w(i) =  w(i) *  prod(normpdf(rg, dis, sigma));
    sum = sum + w(i);
end
w = w / sum;

quiver(X, Y, sin(theta), cos(theta), 0.3);

figure(3);
hold on;
axis([0 600 0 400]);
set(gca,'PlotBoxAspectRatio',[6 4 1]);
circleplot(300,200,20,0);
scatter(x, y, 'filled', 'r');
circleplot(300,200,20,0);
c = zeros(sample_times,1);
u =(length(w)^-1 )*rand(length(w),1);
c(1) = w(1);
rp =[];
rtheta=[]
n=1;
for i = 2:sample_times
        c(i) = c(i-1) + w(i);
end
i = 1;
for j = 1:sample_times
    while u(j) > c(i)
        if i + 1 > sample_times
            break;
        end
        i = i + 1;
    end
    rp(n,1) = X(i);
    rp(n,2) = Y(i);
    rtheta(n) = theta(i);
    n = n+1;
    u(j+1) = u(j) + length(w)^-1;
end
rtheta = rtheta';
quiver(rp(:,1), rp(:,2), sin(rtheta), cos(rtheta), 5);

function circleplot(xc, yc, r, theta)
t = 0 : .01 : 2*pi;
x = r * cos(t) + xc;
y = r * sin(t) + yc;
plot(x, y,'r','LineWidth',2)
t2 = 0 : .01 : r;
x = t2 * cos(theta) + xc;
y = t2 * sin(theta) + yc;
plot(x, y,'r','LineWidth',2)
end