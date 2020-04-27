clc;clear all;close all;
mobile_robot_NN();
%% assignment
function drawField()
[X,Y]=meshgrid(-1:0.05:1,-1:0.05:1);
%====================Attraction================================
% u=-X;
% v=-Y;
%====================Repulsion================================
u=X;
v=Y;
%====================Uniform/Perpendicularl================================
% u=ones(41);
% v=zeros(41);
% u=zeros(41);
% v=ones(41);
%% plot

%====================Tangent================================
V=sqrt((X).^2 + (Y).^2)*2;
sintheta=2.*Y./V;
u=V.*sintheta;
v=V.*(sqrt(1-(sintheta.^2))).*(X<=0) - V.*(sqrt(1-(sintheta.^2))).*(X>0) ;
%===============================================
quiver(X,Y,u,v,1);
end



function mobile_robot_NN()
%% =========== Set the paramters =======
drawField();
T=0.001; % Sampling Time
R=1;
k=2; % Sampling counter
x(k-1)=0.52; % initilize the state x
y(k-1)=0.52; % initilize the state y
tfinal=100; % final simulation time
t=0; % intilize the time 
%=====================================
while(t<=tfinal) 
t=t+T; % increase the time
W=1; 
% =========== Tangentical ==========
Ve=sqrt((x(k-1))^2 + (y(k-1)).^2)*2;
sinthe=2*y(k-1)/Ve;
u=Ve*sinthe;
v=0.0;
if (x(k-1)<=0)
    v=Ve*(sqrt(1-(sinthe^2)));
else
    v=-Ve*(sqrt(1-(sinthe^2)));
end
% ====================================

%================= Repulsion =========
% if(x(k-1)^2 + y(k-1)^2 < 2*R^2)
% u=x(k-1);
% v=y(k-1);
% else
% u=0;
% v=0;
% end
%================ Attraciton ==========
% if(x(k-1)^2 + y(k-1)^2 < R^2)
% u=-x(k-1);
% v=-y(k-1);
% else
% u=0;
% v=0;
% end
%===============Constant==============
% u=1;
% v=0;
%==============
% u=0;
% v=1;
x(k)=u*T+x(k-1); % calculating x
y(k)=v*T+y(k-1); % calculating y
draw_robot(); % Draw the robot and it's path
k=k+1; % increase the sampling counter
end

function draw_robot()
xmin=-1.2; % setting the figure limits 
xmax=1.2;
ymin=-1.2;
ymax=1.2;
plot(x,y,'-r') % Dawing the Path
axis([xmin xmax ymin ymax]) % setting the figure limits
axis square
hold on
drawField();
% Body

drawnow 
hold off
end
end
