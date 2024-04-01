% ***********************************************************************
% Create the different positions of the Body associated to
% the given angles combinations for hip and knee
% ***********************************************************************

function S = forwardKinLeg(S)

Position.hip = zeros(size(S.PHIs(:,1:2))); % HIP position

Position.knee = [S.BODY.Lengths(1)*sind(S.PHIs(:,1)), ... % KNEE position
                 -(S.BODY.Lengths(1)*cosd(S.PHIs(:,1)))];

Position.ankle = [Position.knee(:,1) + S.BODY.Lengths(2)*sind(S.PHIs(:,1)-S.PHIs(:,2)), ... % ANKLE position
                  Position.knee(:,2) - S.BODY.Lengths(2)*cosd(S.PHIs(:,1)-S.PHIs(:,2))];

Position.foot = [Position.ankle(:,1) + S.BODY.Lengths(3)*sind(S.PHIs(:,3)), ... % FOOT position
                 Position.ankle(:,2) - S.BODY.Lengths(3)*cosd(S.PHIs(:,3))];
S.Position = Position;
end