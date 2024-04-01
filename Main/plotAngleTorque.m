% ***********************************************************************
% Plot the ExoNET torques superimposed on the desired torques
% ***********************************************************************

function plotAngleTorque(S,exOn)
%ColorsS = [0.5 0.7 1; 0.1 1 0.2; 1 0.6 0.3]; % 3 distinct RGB color spaces for the springs
%Colors = [1 0.87843 0.40]; % yellow springs
ColorsC = [0.0235294 0.8392157 0.627451]; % green 1-joint springs
ColorsT = [1 0.572549 0.545098]; % pink 2-joint springs

subplot(1,2,2)
plot(S.PHIs(:,3),S.TAUsDESIRED(:,1),'^','MarkerSize',5,'MarkerFaceColor','r','MarkerEdgeColor','r');
hold on
plot(S.PHIs(:,3),S.TAUsDESIRED(:,1),'r','LineWidth',2); %Desired
plot(S.PHIs(:,3),S.TAUs(:,1),'^','MarkerSize',5,'MarkerFaceColor','b','MarkerEdgeColor','b');
plot(S.PHIs(:,3),S.TAUs(:,1),'b','LineWidth',2); %ExoNET
xlabel({'Ankle Angle [deg]';'plantarflexion    dorsiflexion'}); ylabel({'Ankle Torque [Nm]';'plantarflexion    dorsiflexion'});
plot(S.PHIs(end,3),S.TAUsDESIRED(end,1),'.k'); % TOR
text(S.PHIs(end,3)+0.2,S.TAUsDESIRED(end,1)+0.6,'TOR');
xlim([min(S.PHIs(:,3)) max(S.PHIs(:,3))])

if exist('exOn','var')
    for element = 1:S.EXONET.nElements
        
        if S.EXONET.nJoints == 11
            plotColor = ColorsC;
        elseif S.EXONET.nJoints == 22
            plotColor = ColorsT; %2-joint element
        elseif S.EXONET.nJoints == 2
            plotColor = [ColorsC; ColorsT];
        end
        
        for j = 1:height(plotColor)
            plot(S.PHIs(:,3),S.EXONET.tau(:,1,element),'--','Color',plotColor(j,:),'LineWidth',1);
            plot(S.PHIs(:,3),S.TAUs(:,1),'b','LineWidth',2);
        end
    end
    
    box off
    title('Gait Torques Field for Late Stance')
    
end

% ColorsS = [0.5 0.7 1; 0.1 1 0.2; 1 0.6 0.3]; %#ok<NASGU> % 3 distinct RGB color spaces for the springs
% Colors = [1 0.87843 0.40]; % yellow springs
% ColorsC = [0.0235294 0.8392157 0.627451]; % green 1-joint springs
% ColorsT = [1 0.572549 0.545098]; % pink 2-joint springs
% 
% subplot(1,2,2)
% hold on
% p1 = plot(PHIs(:,3),TAUsDESIRED(:,1),'r.-','LineWidth',2); 
% p2 = plot(PHIs(:,3),TAUs(:,1),'b.-','LineWidth',2);
% 
% %if percentageGaitCycle>48
%   p1 = plot(PHIs(:,3),TAUsDESIRED(:,1),'^','MarkerSize',5,'MarkerFaceColor','r','MarkerEdgeColor','r');%TAUsDESIRED is negative for anti-assistance
%   p2 = plot(PHIs(:,3),TAUs(:,1),'^','MarkerSize',5,'MarkerFaceColor','b','MarkerEdgeColor','b');
% %end
% 
% xlabel({'Ankle Angle [deg]';'plantarflexion    dorsiflexion'}); ylabel({'Ankle Torque [Nm]';'plantarflexion    dorsiflexion'});
% p4 = plot(PHIs(end,3),-TAUsDESIRED(end,1),'.k'); % TOR
% text(PHIs(end,3)+0.2,-TAUsDESIRED(end,1)+0.6,'TOR');
% xlim([min(PHIs(:,3)) max(PHIs(:,3))])
% 
% if exist('exOn','var')
% for element = 1:EXONET.nElements
% 
% if EXONET.nJoints == 11
% p4 = plot(PHIs(:,3),EXONET.tau(:,1,element),'--','Color',ColorsC,'LineWidth',1);
% p6 = plot(PHIs(:,3),TAUs(:,1),'b','LineWidth',2);
% %legend([p1 p2 p4],'Desired','ExoNET','1-joint element','Location','Southeast');
% end
% 
% if EXONET.nJoints == 22
% p5 = plot(PHIs(:,3),EXONET.tau(:,1,element),'--','Color',ColorsT,'LineWidth',1);
% p6 = plot(PHIs(:,3),TAUs(:,1),'b','LineWidth',2);
% %legend([p1 p2 p5],'Desired','ExoNET','2-joint element','Location','Southeast');
% end
% 
% if EXONET.nJoints == 2
% p4 = plot(PHIs(:,3),EXONET.tau(:,1,element),'--','Color',ColorsC,'LineWidth',1);
% p5 = plot(PHIs(:,3),EXONET.tau(:,2,element),'--','Color',ColorsT,'LineWidth',1);
% p6 = plot(PHIs(:,3),TAUs(:,1),'b','LineWidth',2);
% %legend([p1 p2 p4 p5],'Desired','ExoNET','1-joint element','2-joint element','Location','Southeast');
% end
% end
% 
% box off
% title('Gait Torques Field for Late Stance')
% 
% end

end