% ***********************************************************************
% Calculate the torque created by a MARIONET
% ***********************************************************************

function S = tauMarionetLeg(S, i, flag)

r = S.Parameters(1);
theta = S.Parameters(2);
L0 = S.Parameters(3);

if flag == 0 %1-joint
    phi = S.PHIs(i,3);
    L = S.BODY.Lengths(3);
    
    rVect = [r*sind(theta) -r*cosd(theta)  0];                             % R vector
    lVect = [L*sind(phi)   -L*cosd(phi)    0];                             % anatomical segment vector (hip-knee or knee-ankle)
    Tdir = rVect - lVect;                                                  % MARIONET vector
    S.Tdist = norm(Tdir);                                           % magnitude of MARIONET vector
    Tdir = Tdir./S.Tdist;                                           % MARIONET unit vector
    
    S.T = S.TENSION1j(L0,S.Tdist);                           % magnitude of the Tension exerted by the MARIONET
    tauVect = cross(rVect,S.T.*Tdir);                               % cross product between the R vector and the Tension vector
    S.tau = tauVect(3);                                             % the 3rd dimension is the torque
elseif flag == 1 %2-joint
    phis = S.PHIs(i,:);
    Ls = S.BODY.Lengths;
    
    rVect = [r*sind(theta)  -r*cosd(theta)  0];                            % R vector
    knee = [Ls(1)*sind(phis(1))  -Ls(1)*cosd(phis(1))  0];                 % knee position
    ankle = [knee(1) + Ls(2)*sind(phis(1)-phis(2)), ...                    % ankle position
        knee(2) - Ls(2)*cosd(phis(1)-phis(2)), ...
        0];
    foot = [ankle(1) + Ls(3)*sind(phis(3)), ...                            % foot position
        ankle(2) - Ls(3)*cosd(phis(3)), ...
        0];
    knee2foot = foot - knee;                                               % knee-foot vector
    knee2ankle = ankle - knee;                                             % knee-ankle vector
    ankle2foot = foot - ankle;                                             % ankle-foot vector
    Tdir = rVect - knee2foot;                                              % MARIONET vector
    S.Tdist = norm(Tdir);                                           % magnitude of MARIONET vector
    Tdir = Tdir./S.Tdist;                                           % MARIONET unit vector
    if S.case ~= 3
    S.T = S.TENSION2j(L0,S.Tdist);                           % magnitude of the Tension exerted by the MARIONET
    else
        S.T = S.TENSION(L0, S.Tdist);
    end
    tau1 = cross(knee2foot,S.T.*Tdir);                              % cross product for knee torque
    tau2 = cross(ankle2foot,S.T.*Tdir);                             % cross product for ankle torque
    S.tau = [tau1(3) tau2(3)];                                      % the 3rd dimension is the torque
end
end