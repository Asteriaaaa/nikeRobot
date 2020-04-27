% simulates the differential drive robot for t time units 
% Differential dirve
% Input:
% Xi:
% vector(3):x,y,theta
% v: 
% 	linear velocity
% omega:
% 	angular velocity
% tmax:
% 	time period
% Output:
% 		X,y,theta:
% 			Robot position and oritation %
% function [x,y,theta] = diffDrive(xi,v,omega,tmax)
% x(1) = xi(1); 
% y(1) = xi(2);
% theta(1) = xi(3);
% deltat = 0.05;
% for t=1:tmax
%     x(t+1) = x(t) + v*deltat*cos(theta(t));
%     y(t+1) = y(t) + v*deltat*sin(theta(t));
%     theta(t+1) = theta(t) + omega*deltat;
% end
% end


% This function uses feedback control to make the robot go to some arbitrary position
% Go to a goal with pose
% Input:
% X_s:
% vector(3):x,y,theta
% X_g: 
% vector(3):x,y,theta
% Output:
% 		X,y,theta:
% 			Robot position and oritation

function simrun()
    st = [0,0,0];
    goal = [-10, -4, 30];

    open_loop(st, goal);
    feed_back(st, goal);
end

function [x,y,theta] = open_loop(X_s, X_g)

    X_s(3) = X_s(3)/180.0*pi;
    X_g(3) = X_g(3)/180.0*pi;

    T=0.01;
    k=2;
    x(k-1)=X_s(1); % initilize the state x
    y(k-1)=X_s(2); % initilize the state y
    theta(k-1)=X_s(3); % initilize the state theta
    tfinal=1000; % final simulation time
    t=0

    l=0.1;
    Vr=2; Vl=2;


    Vr = 0; Vl=0.2;
    W=(Vr-Vl)/l;
    r=l/2*(Vr+Vl)/(Vr-Vl);
    V=W*r;
    while(abs(theta(k-1) -X_g(3)) > 0.01)
        t=t+T;
        theta(k)=W*T+theta(k-1);
        if theta(k) < 0
            theta(k) = theta(k)+2*pi;
        else
            theta(k) = mod(theta(k), 2*pi);
        end
        x(k)=V*cos(theta(k))*T+x(k-1);
        y(k)=V*sin(theta(k))*T+y(k-1);
        k=k+1;
    end

    k1 = tan(theta(k-1));
    b1 = y(k-1) - k1*x(k-1);
    k2 = -1/k1;
    b2 = X_g(2) - k2* X_g(1);

    destination_x=(b2-b1)/(k1-k2);
    destination_y=k1*destination_x + b1;

    Vr=0.2; Vl=0.2;   %Vr=Vl =>straight
    W=(Vr-Vl)/l;
    r=inf;
    V=Vr;
    %V = sign(destination_x - x(k-1))*V;
    dist = ((destination_x-x(k-1))^2 + (destination_y-y(k-1))^2)^0.5 ;
    step = 0;
    changed_dir = false;
    error=ones(k-1);
    while ( ( (destination_x-x(k-1))^2 + (destination_y-y(k-1))^2)^0.5> 0.05)
        %error(k) = ((destination_x-x(k-1))^2 + (destination_y-y(k-1))^2)^0.5;
        t=t+T;
        theta(k)=W*T+theta(k-1); % calculating theta
        x(k)=V*cos(theta(k))*T+x(k-1); % calculating x
        y(k)=V*sin(theta(k))*T+y(k-1); % calculating y
        k=k+1; % increase the sampling counter
        step = step + 1;
        a = (((destination_x-x(k-1))^2 + (destination_y-y(k-1))^2)^0.5) - dist;
        if ((((destination_x-x(k-1))^2 + (destination_y-y(k-1))^2)^0.5) - dist > 5 && changed_dir == false)
            V = -V;
            changed_dir = true;
        end
    end


    Vr=0.2; Vl=0   %Vr>Vl =>anticlockwise
    V= 2;
    distance = pi*(((X_g(1) - x(k-1))^ 2 + (X_g(2) - y(k-1)) ^ 2)^0.5) / 2;
    time = distance / V;
    W = pi / time;
    %distance_unit = distance / pi;


    %W=(Vr-Vl)/l;
    %r=l/2*(Vr+Vl)/(Vr-Vl);
    %V=W*((((X_g(1) - x(k-1))^ 2 + (X_g(2) - y(k-1)) ^ 2)^0.5)/2);
    iter = 0;
    angle = 0;
    changed_dir = false;
    while (( (X_g(1)-x(k-1))^2 + (X_g(2)-y(k-1))^2)^0.5> 0.05 && iter < 10000)
        
        if (mod(iter, 10) == 0)
            if ((((X_g(1) - x(k-1))^ 2 + (X_g(2) - y(k-1)) ^ 2)^0.5) > distance+0.1 && changed_dir == false)
                W = -W;
                V = -V;
                angle = -angle;
                changed_dir = true;
            end
        end
        
        if (changed_dir == true && angle > 0)
            V = -V;
            changed_dir = false;
        end
        
        t=t+T;
        angle = abs(W*T) + angle;
        theta(k)=W*T+theta(k-1); % calculating theta
        x(k)=V*cos(theta(k))*T+x(k-1); % calculating x
        y(k)=V*sin(theta(k))*T+y(k-1); % calculating y
        k=k+1; % increase the sampling counter
        iter = iter+1;
    end

    if (abs(theta(k-1) - X_g(3)) >0.5)
        angle = 0;
        W=pi/6;
        r=0.01;
        V=W*r;
        while (angle < pi)
            t=t+T;
            theta(k)=W*T+theta(k-1); % calculating theta
            x(k)=V*cos(theta(k))*T+x(k-1); % calculating x
            y(k)=V*sin(theta(k))*T+y(k-1); % calculating y
            k=k+1; % increase the sampling counter
            angle = angle + W*T;
        end

    end

    % Vr=2; Vl=2;   %Vr>Vl =>straight
    % W=(Vr-Vl)/l;
    % r=inf;
    % V=Vr;
    % while (abs(y(k-1)-X_g(2)) > 0.1)
    %     t=t+T;
    %     theta(k)=W*T+theta(k-1); % calculating theta
    %     x(k)=V*cos(theta(k))*T+x(k-1); % calculating x
    %     y(k)=V*sin(theta(k))*T+y(k-1); % calculating y
    %     k=k+1; % increase the sampling counter
    % end
    
    figure;
    axis equal;
    hold on
    plot(x,y);
   

end





function [x,y,theta] = feed_back(X_s, X_g)
    %%% timestep length
    Delta = 0.01;
    %%% transfer to radius degree
    X_s(3) = X_s(3)/180.0*pi;
    X_g(3) = X_g(3)/180.0*pi;
    %%% control law parameters, k in the class ppt
    K_rho = 0.2 ;
    K_alpha = 1;
    K_beta = -0.3;
    %%% Maximum Distance and angular difference to be considered as close enough
    Max_dis_res = 0.0001;
    Max_ang_res = 0.01;
    Max_iteration = 5000;
    t = 1;
    %%% initialization of pos
    x_t = X_s(1);
    y_t = X_s(2);
    theta_t = X_s(3);
    x = x_t;
    y = y_t;
    theta = theta_t;
    %%% loop until [x, y] is near x_g
    FLAG_GOAL = false;
    
    %%%  compute the Transition
    X_g_inv = [cos(X_g(3)), sin(X_g(3));-sin(X_g(3)),cos(X_g(3))]*[-X_g(1);-X_g(2)];
    T = [cos(X_g(3)), sin(X_g(3)),X_g_inv(1);...
            -sin(X_g(3)), cos(X_g(3)),X_g_inv(2);...
            0,                          0,                     1];
    while FLAG_GOAL == false && t<Max_iteration
        t = t +1;
        %%% control law to compute v, omega
        pos_new=T*[x_t;y_t;1];
        theta_t_new = theta_t - X_g(3);
         
         rho = sqrt(pos_new(1) * pos_new(1) +  pos_new(2) * pos_new(2));
         
         
         alpha = -theta_t_new + atan2(-(pos_new(2)), -(pos_new(1)));
        
         beta = -theta_t_new - alpha;
          if (alpha > pi)
             alpha = alpha - 2*pi;
         elseif (alpha < -pi)
             alpha = alpha + 2*pi;
         end
         
         
         if (beta > pi)
             beta = beta - 2*pi;
         elseif (alpha < -pi)
             beta = beta + 2*pi;
         end
             
         
         v = K_rho * rho;
         omega = K_alpha * alpha + K_beta * beta;
         
         %%% update x, y and theta
         x_t = x_t + v*cos(theta_t)*Delta;
         y_t = y_t + v*sin(theta_t)*Delta;
         theta_t = theta_t + omega * Delta;
         if (theta_t > pi)
               theta_t = theta_t - 2*pi;
         elseif (theta_t < -pi)
               theta_t = theta_t + 2*pi;
         end
         %%% store pos to set
         x = [x, x_t];
         y = [y, y_t];
         theta = [theta, theta_t];
         %%% update FLAG_GOAL
         DIS_FLAG = sqrt((X_g(1)-x_t) * (X_g(1)-x_t) + (X_g(2)-y_t) * (X_g(2)-y_t)) <= Max_dis_res;
         ANG_FLAG = beta<=Max_ang_res;
         if (DIS_FLAG && ANG_FLAG)
             FLAG_GOAL = true;
         end

    end

         figure;
         hold on
         plot(x,y);
        

end