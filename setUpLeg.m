% ***********************************************************************
% SETUP:
% Set the parameters for the Body and for the ExoNET
% ***********************************************************************
%% BEGIN
% Define Variables
[S] = setLegParameters();

%% EXONET
i = 0;
if S.EXONET.nJoints == 11 || S.EXONET.nJoints == 22 %knee-ankle or ankle-toe
    const = 1;
    S.case = 1.1;
elseif S.EXONET.nJoints == 2
    const = 2;
    S.case = 1.1;
elseif S.EXONET.nJoints == 3
    const = S.EXONET.nJoints;
    S.case = 1.2;
end

S.EXONET.pConstraint = NaN*zeros(const*S.EXONET.nElements*S.EXONET.nParameters,2); % initialization
for joint = 1:const
    for element = 1:S.EXONET.nElements
            i = i+1;
            S.EXONET.pConstraint(i,:) = S.RLoHi;
            i = i+1;
            S.EXONET.pConstraint(i,:) = S.thetaLoHi;
            i = i+1;
           S.EXONET.pConstraint(i,:) = S.L0LoHi;
    end
end

if const == 2  
    I = S.EXONET.nParameters*S.EXONET.nElements+3;
    for j = I:3:length(S.EXONET.pConstraint)
        S.EXONET.pConstraint(j,:) = S.LL0LoHi;
    end
end
%% IMPORT DATA OF THE WALK CYCLE
beatrice_gait_hip_knee_ankle = xlsread('beatrice_gait_hip_knee_ankle.xlsx'); % walk cycle parameters for the right leg
                                                  % (from Bovi et al.)
S.percentCycle = beatrice_gait_hip_knee_ankle(:,1); % percentage of gait cycle
S.Hip.Angle = beatrice_gait_hip_knee_ankle(:,2);    % hip angles in [deg]
S.Knee.Angle = beatrice_gait_hip_knee_ankle(:,3);   % knee angles in [deg]
S.Ankle.Angle = beatrice_gait_hip_knee_ankle(:,4);  % ankle angles in [deg]
S.Hip.Moment = beatrice_gait_hip_knee_ankle(:,5);   % hip moments of force in [Nm/kg]
S.Knee.Moment = beatrice_gait_hip_knee_ankle(:,6);  % knee moments of force in [Nm/kg]
S.Ankle.Moment = beatrice_gait_hip_knee_ankle(:,7); % ankle moments of force in [Nm/kg]

phis = [S.Hip.Angle, S.Hip.Angle+S.Knee.Angle, 90-(S.Knee.Angle+S.Ankle.Angle)]; % angles in [deg]
tausD = S.Ankle.Moment.*(-1).*S.BODY.Mass; % ankle moments of force in [Nm]
tausKnee = S.Knee.Moment.*S.BODY.Mass; % knee moments of force in [Nm]

% ENTIRE GAIT CYCLE
%S.PHIs = [S.Hip.Angle, S.Hip.Angle+S.Knee.Angle, 90-(S.Knee.Angle+S.Ankle.Angle)]; % angles in [deg]
%S.TAUsDESIRED = S.Ankle.Moment.*(-1).*S.BODY.Mass; % moments of force in [Nm]

% STANCE PHASE
%S.PHIs = [S.Hip.Angle(1:63), S.Hip.Angle(1:63)+S.Knee.Angle(1:63), 90-(S.Knee.Angle(1:63)+S.Ankle.Angle(1:63))]; % angles in [deg]
%S.TAUsDESIRED = S.Ankle.Moment(1:63).*(-1).*S.BODY.Mass; % moments of force in [Nm]

% LATE STANCE PHASE
S.PHIs = [S.Hip.Angle(9:63), S.Hip.Angle(9:63)+S.Knee.Angle(9:63), 90-(S.Knee.Angle(9:63)+S.Ankle.Angle(9:63))]; % angles in [deg]
S.TAUsDESIRED = [S.Ankle.Moment(9:63).*(-1).*S.BODY.Mass, S.Knee.Moment(9:63).*S.BODY.Mass]; % moments of force in [Nm]
%
% Hip Flexion (+) Hip Extension (-)
% Knee Extension (+) Knee Flexion (-)
% Ankle Dorsiflexion (+) Ankle Plantarflexion (-)

% 4 PERIODS OF STANCE PHASE
% Initial contact (0%–2% of the Gait Cycle)
% Loading response (2%–12% of the Gait Cycle)
% Midstance (12%–31% of the Gait Cycle)
% Preswing (50%–60% of the Gait Cycle)

%   o HIP
%   .\
%   . \
%   .  \
%   .   \
%   .    \
%   .phi1 \
%          \
%           o KNEE
%          / .
%         /   .
%        /     .
%       /  phi2 .
%      /
%     /
%    / ANKLE
%   o---------o TOE
%   .
%   . phi3
%   .
%   .


%% CREATE THE DIFFERENT POSITIONS OF THE BODY
S = forwardKinLeg(S); % positions associated to the angles


%% HANDLE = @(ARGLIST) EXPRESSION   constructs an anonymous function and returns the handle to it
if S.case == 1.1 %ankle
    if S.Spring == 1 %compression
        S.TENSION1j = @(L0,L)   (S.EXONET.K1j.*(L-L0)).*((L-L0)<0).*((L*L0)>0); % 1-joint Linear Compression Springs
        S.TENSION2j = @(L0,L)   (S.EXONET.K2j.*(L-L0)).*((L-L0)<0).*((L*L0)>0); % 2-joint Linear Compression Springs
    elseif S.Spring == 2 %tension
        S.TENSION1j = @(L0,L)   (S.EXONET.K1j.*(L-L0)).*((L-L0)>0).*((L*L0)>0); % 1-joint Linear Tension Springs
        S.TENSION2j = @(L0,L)   (S.EXONET.K2j.*(L-L0)).*((L-L0)>0).*((L*L0)>0); % 2-joint Linear Tension Springs
    end
elseif S.case == 1.2 %hip
    S.TENSION = @(L0,L) (EXONET.K.*(L-L0)).*((L-L0)>0).*((L*L0)>0); % (inlineFcn) + stretch
end
%% Optimization Parameters
optOptions = optimset();
optOptions.MaxIter = 1E3;     % optimization limit
optOptions.MaxFunEvals = 1E3; % optimization limit
S.optOptions = optimset(optOptions);
       
fprintf('\n\n\n\n Parameters set~~\n')

