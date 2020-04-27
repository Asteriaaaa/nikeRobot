clc;
clear;
close all;
% figure(1)is already generate
hold on;
axis([0 600 0 400]);
set(gca,'PlotBoxAspectRatio',[6 4 1]);
r = 250;
xc = 300;
yc = 0;
t = 0 :.01 : pi;
x = r * cos(t) + xc;
y = r * sin(t) + yc;
[x1, y1] = sample(300, 400, length(t), t, 250, -1)
plot(x, y,'k','LineWidth',2);
plot(xc, yc,'.r','LineWidth',5);

xc=300;
yc=400;
t = 0 : .01 : pi;
x = r * cos(t) + xc;
y = -r * sin(t) + yc;
[x2, y2] = sample(300, 0, length(t), t, 250, 1);
plot(x, y,'k','LineWidth',2)
plot(xc, yc,'.r','LineWidth',5);

r=632;
xc=0;
yc=0;
t = 0 : .01 : pi/2;
x = r * cos(t) + xc;
y = r * sin(t) + yc;
[x3, y3] = sample(0, 0, length(t), t, 632,1);
plot(x, y,'k','LineWidth',2)
plot(xc, yc,'.r','LineWidth',5);


figure(2); % figure(2) you should generate sample base on figure(1)
mu = 2;
sigma = 20;
hold on;
axis([0 600 0 400]);
set(gca,'PlotBoxAspectRatio',[6 4 1]);

% generate you your sample point here
circleplot(530,200,20,pi); % drawing the robot

p = [x1 y1; x2 y2; x3 y3];
w = [];
sum = 0;
for i = 1:length(p)
    xc = 300;yc = 0;
    d1 = pdist2(p(i,:), [xc yc]);
    xc=300;yc=400;
    d2 = pdist2(p(i,:), [xc yc]);
    xc=0;yc=0;
    d3 = pdist2(p(i,:), [xc yc]);
    w(i) = normpdf(d1, 250, sigma) * normpdf(d2, 250, sigma) * normpdf(d3, 632, sigma);
    sum = sum + w(i);
end
w = w/sum


figure(3);
hold on;
axis([0 600 0 400]);
set(gca,'PlotBoxAspectRatio',[6 4 1]);
% figure(3) implement your resampling algorithm
c = [];
u =(length(w)^-1 )*rand(length(w),1);
c(1) = w(1);
rp =[];
n=1;
for i = 2:length(w)
    c(i) = c(i-1) + w(i);
end
i = 1;
for j = 1:length(w)
    while u(j) > c(i)
        if i + 1 > length(w)
            break;
        end
        i = i + 1;
    end
    rp(n,1) = p(i,1);
    rp(n,2) = p(i,2);
    n = n + 1
    u(j+1) = u(j) + length(w)^-1;
end
scatter(rp(:, 1), rp(:, 2),'filled');
circleplot(530,200,20,pi); % drawing the robot


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

function [x_sample, y_sample] = sample(xc, yc, len, t, r, sign)
sigma = 20;
x_sample = cos(t)' .* r + xc;
y_sample = sign*sin(t)' .* r + yc;
x_sample = sigma * randn(len, 1) + x_sample;
y_sample = sigma * randn(len, 1) + y_sample;
scatter(x_sample, y_sample,'filled');
plot(xc, yc,'.r','LineWidth',5);
end
