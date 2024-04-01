% ***********************************************************************
% Calculate the torques created by the ExoNET
% ***********************************************************************

function TAUs = exoNetTorquesLegOpto(p,S)
PHIs = S.PHIs;
EXONET = S.EXONET;
BODY = S.BODY;
%% Setup

TAUs = zeros(size(PHIs,1),2); % initialization

ankleIndex = 1;
kneeToeIndex = EXONET.nParameters*EXONET.nElements+1;


%% Find torques
for i = 1:size(PHIs,1)

if EXONET.nJoints == 11
    tau = 0;
    for element = 1:EXONET.nElements
        r = p(ankleIndex+(element-1)*EXONET.nParameters+0);
        theta = p(ankleIndex+(element-1)*EXONET.nParameters+1);
        L0 = p(ankleIndex+(element-1)*EXONET.nParameters+2);
        tau = tau + tauMarionetLeg(PHIs(i,3),BODY.Lengths(3),r,theta,L0);
    end
    TAUs(i,1) = tau; % torque created by the ankle MARIONET
end


if EXONET.nJoints == 22
    taus = [0 0];
    for element = 1:EXONET.nElements
        r = p(ankleIndex+(element-1)*EXONET.nParameters+0);
        theta = p(ankleIndex+(element-1)*EXONET.nParameters+1);
        L0 = p(ankleIndex+(element-1)*EXONET.nParameters+2);
        taus = taus + tau2jMarionetLeg(PHIs(i,:),BODY.Lengths,r,theta,L0);
    end
    TAUs(i,1) = TAUs(i,1) + taus(2); % torque created by the knee-toe MARIONET on the ankle
    TAUs(i,2) = taus(1); % torque created by the knee-toe MARIONET on the knee
end


if EXONET.nJoints == 2
    tau = 0;
    for element = 1:EXONET.nElements
        r = p(ankleIndex+(element-1)*EXONET.nParameters+0);
        theta = p(ankleIndex+(element-1)*EXONET.nParameters+1);
        L0 = p(ankleIndex+(element-1)*EXONET.nParameters+2);
        tau = tau + tauMarionetLeg(PHIs(i,3),BODY.Lengths(3),r,theta,L0);
    end
    TAUs(i,1) = tau; % torque created by the ankle MARIONET
    
    taus = [0 0];
    for element = 1:EXONET.nElements
        r = p(kneeToeIndex+(element-1)*EXONET.nParameters+0);
        theta = p(kneeToeIndex+(element-1)*EXONET.nParameters+1);
        L0 = p(kneeToeIndex+(element-1)*EXONET.nParameters+2);
        taus = taus + tau2jMarionetLeg(PHIs(i,:),BODY.Lengths,r,theta,L0);
    end
    TAUs(i,1) = TAUs(i,1) + taus(2); % torque created by the knee-toe MARIONET on the ankle
    TAUs(i,2) = taus(1); % torque created by the knee-toe MARIONET on the knee
end

end

end