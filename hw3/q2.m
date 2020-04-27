clear; clc;

 SatellitePosition=[13789 17567 5375;15126 -9999 22222;23333 -14514 19198];

scatter3(SatellitePosition(1:3,1:1),SatellitePosition(1:3,2:2),SatellitePosition(1:3,3:3),'*')
hold on;
UserPosition=[6400 1000 -5000 ];
disp(UserPosition);
scatter3(UserPosition(1),UserPosition(2),UserPosition(3),'.');
hold on;

Prange=CalculatePseudoRange(SatellitePosition, UserPosition);
CalculateUserPosition2(SatellitePosition, Prange);

function Prange=CalculatePseudoRange(SatellitePosition,UserPosition)
   Prange = sqrt((SatellitePosition(:,1)-UserPosition(1)).^2+(SatellitePosition(:,2)-UserPosition(2)).^2+(SatellitePosition(:,3)-UserPosition(3)).^2);
end

function CalculateUserPosition2(SatellitePosition,Prange)
    s =  SatellitePosition(1:3,:,:);
    d = Prange;
    c=3e8;
    T = 100;
    delT = -d / c+T;
    
    [p,fval] = fsolve(@(p)getPos(p,SatellitePosition(:,1),SatellitePosition(:,2),SatellitePosition(:,3),delT,c),[0 0 0 ]);
    scatter3(p(1), p(2),p(3),'d');
    disp(p);
    hold on;
    for i=1:length(SatellitePosition)
    plot3([SatellitePosition(i,1),p(1)],[SatellitePosition(i,2),p(2)],[SatellitePosition(i,3),p(3)]);
end
end

function f = getPos(p,x,y,z,delT,c)
a=c*(100-delT);
f = [sqrt((x(1)-p(1))^2+(y(1)-p(2))^2+(z(1)-p(3))^2)-c*(100-delT(1));
    sqrt((x(2)-p(1))^2+(y(2)-p(2))^2+(z(2)-p(3))^2)-c*(100-delT(2));
    sqrt((x(3)-p(1))^2+(y(3)-p(2))^2+(z(3)-p(3))^2)-c*(100-delT(3))];
end
