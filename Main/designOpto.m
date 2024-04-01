%% CREATE GRID ACROSS THE PARAMETERS SPACE
function S = designOpto(S)
fg = figure();
fg.WindowState = 'maximized'; % create maximized empty figure


RLoHi = [0.00 0.30];     % R low and high range in [m]
thetaLoHi = [-360 360];  % theta low and high range in [deg]
L0LoHi = [0.40 0.70];    % L0 low and high range in [m] for 1-joint Compression Springs
np = 2;  % number of points across each parameter


% EXONET SOLUTION
p = [0.0423247630553336,282.70,0.628591162699065];


% GENERATE PARAMETER VALUES USING A STAR FROM THE BEST EXONET SOLUTION
if p(1) < (RLoHi(2)-RLoHi(1))/2
    spanR = (p(1)-RLoHi(1))/np;
else
    spanR = (RLoHi(2)-p(1))/np;
end

if p(2) < 0
    spanTheta = (p(2)-thetaLoHi(1))/np;
else
    spanTheta = (thetaLoHi(2)-p(2))/np;
end

if p(3) < (L0LoHi(2)-L0LoHi(1))/2
    spanL0 = (p(3)-L0LoHi(1))/np;
else
    spanL0 = (L0LoHi(2)-p(3))/np;
end

f = 1;
for v = -np:-1
    R(f) = p(1) + v*spanR;
    theta(f) = p(2) + v*spanTheta;
    L0(f) = p(3) + v*spanL0;
    f = f + 1;
end
f = length(R)+1;
for v = 1:np
    R(f) = p(1) + v*spanR;
    theta(f) = p(2) + v*spanTheta;
    L0(f) = p(3) + v*spanL0;
    f = f + 1;
end

% Elongate star arms
dim = 6;
f = length(R)+1;
for v = np:dim
    R(f) = p(1) + v*spanR;
    f = f + 1;
end
f = length(theta)+1;
for v = -dim:-np
    theta(f) = p(2) + v*spanTheta;
    L0(f) = p(3) + v*spanL0;
    f = f + 1;
end

R = sort(R);
theta = sort(theta);
L0 = sort(L0);



% BUILD 3D GRID POINTS
Xgrid = R;      % x-axis of the grid
Ygrid = theta;  % y-axis of the grid
Zgrid = L0;     % z-axis of the grid

% x-axis
for i = 1:length(Xgrid)
    Grid(i,:) = [Xgrid(i) p(2) p(3)];
end
% y-axis
for i = 1:length(Ygrid)
    Grid(i+length(Xgrid),:) = [p(1) Ygrid(i) p(3)];
end
% z-axis
for i = 1:length(Zgrid)
    Grid(i+length(Xgrid)+length(Ygrid),:) = [p(1) p(2) Zgrid(i)];
end

% Line equation for diagonals
lineEq = @(x,q1,q2)   x*[cosd(q1) cosd(q2) sind(q2)];
q1 = 45;
q2 = 45;

% xz diagonal 1
lengthGrid = length(Grid);
for i = 1:length(Xgrid)
    x = Xgrid(i);
    par = p - lineEq(p(1),q1,q2);
    Grid(lengthGrid+i,:) = lineEq(x,q1,q2) + par;
end
Grid(lengthGrid+8,:) = Grid(lengthGrid+7,:);
Grid(lengthGrid+9,:) = Grid(lengthGrid+7,:);
% xz diagonal 2
lengthGrid = length(Grid);
j = length(Xgrid);
for i = 1:length(Xgrid)
    Grid(lengthGrid+i,:) = [Xgrid(i) p(2) Zgrid(j)];
    j = j - 1;
end
% yz diagonal 1
lengthGrid = length(Grid);
for i = 1:length(Xgrid)
    Grid(lengthGrid+i,:) = [p(1) Ygrid(i) Zgrid(i)];
end
% yz diagonal 2
lengthGrid = length(Grid);
j = length(Xgrid);
Grid(lengthGrid+1,:) = [p(1) Ygrid(5) Zgrid(9)];
Grid(lengthGrid+2,:) = [p(1) Ygrid(7) Zgrid(8)];
Grid(lengthGrid+3,:) = [p(1) Ygrid(8) Zgrid(7)];
Grid(lengthGrid+4,:) = [p(1) Ygrid(9) Zgrid(5)];
Grid(lengthGrid+5,:) = [p(1) Ygrid(9) Zgrid(5)];
Grid(lengthGrid+6,:) = [p(1) Ygrid(9) Zgrid(5)];
Grid(lengthGrid+7,:) = [p(1) Ygrid(9) Zgrid(5)];
Grid(lengthGrid+8,:) = [p(1) Ygrid(9) Zgrid(5)];
Grid(lengthGrid+9,:) = [p(1) Ygrid(9) Zgrid(5)];
% xy diagonal 1
lengthGrid = length(Grid);
Grid(lengthGrid+1,:) = [Xgrid(1) Ygrid(5) p(3)];
Grid(lengthGrid+2,:) = [Xgrid(2) Ygrid(7) p(3)];
Grid(lengthGrid+3,:) = [Xgrid(3) Ygrid(8) p(3)];
Grid(lengthGrid+4,:) = [Xgrid(5) Ygrid(9) p(3)];
Grid(lengthGrid+5,:) = [Xgrid(5) Ygrid(9) p(3)];
Grid(lengthGrid+6,:) = [Xgrid(5) Ygrid(9) p(3)];
Grid(lengthGrid+7,:) = [Xgrid(5) Ygrid(9) p(3)];
Grid(lengthGrid+8,:) = [Xgrid(5) Ygrid(9) p(3)];
Grid(lengthGrid+9,:) = [Xgrid(5) Ygrid(9) p(3)];
% xy diagonal 2
lengthGrid = length(Grid);
j = length(Xgrid);
for i = 1:length(Xgrid)
    Grid(lengthGrid+i,:) = [Xgrid(i) Ygrid(j) p(3)];
    j = j - 1;
end


colors = {'#d17006','#a267d0','#00a672',... % x,y,z-axis
          '#ff7c43','#ffa600',... % xz diagonals
          '#ebb0ff','#ff61d8',... % yz diagonals
          '#68d560','#3eff8d'};   % xy diagonals

subplot(2,5,[1 2 6 7])
u = 1;
for i = 1:length(Xgrid):length(Grid)
    plot3(Grid(i:i+length(Xgrid)-1,1),Grid(i:i+length(Xgrid)-1,2),Grid(i:i+length(Xgrid)-1,3),'-o','Color','k','MarkerSize',10,'MarkerFaceColor',colors{u})
    u = u + 1;
    drawnow;
    pause(1);
    hold on
end


% PLOT EXONET SOLUTION
for m = 1:3:length(p)
    plot3(p(m),p(m+1),p(m+2),'o','Color','k','MarkerSize',10,'MarkerFaceColor','b')
end



% BUILD AND PLOT REFERENCE GRID
npp = 3;
Rref = linspace(RLoHi(1),RLoHi(2),npp);
thetaref = linspace(thetaLoHi(1),thetaLoHi(2),npp);
L0ref = linspace(L0LoHi(1),L0LoHi(2),npp);

n = 0;
for k = 1:length(L0ref)
    for j = 1:length(thetaref)
        for i = 1:length(Rref)
            GridRef(i+n,:) = [Rref(i) thetaref(j) L0ref(k)];
        end
        n = n + length(Rref);
    end
end

subplot(2,5,[1 2 6 7])
w = 0;
for o = 1:npp:length(GridRef)
    plot3(GridRef(1+w:npp+w,1),GridRef(1+w:npp+w,2),GridRef(1+w:npp+w,3),'-','Color','b','MarkerSize',10,'MarkerFaceColor','#D9FFFF')
    hold on
    w = w + npp;
end
for q = 0:2
    xx = [GridRef(1+q,1) GridRef(4+q,1) GridRef(7+q,1)];
    yy = [GridRef(1+q,2) GridRef(4+q,2) GridRef(7+q,2)];
    zz = [GridRef(1+q,3) GridRef(4+q,3) GridRef(7+q,3)];
    plot3(xx,yy,zz,'-','Color','b','MarkerSize',10,'MarkerFaceColor','#D9FFFF')
    xx = [GridRef(10+q,1) GridRef(13+q,1) GridRef(16+q,1)];
    yy = [GridRef(10+q,2) GridRef(13+q,2) GridRef(16+q,2)];
    zz = [GridRef(10+q,3) GridRef(13+q,3) GridRef(16+q,3)];
    plot3(xx,yy,zz,'-','Color','b','MarkerSize',10,'MarkerFaceColor','#D9FFFF')
    xx = [GridRef(19+q,1) GridRef(22+q,1) GridRef(25+q,1)];
    yy = [GridRef(19+q,2) GridRef(22+q,2) GridRef(25+q,2)];
    zz = [GridRef(19+q,3) GridRef(22+q,3) GridRef(25+q,3)];
    plot3(xx,yy,zz,'-','Color','b','MarkerSize',10,'MarkerFaceColor','#D9FFFF')
end
for t = 0:2
    xx = [GridRef(1+t,1) GridRef(10+t,1) GridRef(19+t,1)];
    yy = [GridRef(1+t,2) GridRef(10+t,2) GridRef(19+t,2)];
    zz = [GridRef(1+t,3) GridRef(10+t,3) GridRef(19+t,3)];
    plot3(xx,yy,zz,'-','Color','b','MarkerSize',10,'MarkerFaceColor','#D9FFFF')
    xx = [GridRef(4+t,1) GridRef(13+t,1) GridRef(22+t,1)];
    yy = [GridRef(4+t,2) GridRef(13+t,2) GridRef(22+t,2)];
    zz = [GridRef(4+t,3) GridRef(13+t,3) GridRef(22+t,3)];
    plot3(xx,yy,zz,'-','Color','b','MarkerSize',10,'MarkerFaceColor','#D9FFFF')
    xx = [GridRef(7+t,1) GridRef(16+t,1) GridRef(25+t,1)];
    yy = [GridRef(7+t,2) GridRef(16+t,2) GridRef(25+t,2)];
    zz = [GridRef(7+t,3) GridRef(16+t,3) GridRef(25+t,3)];
    plot3(xx,yy,zz,'-','Color','b','MarkerSize',10,'MarkerFaceColor','#D9FFFF')
end

%hXL = xlabel('R (lever arm length) [m]','Rotation',23,'FontSize',16);
hXL = xlabel('R (lever arm length) [m]','FontSize',16);
%hXL.Position = [0.2 -360 0];
%hYL = ylabel('theta (lever arm angle) [deg]','Rotation',-35,'FontSize',16);
hYL = ylabel('theta (lever arm angle) [deg]','FontSize',16);
%hYL.Position = [0 360 0];
zlabel('L0 (spring resting length) [m]','FontSize',16);


%% EXONET TORQUE
% BODY
S.BODY.Mass = 70; % body mass in [kg] for a body height of 1.70 m
S.BODY.Lengths = [0.46 0.42 0.26]; % segments lengths (thigh, shank, foot) in [m]

% EXONET
S.EXONET.nJoints = 22;    % 11 = only ankle-toe springs
                        % 22 = only knee-toe springs
                        % 2 = both ankle-toe and knee-toe springs
S.EXONET.nParameters = 3; % number of parameters for each spring
S.EXONET.nElements = 1;   % number of stacked elements per joint
S.EXONET.K = 1000;        % springs stiffness in [N/m]

%S.TENSION = @(L0,L)   (S.EXONET.K.*(L-L0)).*((L-L0)>0).*((L*L0)>0); % Linear Tension Springs
S.TENSION = @(L0,L)   (S.EXONET.K.*(L-L0)).*((L-L0)<0).*((L*L0)>0); % Linear Compression Springs

% IMPORT GAIT DATA
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
% 4 PERIODS OF STANCE PHASE
% Initial contact (0%–2% of the Gait Cycle)
% Loading response (2%–12% of the Gait Cycle)
% Midstance (12%–31% of the Gait Cycle)
% Preswing (50%–60% of the Gait Cycle)
GP = [9 26 46 63];


% COMPUTE AND PLOT EXONET TORQUE
S.TAUs = zeros(length(S.PHIs),2,length(Grid));
markerSize = 4;
lineWidth = 1;

subplot(2,5,[3 4 8 9])
u = 0;
for i = 1:length(Grid)
    pp = [Grid(i,1),Grid(i,2),Grid(i,3)];
    S = exoNetTorquesLeg(pp,S);
    TAUs(:,:,i) = S.TAUs;
    if mod(i,length(Xgrid)) == 1
        u = u + 1;
    end
    plot(TAUs(:,1,i),TAUs(:,2,i),'^-','LineWidth',lineWidth,'Color',colors{u},'MarkerSize',markerSize,'MarkerFaceColor',colors{u})
%     drawnow;
%     pause(1);
    hold on
    axis equal
    grid on
end


% PLOT BEST EXONET TORQUE
S = exoNetTorquesLeg(p,S);
plot(S.TAUs(:,1),S.TAUs(:,2),'^-','LineWidth',lineWidth,'Color','b','MarkerSize',markerSize,'MarkerFaceColor','b')


% PLOT DESIRED TORQUE
plot(S.TAUsDESIRED(:,1),S.TAUsDESIRED(:,2),'^-','LineWidth',lineWidth,'Color','r','MarkerSize',markerSize,'MarkerFaceColor','r')
xlabel({'Ankle Torque [Nm]';'plantarflexion    dorsiflexion'},'FontSize',15);
ylabel({'Knee Torque [Nm]';'flexion    extension'},'FontSize',15);
%text(TAUsDESIRED(1,1),TAUsDESIRED(1,2),'HSR','FontSize',12,'FontWeight','bold');
%text(TAUsDESIRED(63,1),TAUsDESIRED(63,2),'TOR','FontSize',12,'FontWeight','bold');
%text(TAUsDESIRED(end,1),TAUsDESIRED(end,2),'TOR','FontSize',12,'FontWeight','bold');
%title('INITIAL CONTACT - LOADING RESPONSE - MIDSTANCE - PRESWING','FontSize',13);


% SAVE FIGURE WITH HIGH RESOLUTION
% f = gcf;
% exportgraphics(f,'result.jpg','Resolution',1000)


%% SCORE
ankleVar = zeros(length(S.PHIs),length(colors));
kneeErr = zeros(length(S.PHIs),length(colors));
kneeSum = zeros(length(S.PHIs),length(colors));
for t = 1:length(S.PHIs)
    o = 1;
    for i = 1:length(Xgrid):length(Grid)
    % ankle torque variance for each gait angle along the 9 directions
    ankleVar(t,o) = var(S.TAUs(t,1,i:i+length(Xgrid)-1));
    % sum of the squares of knee torque error for each gait angle along the 9 directions
    kneeErr(t,o) = sum((S.TAUs(t,2,i:i+length(Xgrid)-1)-S.TAUsDESIRED(t,2)).^2);
    % sum of the squares of knee torque for each gait angle along the 9 directions
    kneeSum(t,o) = sum((S.TAUs(t,2,i:i+length(Xgrid)-1)).^2);
    o = o + 1;
    end
end


% ankle torque variance minus sum of the squares of knee torque error for each gait angle along the 9 directions
score1 = ankleVar - kneeErr;
% ankle torque variance minus sum of the squares of knee torque error along the 9 directions
for h = 1:length(colors)
    score2(h) = mean(score1(:,h));
end
subplot(2,5,5)
for uu = 1:size(score1,2)
    plot(uu,score1(:,uu),'o','Color','k','MarkerSize',3,'MarkerFaceColor',colors{uu})
    hold on
end
for u = 1:length(score2)
    plot(u,score2(u),'o','Color','k','MarkerSize',8,'MarkerFaceColor',colors{u})
    hold on
end
xlabel('Axis Direction','FontSize',15);
ylabel('[Nm]^2','FontSize',15);
title('ankle torque variance minus sum of the squares of knee torque error','FontSize',10);


% ankle torque variance minus sum of the squares of knee torque for each gait angle along the 9 directions
score3 = ankleVar - kneeSum;
% ankle torque variance minus sum of the squares of knee torque along the 9 directions
for h = 1:length(colors)
    score4(h) = mean(score3(:,h));
end
subplot(2,5,10)
for uu = 1:size(score3,2)
    plot(uu,score3(:,uu),'o','Color','k','MarkerSize',3,'MarkerFaceColor',colors{uu})
    hold on
end
for u = 1:length(score4)
    plot(u,score4(u),'o','Color','k','MarkerSize',8,'MarkerFaceColor',colors{u})
    hold on
end
xlabel('Axis Direction','FontSize',15);
ylabel('[Nm]^2','FontSize',15);
title('ankle torque variance minus sum of the squares of knee torque','FontSize',10);
end