% ***********************************************************************
% OPTIMIZATION:
% Make a robust effort to find the global optimization
% and return the best choice of several random initial guesses
% ***********************************************************************

function S = robustOptoLeg(S)

%% Setup

fprintf('\n\n\n\n robustOpto~~\n')
drawnow    % to update the figures in the graphic screen
pause(0.1) % to pause for 0.1 seconds before continuing
S.GridPHIsVal = 0;

if S.EXONET.nJoints == 11 || S.EXONET.nJoints == 22 ||S.EXONET.nJoints == 2
    ProjectName = 'Ankle ExoNET';
elseif S.EXONET.nJoints == 3
    ProjectName = 'Hip ExoNET';
elseif S.case == 2
    ProjectName = 'Gait Torques Field';
end

p0 = S.EXONET.pConstraint(:,1)';       % initial values of the parameters
% Randomize initial values of the parameters
j = 2:3:length(S.EXONET.pConstraint);
p0(j) = p0(j) + randn(1,length(j)).*10; % to randomize theta
k = 1:length(S.EXONET.pConstraint); k(j) = [];
p0(k) = p0(k) + randn(1,length(k)).*0.1; % to randomize R and L0
% % % % %
S.bestP = p0;                          % best parameters
S.bestCost = 1e5;                      % best cost, initially high (10^16)
costs = zeros(S.nTries,1);             % vector collecting the cost at each try

S = exoNetTorquesLeg(S.bestP,S); % initial guess for the solution
%TAUs = exoNetTorquesLeg(bestP,PHIs); % initial guess for the solution

%% Set the plot
clf % to reset the figure

subplot(1,2,1)
title(ProjectName)

if S.case == 1.1
    drawMan;
    plotAngleTorque(S);
    
    subplot(1,2,2); ax2 = axis(); % to get axis zoom frame
    subplot(1,2,1); ax1 = axis(); % to get axis zoom frame
    
    plotAngleTorque(S);
    
    subplot(1,2,1)
    drawMan;
    subplot(1,2,1); axis(ax1); % to reframe the window
    subplot(1,2,2); axis(ax2); % to reframe the window
elseif S.case == 1.2
    drawBodyLeg(S.BODY);
    plotVectFieldLeg(S.PHIs,S.TAUsDESIRED,'r'); % to plot the desired torque field in red
    
    subplot(1,2,2); ax2 = axis(); % to get axis zoom frame
    subplot(1,2,1); ax1 = axis(); % to get axis zoom frame
    
    plotVectFieldLeg(S.PHIs,S.TAUs,0.9*[1 1 1]); % to plot the initial guess in grey
    plotVectFieldLeg(S.PHIs, S.TAUsDESIRED,'r');  % to plot the desired torque field in red
    
    subplot(1,2,1)
    drawBodyLeg(S.BODY);
    subplot(1,2,1); axis(ax1); % to reframe the window
    subplot(1,2,2); axis(ax2); % to reframe the window
    
elseif S.case == 2 %gait stabilization
    plotVectFieldLeg(S.AllPHIs,S.AllTAUsDESIRED,'r'); % to plot the desired torque field in red
    plotVectFieldLeg(S.AllPHIs,S.TAUs,[0.9 0.9 0.9]); % to plot the initial guess in grey
    axis([-20 50 -10 100])
    subplot(1,2,1)
    drawMan;
    
end

S = drawExonetsLeg(S.bestP, S); % to draw the ExoNET line segments



title(ProjectName)
drawnow; pause(0.1) % to show the plots


%% Loop multiple optimization tries with Simulated Annealing Perturbation
fprintf('\n\n\n\n Begin Optimization~~\n')
tic
for TRY = 1:S.nTries
    fprintf('Opt#%d..',TRY);
    %define anonymous function for fminsearch
    S.p = p0;
    [p,~] = fminsearch(@(p) costLeg(S), S.p); % OPTIMIZATION
    S.p = p;
    [p,c] = fminsearch(@(p) costLeg(S), S.p);  % OPTIMIZATION
    if c < S.bestCost                   % if the cost is decreased
        fprintf(' c=%g, ',c); p';      % to display the cost
        S.bestCost = c;                 % to update the best cost
        S.bestP = p;                    % to update the best parameters
        S = exoNetTorquesLeg(p,S);      % new guess for the torque field
    else
        fprintf('\n\n (not an improvement)~~\n')
    end
    costs(TRY) = S.bestCost; % vector collecting the cost at each try
    pKick = range(S.EXONET.pConstraint').*(S.nTries/TRY); % to simulate Annealing Perturbation
    % Kick p away from its best value
    j = 2:3:length(S.EXONET.pConstraint);
    p0(j) = S.bestP(j) + 1.*randn(1,length(j)).*pKick(j); % for theta
    k = 1:length(S.EXONET.pConstraint); k(j) = [];
    p0(k) = S.bestP(k) + 1.*randn(1,length(k)).*pKick(k).*0.1; % for R and L0
    % % % % %
end
toc


%% Wrap up the Optimization with one last run starting at the best location
fprintf('\n\n\n\n Final Optimization~~\n')
[p,c] = fminsearch(@(p) costLeg(S),S.bestP); % last and best OPTIMIZATION
if c < S.bestCost
    S.bestCost = c;
    S.bestP = p;
    fprintf(' c=%g, ',c); p'
else
    fprintf('\n\n (not an improvement)~~\n')
end
S.p = S.bestP;
[c,meanErr] = costLeg(S); meanErr
costs(TRY+1) = c; % vector collecting the cost at each try


%% Update the plots
% Draw the ExoNET and plot the torques
clf % to reset the figure
subplot(1,2,1)

if S.case == 1.1
    drawMan;
    S = drawExonetsLeg(S.bestP, S); % to draw the ExoNET line segments using the bestP
    S = exoNetTorquesTensionsLeg(S.bestP,S); % to calculate the final solution
    
    % Adjust axis and title
    subplot(1,2,2); axis(ax2); % to zoom the frame
    subplot(1,2,1); axis(ax1); % to zoom the frame
    title([ProjectName ', RMSE = ' num2str(meanErr) ' Nm']); % to show the average error
    drawnow; pause(0.1) % to update the screen
    
    subplot(1,2,1)
    drawMan;
    S = drawExonetsLeg(S.bestP, S); % to draw the ExoNET line segments
    
    Residual = S.TAUsDESIRED - S.TAUs; % to calculate the Residual
    plotAngleTorque(S,'exOn');
elseif S.case == 1.2
    drawBodyLeg(S.BODY);
    drawExonetsLeg(S.bestP,S);          % to draw the ExoNET line segments
    
    S = exoNetTorquesTensionsLeg(S.bestP,S,'plotIt'); % to calculate the final solution
    
    Residual = S.TAUsDESIRED - S.TAUs;                        % to calculate the Residual
    plotVectFieldLeg(S.PHIs,S.TAUsDESIRED,'r'); % to plot the desired torque field in red
    plotVectFieldLeg(S.PHIs, S.TAUs,'b');        % to plot the best solution in blue
    
    % Adjust axis and title
    subplot(1,2,2); axis(ax2); % to zoom the frame
    subplot(1,2,1); axis(ax1); % to zoom the frame
    title([ProjectName ', Average Error = ' num2str(meanErr)]); % to show the average error
    drawnow; pause(0.1) % to update the screen
elseif S.case == 2
    S = exoNetTorquesLeg(S.bestP,S); % to calculate the final solution
    S.GridPHIsVal = 1;
    S = exoNetTorquesLeg(S.bestP,S); % to calculate ExoNET torques in the grid
    
    plotVectFieldLeg(S.AllPHIs,S.AllTAUsDESIRED,[1 0.5451 0.4039]); % to plot the desired torque field in red
    plotVectFieldLeg(S.PHIs,S.TAUsDESIRED,'r'); % to plot the gait torque field in red
    plotVectFieldLeg(S.AllPHIs,S.TAUs,[0.1569 0.2157 0.4275]); % to plot the best solution in blue
    plotVectFieldLeg(S.GridPHIs,S.GridTAUs,[0.6863 0.6980 0.8510]); % to plot ExoNET torques in the grid
    
    drawMan;
    S = drawExonetsLeg(S.bestP, S); % to draw the ExoNET line segments
    title([ProjectName ', Average Error = ' num2str(meanErr)],'FontSize',14) % to show the average error
end

end