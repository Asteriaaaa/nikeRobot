rosshutdown
rosinit
targetMap = ExampleHelperRobotSimulator('simpleMap');
setRobotPose(targetMap, [2 3 -pi/2]);
enableROSInterface(targetMap, true);
sim.LaserSensor.Numreadings=50;
scanSub = rossubscriber('scan');
[velPub, velMsg] = rospublisher('/mobile_base/commands/velocity');
tftree = rostf;
pause(1);
path = [2,3; 3.25 6.25; 2 11; 6 7; 11 11; 8 6; 10 5; 7 3; 11 1.5];
plot(path(:,1), path(:,2),'k--d');
controller = robotics.PurePursuit('Waypoints', path);
controller.DesiredLinearVelocity = 0.4;
controlRate = robotics.Rate(10);
goalRadius = 0.1;
robotCurrentLocation = path(1,:);
robotGoal = path(end,:);
distanceToGoal = norm(robotCurrentLocation - robotGoal);
map = robotics.OccupancyGrid(25,25,20);
figureHandle = figure('Name', 'Map');
axesHandle = axes('Parent', figureHandle);
mapHandle = show(map, 'Parent', axesHandle);
title(axesHandle, 'OccupancyGrid: Update 0');
updateCounter = 1;
while( distanceToGoal > goalRadius )
    scanMsg = receive(scanSub);
    pose = getTransform(tftree, 'map', 'robot_base', scanMsg.Header.Stamp, 'Timeout', 2);
    position = [pose.Transform.Translation.X, pose.Transform.Translation.Y];
    orientation =  quat2eul([pose.Transform.Rotation.W, pose.Transform.Rotation.X, ...
        pose.Transform.Rotation.Y, pose.Transform.Rotation.Z], 'ZYX');
    robotPose = [position, orientation(1)];
    scan = lidarScan(scanMsg);
    ranges = scan.Ranges;
    ranges(isnan(ranges)) = targetMap.LaserSensor.MaxRange;
    modScan = lidarScan(ranges, scan.Angles);
    insertRay(map, robotPose, modScan, targetMap.LaserSensor.MaxRange);
    [v, w] = controller(robotPose);
    velMsg.Linear.X = v;
    velMsg.Angular.Z = w;
    send(velPub, velMsg);
    if ~mod(updateCounter,50)
        mapHandle.CData = occupancyMatrix(map);
        title(axesHandle, ['OccupancyGrid: Update ' num2str(updateCounter)]);
    end
    updateCounter = updateCounter+1;
    distanceToGoal = norm(robotPose(1:2) - robotGoal);
    waitfor(controlRate);
end
show(map, 'Parent', axesHandle);
title(axesHandle, 'OccupancyGrid: Final Map');
rosshutdown
displayEndOfDemoMessage(mfilename)