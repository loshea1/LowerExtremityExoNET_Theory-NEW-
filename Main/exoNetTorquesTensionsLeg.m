% ***********************************************************************
% Calculate the torques and the tensions created by the ExoNET
% ***********************************************************************

function S = exoNetTorquesTensionsLeg(p,S,plotIt)

%% Setup
if ~exist('plotIt','var'); plotIt = 0; end   % if plotIt argument not passed
ColorsS = [0.5 0.7 1; 0.1 1 0.2; 1 0.6 0.3]; % 3 distinct RGB color spaces for the springs
Colors = [1 0.87843 0.40]; % yellow springs
ColorsC = [0.0235294 0.8392157 0.627451]; % green 1-joint springs
ColorsT = [1 0.572549 0.545098]; % pink 2-joint springs

TAUs = zeros(size(S.PHIs,1),2); % initialization

ankleIndex = 1;
kneeToeIndex = S.EXONET.nParameters*S.EXONET.nElements+1;

if plotIt; cf = gcf(); figure; end           % add cf and create another figure


%% Find torques
for i = 1:size(S.PHIs,1)

if S.EXONET.nJoints == 11
    tau = 0;
    for element = 1:S.EXONET.nElements
        S = findParameters(ankleIndex, p, element, S);
        S = tauMarionetLeg(S, i, 0);
        S.EXONET.tau(i,1,element) = S.tau;
        S.EXONET.T(i,1,element) = S.T;
        S.EXONET.Tdist(i,1,element) = S.Tdist;
        
        if plotIt
            plot(ColorsC, S.Tension1j, i, S, 1); 
        end
        tau = tau + S.tau; % + element's torque
    end
    TAUs(i,1) = tau; % torque created by the ankle MARIONET
end


if S.EXONET.nJoints == 22
    taus = [0 0];
    
        for element = 1:S.EXONET.nElements
        S = findParameters(ankleIndex, p, element, S);
        S = tauMarionetLeg(S, i, 1);
        S.EXONET.tau(i,1,element) = S.tau;
        S.EXONET.T(i,1,element) = S.T;
        S.EXONET.Tdist(i,1,element) = S.Tdist;
        
        if plotIt
            plot(ColorsT, S.Tension2j, i, S, 1);
        end
        taus = taus + S.tau; % + element's torque
        end
    TAUs(i,1) = TAUs(i,1) + taus(2); % torque created by the knee-toe MARIONET on the ankle
    TAUs(i,2) = taus(1); % torque created by the knee-toe MARIONET on the knee
end

if S.EXONET.nJoints == 2
    tau = 0;
    for element = 1:S.EXONET.nElements
        S = findParameters(ankleIndex,p, element, S);
        S = tauMarionetLeg(S, i, 0);
        S.EXONET.tau(i,1,element) = S.tau;
        S.EXONET.T(i,1,element) = S.T;
        S.EXONET.Tdist(i,1,element) = S.Tdist;
        
        if plotIt
            plot(ColorsC, S.Tension1j, i, S, 1);
        end
        tau = tau + S.tau;
    end
    TAUs(i,1) = tau; % torque created by the ankle MARIONET
    
    taus = [0 0];
    for element = 1:S.EXONET.nElements
        S = findParameters(kneeToeIndex,p, element, S);
        S = tauMarionetLeg(S, i, 1);
        S.EXONET.tau(i,2,element) = S.tau(element);
        S.EXONET.T(i,2,element) = S.T;
        S.EXONET.Tdist(i,2,element) = S.Tdist;
        
        if plotIt
            plot(ColorsT, S.Tension2j, i, S, 2);
        end
        
        taus = taus + S.tau;
    end
    TAUs(i,1) = TAUs(i,1) + taus(2); % torque created by the knee-toe MARIONET on the ankle
    TAUs(i,2) = taus(1); % torque created by the knee-toe MARIONET on the knee
end 

if plotIt; figure(cf); end

end

end

function plot(Colors, y, i, S, n) %n is the second position in the tau, T, and Tdist 

if S.Spring == 1 %Compression
    stretch_min = min(S.EXONET.Tdist(i,n,element));
    x = stretch_min:0.001:S.EXONET.pConstraint(3,2)+0.1;
elseif S.Spring == 0 %Tension
    stretch_max = max(S.EXONET.Tdist(i,n,element));
    x = 0:0.001:stretch_max;
end

plot(x,y,'Color',Colors,'LineWidth',2.5)
hold on
yline(0)
plot(S.EXONET.Tdist(i,n,element),S.EXONET.T(i,n,element),'o','MarkerSize',...
    7,'MarkerFaceColor',Colors,'MarkerEdgeColor','w')
xlabel('L [m]')
ylabel('Tension [N]')
title('Tension exerted by each elastic element with respect to its length')
box off

end