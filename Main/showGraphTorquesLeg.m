% ***********************************************************************
% Plot the ExoNET torques superimposed on the desired torques
% ***********************************************************************

function showGraphTorquesLeg(S)

figure
subplot(2,1,1)
p1 = plot(S.percentCycle,S.TAUsDESIRED(:,1),'r','LineWidth',2);
hold on
p2 = plot(S.percentCycle,S.TAUs(:,1),'b','LineWidth',2);
xlabel('Gait Cycle [%]'); ylabel({'Hip Moment [Nm]';'extension    flexion'});
p3 = plot(S.percentCycle(1),S.TAUsDESIRED(1,1),'.k'); % HCR
text(S.percentCycle(1)+0.5,S.TAUsDESIRED(1,1)+4,'HCR');
p4 = plot(S.percentCycle(63),S.TAUsDESIRED(63,1),'.k'); % TOR
text(S.percentCycle(63),S.TAUsDESIRED(63,1)+3,'TOR');
p5 = plot(S.percentCycle(end),S.TAUsDESIRED(end,1),'.k'); % HCR
text(S.percentCycle(end)-5,S.TAUsDESIRED(end,1)+4,'HCR');
legend([p1 p2],'Desired','ExoNET');
box off

subplot(2,1,2)
p1 = plot(S.percentCycle,S.TAUsDESIRED(:,2),'r','LineWidth',2);
hold on
p2 = plot(S.percentCycle,S.TAUs(:,2),'b','LineWidth',2);
xlabel('Gait Cycle [%]'); ylabel({'Knee Moment [Nm]';'flexion    extension'});
p3 = plot(S.percentCycle(1),S.TAUsDESIRED(1,2),'.k'); % HCR
text(S.percentCycle(1)+0.5,S.TAUsDESIRED(1,2)-1,'HCR');
p4 = plot(S.percentCycle(63),S.TAUsDESIRED(63,2),'.k'); % TOR
text(S.percentCycle(63),S.TAUsDESIRED(63,2)+1,'TOR');
p5 = plot(S.percentCycle(end),S.TAUsDESIRED(end,2),'.k'); % HCR
text(S.percentCycle(end)-5,S.TAUsDESIRED(end,2)+1,'HCR');
legend([p1 p2],'Desired','ExoNET');
box off

end