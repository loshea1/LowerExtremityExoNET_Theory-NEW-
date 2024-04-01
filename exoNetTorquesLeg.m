% ***********************************************************************
% Calculate the torques created by the ExoNET
% ***********************************************************************

function S = exoNetTorquesLeg(p,S)

%% Setup
if S.case ~= 2
    PHIs = S.PHIs;
else
    if S.GridPHIsVal ~= 1
        PHIs = S.AllPHIs;
    else
        PHIs = S.GridPHIs;
    end
end
TAUs = zeros(size(PHIs,1),2); % initialization

ankleIndex = 1;
kneeToeIndex = S.EXONET.nParameters*S.EXONET.nElements+1;


%% Find torques
for i = 1:size(PHIs,1)

if S.EXONET.nJoints == 11
    tau = 0;
    for element = 1:S.EXONET.nElements
        S = findParameters(ankleIndex,p,element, S);
        S = tauMarionetLeg(S, i, 0);
        tau = tau + S.tau;
    end
    TAUs(i,1) = tau; % torque created by the ankle MARIONET
end


if S.EXONET.nJoints == 22
    taus = [0 0];
    for element = 1:S.EXONET.nElements
        %S = findParameters(kneeToeIndex,p, element,S);
        S = findParameters(ankleIndex, p, element, S);
        S = tauMarionetLeg(S, i, 1);
        taus = taus + S.tau;
    end
    TAUs(i,1) = TAUs(i,1) + taus(2); % torque created by the knee-toe MARIONET on the ankle
    TAUs(i,2) = taus(1); % torque created by the knee-toe MARIONET on the knee
end


if S.EXONET.nJoints == 2
    tau = 0;
    for element = 1:S.EXONET.nElements
        S = findParameters(ankleIndex,p, element,S);
        S = tauMarionetLeg(S, i, 0);
        tau = tau + S.tau;
    end
    TAUs(i,1) = tau; % torque created by the ankle MARIONET
    
    taus = [0 0];
    for element = 1:S.EXONET.nElements
        S = findParameters(kneeToeIndex,p, element,S);
        S = tauMarionetLeg(S, i, 1);
        taus = taus + S.tau;
    end
    TAUs(i,1) = TAUs(i,1) + taus(2); % torque created by the knee-toe MARIONET on the ankle
    TAUs(i,2) = taus(1); % torque created by the knee-toe MARIONET on the knee
end


end


if S.GridPHIsVal ~= 1
    S.TAUs = TAUs;
else
    S.GridTAUs = TAUs;
end

end
