% ***********************************************************************
% Draw the Body on the background based on the angles of BODY.pose
% ***********************************************************************

function drawMan

bodyColor = [0.8, 0.7, 0.6]; % RGB color space for shaded body parts
ColorsS = [0.5 0.7 1; 0.1 1 0.2; 1 0.6 0.3]; % 3 distinct RGB color spaces for the springs

load('coordinatesMan.mat')

hip =   [0      0];
knee =  [0     -0.4451];
ankle = [0.02  -1.03];
toe =   [0.30367  -1.129];

kneeBand(1,:) = [-0.117279:0.001:0.082721];
kneeBand(2,:) = knee(2)*ones(length(kneeBand(1,:)),1);
ankleBand(1,:) = [-0.062005286:0.001:0.10141705];
ankleBand(2,:) = ankle(2)*ones(length(ankleBand(1,:)),1);


plot(C(:,1),C(:,2),'.','Color',bodyColor)
hold on
plot(thigh(:,1),thigh(:,2),'.','Color',ColorsS(3,:))
plot(shank(:,1),shank(:,2),'.','Color',ColorsS(1,:))
plot(kneeBand(1,:),kneeBand(2,:),'Color',ColorsS(3,:),'linewidth',6)
plot(ankleBand(1,:),ankleBand(2,:),'Color',ColorsS(1,:),'linewidth',6)
axis equal
axis off
%scatter(hip(1),hip(2),30,'k','filled') % hip
scatter(knee(1),knee(2),30,'k','filled') % knee
scatter(ankle(1),ankle(2),30,'k','filled') % ankle
scatter(toe(1),toe(2),30,'k','filled') % toe

end