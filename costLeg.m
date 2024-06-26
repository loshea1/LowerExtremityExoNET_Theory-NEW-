% ***********************************************************************
% Evaluate the cost function for the torques TAUs at positions PHIs
% ***********************************************************************

function [c,meanErr] = costLeg(S)
%% Setup
torque = exoNetTorquesLeg(S.p, S);       % torques generated by the ExoNET
if S.case ~= 2
    e = S.TAUsDESIRED(:,1) - torque.TAUs(:,1);  % ankle torque errors at each operating point
    w = S.TAUsDESIRED(:,2) - torque.TAUs(:,2);  % knee torque errors at each operating point
else
    e = S.AllTAUsDESIRED(:,1) - torque.TAUs(:,1);  % ankle torque errors at each operating point
    w = S.AllTAUsDESIRED(:,2) - torque.TAUs(:,2);  % knee torque errors at each operating point
end

se = e.^2;                             % squared ankle torque errors at each operating point
sw = w.^2;                             % squared knee torque errors at each operating point
mse = mean(e.^2);                      % Mean Squared Ankle Error
msw = mean(w.^2);                      % Mean Squared Knee Error
rmse = sqrt(mean(e.^2));               % Root Mean Squared Ankle Error
rmsw = sqrt(mean(w.^2));               % Root Mean Squared Knee Error
meanErr = mean([rmse rmsw]);           % average error
meanErr = rmse;                        % Root Mean Squared Ankle Error

c = sum(e.^2);        % cost = sum of the squares of the errors at all positions
q = sum(w.^2);
%q = sum(w.^2).*0.1;   % to punish knee torque error less than hip torque error
c = c + q;

pConst = S.EXONET.pConstraint;
p = S.p;
%% Penalize R
for i = 1:3:length(p)  % loop thru each R parameter
    c = c + abs(p(i)); % penalize R to drive it to zero
    isLow = abs(p(i)) < pConst(i,1);       % if is lower than the min
    lowBy = (pConst(i,1)-abs(p(i)))*isLow; % how low
    isHi = abs(p(i)) > pConst(i,2);        % if is higher than the max
    hiBy = (abs(p(i))-pConst(i,2))*isHi;   % how high
    c = c + 1*lowBy; % increase cost if is lower than the min
    c = c + 100000*hiBy; % increase cost if is higher than the max
end


%% Penalize L0
for i = 3:3:length(p) % loop thru each L0 parameter
    isNeg = p(i) < 0; % if is negative
    hiNeg = 100000*isNeg;
    c = c + hiNeg;    % increase cost if is negative
    isLow = p(i) < pConst(i,1);       % if is lower than the min
    lowBy = (pConst(i,1)-p(i))*isLow; % how low
    isHi = p(i) > pConst(i,2);        % if is higher than the max
    hiBy = (p(i)-pConst(i,2))*isHi;   % how high
    c = c + 10*lowBy; % increase cost if L0 is lower than the min
    c = c + 10000*hiBy; % increase cost if L0 is higher than the max
end

end