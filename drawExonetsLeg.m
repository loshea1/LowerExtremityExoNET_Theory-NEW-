% ***********************************************************************
% Draw individual MARIONETs for the leg pose specified by phis
% ***********************************************************************

function S = drawExonetsLeg(p,S)

%% Setup
fprintf('\n\n\n\n Drawing MARIONETs~~\n')

%% Locations for the cartoon
ColorsS = [0.5 0.7 1; 0.1 1 0.2; 1 0.6 0.3]; % 3 distinct RGB color spaces for the springs
ColorsR = [0 0.2 0.9; 0 0.7 0; 0.9 0.4 0]; % 3 distinct RGB color spaces for the rotators
Colors = [1 0.87843 0.40]; % yellow springs
ColorsC = [0.0235294 0.8392157 0.627451]; % green 1-joint springs
ColorsT = [1 0.572549 0.545098]; % pink 2-joint springs
LWs = 2; % lines width springs
LWr = 4; % lines width rotators

%=======================should this be hard set?==========================%
% hip =   [0      0];
% knee =  [0     -0.4451];
% ankle = [0.02  -1.03];
% toe =   [0.30367  -1.129];
%=========================================================================%

%% Loop through all MARIONETs
if S.case == 1.1
    ankleIndex = 1;
kneeFootIndex = S.EXONET.nParameters*S.EXONET.nElements+1;
    for element = 1:S.EXONET.nElements
        for j = 1:length(S.flag)
            if S.flag(j) == 0
                strElement = ' Ankle element %d..';
                bodyPart = [0.02  -1.03]; %ankle
                toe =   [0.30367  -1.129];
                plotColor = ColorsC;
                plotNum = 1;
                S = findParameters(ankleIndex,p, element,S);
            elseif S.flag(j) == 1
                strElement = ' Knee element %d..';
                bodyPart = [0     -0.4451]; %knee
                toe =   [0.30367  -1.129];
                plotColor = ColorsT;
                plotNum = 3;
                S = findParameters(kneeFootIndex,p,element,S);
                %         elseif S.flag(j) == 2 %Hip
                %
            end
            fprintf(strElement, element);
            
            rPos = bodyPart + [S.Parameters(1)*sind(S.Parameters(2)) -S.Parameters(1)*cosd(S.Parameters(2))]; % R vector
            plot([rPos(1) toe(1)], [rPos(2) toe(2)], 'Color', plotColor, 'Linewidth', LWs); %bungee
            plot([bodyPart(1) rPos(1)], [bodyPart(2) rPos(2)], 'Color', ColorsS(plotNum,:), 'Linewidth', LWr); %rod
        end
    end
elseif S.case == 1.2
    hip = [0, 0]; % HIP position
    knee = [S.BODY.Lengths(1)*sind(S.PHIs(1)), ... % KNEE position
        -(S.BODY.Lengths(1)*cosd(S.PHIs(1)))];
    ankle = [knee(1) + S.BODY.Lengths(2)*sind(S.PHIs(1)-S.PHIs(2)); ... % ANKLE position
        knee(2) - S.BODY.Lengths(2)*cosd(S.PHIs(1)-S.PHIs(2))];
    toe = [ankle(1) + S.BODY.Lengths(3)*sind(S.PHIs(3)), ... % TOE position
        ankle(2) - S.BODY.Lengths(3)*cosd(S.PHIs(3))];
    
    hipIndex = 1;
    kneeIndex = S.EXONET.nParameters*S.EXONET.nElements+1;
    hipKneeIndex = S.EXONET.nParameters*S.EXONET.nElements*2+1;
    
    
    %% Loop thorough all MARIONETs
    for element = 1:S.EXONET.nElements
        fprintf(' Hip element %d..',element);
        r = p(hipIndex+(element-1)*S.EXONET.nParameters+0);
        theta = p(hipIndex+(element-1)*S.EXONET.nParameters+1);
        L0 = p(hipIndex+(element-1)*S.EXONET.nParameters+2);
        rPos = [r*sind(theta) -r*cosd(theta)];     % R vector
        knee = [S.BODY.Lengths(1)*sind(S.PHIs(1)), ... % KNEE position
            -(S.BODY.Lengths(1)*cosd(S.PHIs(1)))];
        plot([rPos(1) knee(1)],[rPos(2) knee(2)],'Color',ColorsS(1,:),'Linewidth',LWs);
        plot([hip(1) rPos(1)],[hip(2) rPos(2)],'Color',ColorsR(1,:),'Linewidth',LWr);
    end
    
    for element = 1:S.EXONET.nElements
        fprintf(' Knee element %d..',element);
        r = p(kneeIndex+(element-1)*S.EXONET.nParameters+0);
        theta = p(kneeIndex+(element-1)*S.EXONET.nParameters+1);
        L0 = p(kneeIndex+(element-1)*S.EXONET.nParameters+2);
        knee = [S.BODY.Lengths(1)*sind(S.PHIs(1)), ...    % KNEE position
            -(S.BODY.Lengths(1)*cosd(S.PHIs(1)))];
        rPos = knee + [r*sind(theta) -r*cosd(theta)]; % R vector
        ankle = [knee(1) + S.BODY.Lengths(2)*sind(S.PHIs(1)-S.PHIs(2)), ... % ANKLE position
            knee(2) - S.BODY.Lengths(2)*cosd(S.PHIs(1)-S.PHIs(2))];
        plot([rPos(1) ankle(1)],[rPos(2) ankle(2)],'Color',ColorsS(2,:),'Linewidth',LWs);
        plot([knee(1) rPos(1)],[knee(2) rPos(2)],'Color',ColorsR(2,:),'Linewidth',LWr);
    end
    
    if S.EXONET.nJoints == 3
        for element = 1:S.EXONET.nElements
            fprintf(' 2-joints element %d..',element);
            r = p(hipKneeIndex+(element-1)*S.EXONET.nParameters+0);
            theta = p(hipKneeIndex+(element-1)*S.EXONET.nParameters+1);
            L0 = p(hipKneeIndex+(element-1)*S.EXONET.nParameters+2);
            rPos = [r*sind(theta) -r*cosd(theta)];                        % R vector
            ankle = [knee(1) + S.BODY.Lengths(2)*sind(S.PHIs(1)-S.PHIs(2)); ... % ANKLE position
                knee(2) - S.BODY.Lengths(2)*cosd(S.PHIs(1)-S.PHIs(2))];
            plot([rPos(1) ankle(1)],[rPos(2) ankle(2)],'Color',ColorsS(3,:),'Linewidth',LWs);
            plot([hip(1) rPos(1)],[hip(2) rPos(2)],'Color',ColorsR(3,:),'Linewidth',LWr);
        end
    end
elseif S.case == 2
    ColorsS = [0 0.2 0.9; 0 0.7 0; 0.9 0.4 0]; % 3 distinct RGB color spaces for the springs
ColorsR = [0.5 0.7 1; 0.1 1 0.2; 1 0.6 0.3]; % 3 distinct RGB color spaces for the rotators
LWs = 2; % lines width springs
LWr = 4; % lines width rotators

hip =   [0      0];
knee =  [0     -0.4451];
ankle = [0.02  -1.03];
toe =   [0.30367  -1.129];

hipIndex = 1;
kneeIndex = S.EXONET.nParameters*S.EXONET.nElements+1;
hipKneeIndex = S.EXONET.nParameters*S.EXONET.nElements*2+1;


%% Loop through all MARIONETs
for element = 1:S.EXONET.nElements
    fprintf(' Hip element %d..',element);
    r = p(hipIndex+(element-1)*S.EXONET.nParameters+0);
    theta = p(hipIndex+(element-1)*S.EXONET.nParameters+1);
    L0 = p(hipIndex+(element-1)*S.EXONET.nParameters+2);
    rPos = [r*sind(theta) -r*cosd(theta)]; % R vector
    plot([rPos(1) knee(1)],[rPos(2) knee(2)],'Color',ColorsS(3,:),'Linewidth',LWs);
    plot([hip(1) rPos(1)],[hip(2) rPos(2)],'Color',ColorsR(3,:),'Linewidth',LWr);
end

for element = 1:S.EXONET.nElements
    fprintf(' Knee element %d..',element);
    r = p(kneeIndex+(element-1)*S.EXONET.nParameters+0);
    theta = p(kneeIndex+(element-1)*S.EXONET.nParameters+1);
    L0 = p(kneeIndex+(element-1)*S.EXONET.nParameters+2);
    rPos = knee + [r*sind(theta) -r*cosd(theta)]; % R vector
    plot([rPos(1) ankle(1)],[rPos(2) ankle(2)],'Color',ColorsS(1,:),'Linewidth',LWs);
    plot([knee(1) rPos(1)],[knee(2) rPos(2)],'Color',ColorsR(1,:),'Linewidth',LWr);
end

if S.EXONET.nJoints == 3
    for element = 1:S.EXONET.nElements
        fprintf(' Hip-Knee element %d..',element);
        r = p(hipKneeIndex+(element-1)*S.EXONET.nParameters+0);
        theta = p(hipKneeIndex+(element-1)*S.EXONET.nParameters+1);
        L0 = p(hipKneeIndex+(element-1)*S.EXONET.nParameters+2);
        rPos = [r*sind(theta) -r*cosd(theta)]; % R vector
        plot([rPos(1) ankle(1)],[rPos(2) ankle(2)],'Color',ColorsS(2,:),'Linewidth',LWs);
        plot([hip(1) rPos(1)],[hip(2) rPos(2)],'Color',ColorsR(2,:),'Linewidth',LWr);
    end
end
end
fprintf('\n\n\n\n Done drawing~~\n')
end