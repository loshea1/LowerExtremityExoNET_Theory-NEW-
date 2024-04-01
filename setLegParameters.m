function S = setLegParameters(S)
%Lengths, pose, Mass, RLoHi, thetaLoHi, L0LoHi, LL0LoHi, nParameters, K2j, K1j, K, nElements, springType, nJoints, nTries, AA
% Create UIFigure and hide until all components are created
UIFigure = uifigure('Visible', 'off');
UIFigure.Position = [100 100 530 548];
UIFigure.Name = 'Leg Parameters';

RLoHimSpinnerLabel = uilabel(UIFigure, "HorizontalAlignment", "right", "Visible", "off", "Position", [68 252 59 22],"Text", "RLoHi [m]");
RLo = uispinner(UIFigure, "Step", 0.1, "Limits", [0 Inf], "Visible", "off", "Position", [32 221 63 22], "Value", 0.1);
RHi = uispinner(UIFigure, "Step", 0.1, "Limits", [0 Inf], "Visible", "off", "Position", [97 221 60 22], "Value", 0.3);

thetaLoHidegLabel = uilabel(UIFigure, "HorizontalAlignment", "right", "Visible", "off", "Position", [55 180 87 22],"Text", "thetaLoHi [deg]");
thetaLo = uispinner(UIFigure, "Limits", [-360 360], "Visible", "off", "Position", [32 149 63 22], "Value", 200);
thetaHi = uispinner(UIFigure, "Limits", [0 360], "Visible", "off", "Position", [97 149 60 22], "Value", 360);

L0LoHimSpinnerLabel = uilabel(UIFigure, "HorizontalAlignment", "right", "Visible", "off", "Position", [67 108 63 22],"Text", "L0LoHi [m]");
L0Lo = uispinner(UIFigure, "Step", 0.1, "Limits", [0 Inf], "Visible", "off", "Position", [32 77 64 22], "Value", 0.1);
L0Hi = uispinner(UIFigure, "Step", 0.1, "Limits", [0 Inf], "Visible", "off", "Position", [98 77 59 22], "Value", 0.2);

LL0LoHimLabel = uilabel(UIFigure, "HorizontalAlignment", "right", "Visible", "off", "Position", [60 41 70 22],"Text", "LL0LoHi [m]");
LL0Lo = uispinner(UIFigure, "Limits", [0 Inf], "Visible", "off", "Position", [32 10 64 22], "Value", 0.8, "Step", 0.1);
LL0Hi = uispinner(UIFigure, "Limits", [0 Inf], "Visible", "off", "Position", [98 10 59 22], "Value", 1, "Step", 0.1);

% Create TypeofSpringButtonGroup
springGroup = uibuttongroup(UIFigure, "SelectionChangedFcn",...
    @springButtonChange, "Position", [65 433 123 108]);
springGroup.Title = 'Type of Spring';

hold_2 = uiradiobutton(springGroup, "Text", "hold", "Position", [11 62 45 22],"Visible", "off", "Value", true); %placeholder until something is selected
CompressionButton = uiradiobutton(springGroup, "Text", "Compression", "Position", [11 17 93 22]);
TensionButton = uiradiobutton(springGroup, "Text", "Tension", "Position", [11 40 65 22]);

% Create TypeofJointButtonGroup
jointGroup = uibuttongroup(UIFigure, "SelectionChangedFcn", @jointButtonChange,"Position", [295 409 196 132]);
jointGroup.Title = 'Type of Joint';
jointGroup.Visible = 'off';

hold_1 = uiradiobutton(jointGroup, "Text", "hold", "Position", [11 86 45 22], "Value", true,"Visible", "off"); %placeholder until something is selected
KneeToe = uiradiobutton(jointGroup, "Text", "Only knee-toe", "Position",[11 64 97 22]);
AnkleToe = uiradiobutton(jointGroup, "Text", "Only ankle-toe", "Position", [11 42 99 22]);
HipKnee = uiradiobutton(jointGroup, "Text", "Hip-Knee", "Position", [11 20 106 22]);
Both = uiradiobutton(jointGroup, "Text", "Both ankle-toe and knee-toe", "Position", [11 -1 173 22]);


ofstackedelementsperjointDropDownLabel = uilabel(UIFigure, "HorizontalAlignment", "right", "Visible", "off", "Position", [259 368 171 22],"Text", "# of stacked elements per joint:");
ofstackedelementsperjointDropDown = uidropdown(UIFigure, "Items", {'1 ', '2', '3', '4', '5', '6'}, "Visible", "off", "Position", [445 368 46 22], "Value", '1 ');

K1jEditFieldLabel  = uilabel(UIFigure, "HorizontalAlignment", "right", "Visible", "off", "Position", [322 326 25 22],"Text", "K1j");
K1jEditField = uieditfield(UIFigure, 'numeric', "Limits", [0 Inf], "Visible", "off", "Tooltip", {'spring stiffness in [N/m] for a 1-joint compression spring'}, "Position", [362 326 100 22], "Value", 600);

K2jEditFieldLabel  = uilabel(UIFigure, "HorizontalAlignment", "right", "Visible", "off", "Position", [323 292 25 22],"Text", "K2j");
K2jEditField = uieditfield(UIFigure, 'numeric', "Limits", [0 Inf], "Visible", "off", "Tooltip", {'spring stiffness in [N/m] for a 2-joint compression spring'}, "Position", [363 292 100 22], "Value", 600);

ThighEditFieldLabel  = uilabel(UIFigure, "HorizontalAlignment", "right", "Visible", "off", "Position", [224 156 39 22],"Text", "Thigh");
ThighLength = uieditfield(UIFigure, 'numeric', "Limits", [0 Inf], "Visible", "off", "Position", [278 156 100 22], "Value", 0.46);
ThighAngle = uieditfield(UIFigure, 'numeric', "Limits", [0 Inf], "Visible", "off", "Position", [427 156 100 22], "Value", 10);

ShankEditFieldLabel = uilabel(UIFigure, "HorizontalAlignment", "right", "Visible", "off", "Position", [221 125 43 22],"Text", "Shank");
ShankLength = uieditfield(UIFigure, 'numeric', "Limits", [0 Inf], "Visible", "off", "Position", [279 125 100 22], "Value", 0.42);
ShankAngle = uieditfield(UIFigure, 'numeric', "Limits", [0 Inf], "Visible", "off", "Position", [427 125 100 22], "Value", 20);

FootEditFieldLabel = uilabel(UIFigure, "HorizontalAlignment", "right", "Visible", "off", "Position", [231 92 33 22],"Text", "Foot");
FootLength =  uieditfield(UIFigure, 'numeric', "Limits", [0 Inf], "Visible", "off", "Position", [279 92 100 22], "Value", 0.26);
FootAngle = uieditfield(UIFigure, 'numeric', "Limits", [0 Inf], "Visible", "off", "Position", [428 92 100 22], "Value", 90);

BodyMasskgEditFieldLabel = uilabel(UIFigure, "HorizontalAlignment", "right", "Visible", "off", "Position", [299 231 87 22],"Text", "Body Mass [kg]");
BodyMasskgEditField = uieditfield(UIFigure, 'numeric', "Limits", [0 Inf], "Visible", "off", "Position", [401 231 100 22], "Value", 70, "Tooltip", {'Body mass for a body height of 1.7 m'});

LengthmLabel = uilabel(UIFigure, "Visible", "off", "Position", [298 189 62 22], "Text", "Length [m]");
AngledegLabel = uilabel(UIFigure, "Visible", "off", "Position", [443 189 66 22], "Text", "Angle [deg]");

ParametersEditFieldLabel = uilabel(UIFigure, "HorizontalAlignment", "right", "Visible", "off", "Position", [57 309 67 22],"Text", "Parameters");
ParametersEditField = uieditfield(UIFigure, 'numeric', "Limits", [0 Inf], "Visible", "off", "Tooltip", {'number of parameters for each spring'}, "Position", [139 309 41 22],"Value", 3);

TriesEditFieldLabel = uilabel(UIFigure, "HorizontalAlignment", "right", "Visible", "off", "Position", [82 387 42 22],"Text", "# Tries");
TriesEditField =  uieditfield(UIFigure, 'numeric', "Limits", [0 Inf], "Visible", "off", "Position", [139 387 41 22],"Value", 50);

KEditFieldLabel = uilabel(UIFigure, "HorizontalAlignment", "right", "Visible", "off", "Position", [322 326 25 22],"Text", "K");
KEditField = uieditfield(UIFigure, 'numeric', "Limits", [0 Inf], "Visible", "off", "Position", [362 326 100 22]);

AntiAssistanceCheckBox = uicheckbox(UIFigure, "Visible", "off", "Text", "Anti-Assistance", "Position", [91 347 105 22]);

% Create RunButton
RunButton = uibutton(UIFigure, 'push', 'Text', 'RUN', 'Position', [324 10 100 22]);
RunButton.BackgroundColor = [0 1 0];
RunButton.ButtonPushedFcn = @saveAndClose;

% Show the figure after all components are created
UIFigure.Visible = 'on';

uiwait(UIFigure);
    function springButtonChange(src, event)
        jointGroup.Visible = 'on';
        
        if TensionButton.Value == true
            LL0Lo.Value = 0.05;
            LL0Hi.Value = 0.2;
        elseif CompressionButton.Value == true
            LL0Lo.Value = 0.80;
            LL0Hi.Value = 1;
        end

    end
    function jointButtonChange(src, event)
        if event.NewValue == Both
            S.EXONET.nJoints = 2;
            K1jEditFieldLabel.Visible = 'on';
            K1jEditField.Visible = 'on';
            K2jEditFieldLabel.Visible = 'on';
            K2jEditField.Visible = 'on';
            S.flag = [0,1];
        elseif event.NewValue == KneeToe
            S.EXONET.nJoints = 22;
            K2jEditField.Value = 1000;
            RLo.Value = 0.03;
            RHi.Value = 0.30;
            thetaLo.Value = 0;
            thetaHi.Value = 360;
            L0Lo.Value = 0.40;
            L0Hi.Value = 0.50;
            KEditField.Visible = 'off';
            KEditFieldLabel.Visible = 'off';
            K1jEditFieldLabel.Visible = 'on';
            K1jEditField.Visible = 'on';
            K2jEditFieldLabel.Visible = 'on';
            K2jEditField.Visible = 'on';
            S.flag = 1;
        elseif event.NewValue == AnkleToe
            S.EXONET.nJoints = 11;
            K1jEditFieldLabel.Visible = 'on';
            K1jEditField.Visible = 'on';
            K2jEditFieldLabel.Visible = 'on';
            K2jEditField.Visible = 'on';
            
            KEditField.Visible = 'off';
            KEditFieldLabel.Visible = 'off';
            S.flag = 0;
        elseif event.NewValue == HipKnee
            S.EXONET.nJoints = 3;
            KEditField.Value = 2000;
            RLo.Value = 0.001;
            RHi.Value = 0.16;
            thetaLo.Value = -360;
            thetaHi.Value = 360;
            L0Lo.Value = 0.05;
            L0Hi.Value = 0.30;
            S.flag = 2;
            
            KEditField.Visible = 'on';
            KEditFieldLabel.Visible = 'on';
            
            K1jEditFieldLabel.Visible = 'off';
            K1jEditField.Visible = 'off';
            K2jEditFieldLabel.Visible = 'off';
            K2jEditField.Visible = 'off';
        end
        
        AntiAssistanceCheckBox.Visible = 'on';
        TriesEditFieldLabel.Visible = 'on';
        TriesEditField.Visible = 'on';
        LL0Hi.Visible = 'on';
        L0LoHimSpinnerLabel.Visible = 'on';
        RLoHimSpinnerLabel.Visible = 'on';
        RHi.Visible = 'on';
        RLo.Visible = 'on';
        thetaLo.Visible = 'on';
        thetaLoHidegLabel.Visible = 'on';
        thetaHi.Visible = 'on';
        L0Lo.Visible = 'on';
        L0LoHimSpinnerLabel.Visible = 'on';
        L0Hi.Visible = 'on';
        ofstackedelementsperjointDropDownLabel.Visible = 'on';
        ofstackedelementsperjointDropDown.Visible = 'on';
        ThighEditFieldLabel.Visible = 'on';
        ThighLength.Visible = 'on';
        ShankEditFieldLabel.Visible = 'on';
        ShankLength.Visible = 'on';
        FootEditFieldLabel.Visible = 'on';
        FootLength.Visible = 'on';
        BodyMasskgEditFieldLabel.Visible = 'on';
        BodyMasskgEditField.Visible = 'on';
        ThighAngle.Visible = 'on';
        ShankAngle.Visible = 'on';
        FootAngle.Visible = 'on';
        LengthmLabel.Visible = 'on';
        AngledegLabel.Visible = 'on';
        ParametersEditFieldLabel.Visible = 'on';
        ParametersEditField.Visible = 'on';
        LL0Lo.Visible = 'on';
        LL0LoHimLabel.Visible = 'on';
        LL0Hi.Visible = 'on';
        RLoHimSpinnerLabel.Visible = 'on';
        RHi.Visible = 'on';
        RLo.Visible = 'on';
        thetaLo.Visible = 'on';
        thetaLoHidegLabel.Visible = 'on';
        thetaHi.Visible = 'on';
        L0Lo.Visible = 'on';
        L0LoHimSpinnerLabel.Visible = 'on';
        L0Hi.Visible = 'on';
        ofstackedelementsperjointDropDownLabel.Visible = 'on';
        ofstackedelementsperjointDropDown.Visible = 'on';
        ThighEditFieldLabel.Visible = 'on';
        ThighLength.Visible = 'on';
        ShankEditFieldLabel.Visible = 'on';
        ShankLength.Visible = 'on';
        FootEditFieldLabel.Visible = 'on';
        FootLength.Visible = 'on';
        BodyMasskgEditFieldLabel.Visible = 'on';
        BodyMasskgEditField.Visible = 'on';
        ThighAngle.Visible = 'on';
        ShankAngle.Visible = 'on';
        FootAngle.Visible = 'on';
        LengthmLabel.Visible = 'on';
        AngledegLabel.Visible = 'on';
        ParametersEditFieldLabel.Visible = 'on';
        ParametersEditField.Visible = 'on';
        LL0Lo.Visible = 'on';
        LL0LoHimLabel.Visible = 'on';
        LL0Hi.Visible = 'on';
    end
% Callback function for the "Run" button
    function saveAndClose(~, ~)
        % Get the updated values from UI components
        % Lengths, pose, Mass, RLoHi, thetaLoHi, L0LoHi, LL0LoHi, nParameters, K2j, K1j, K, nElements, springType, nJoints, nTries, AA
        S.BODY.Lengths = [ThighLength.Value, ShankLength.Value, FootLength.Value];
        S.BODY.pose = [ThighAngle.Value, ShankAngle.Value, FootAngle.Value];
        S.BODY.Mass = BodyMasskgEditField.Value;
        
        S.RLoHi = [RLo.Value RHi.Value];
        S.thetaLoHi = [thetaLo.Value thetaHi.Value];
        S.L0LoHi = [L0Lo.Value L0Hi.Value];
        S.LL0LoHi = [LL0Lo.Value LL0Hi.Value]; %for 2-joint
        
        S.AA = AntiAssistanceCheckBox.Value;
        S.nTries = TriesEditField.Value;
        
        S.EXONET.nParameters = ParametersEditField.Value;
        S.EXONET.nElements = str2double(ofstackedelementsperjointDropDown.Value);
        
        if S.EXONET.nJoints ~= 3
            S.EXONET.K2j = K2jEditField.Value;
            S.EXONET.K1j = K1jEditField.Value;
        else
            S.EXONET.K = KEditField.Value; %spring stiffness for hip
        end
        
        if CompressionButton.Value == true
            S.Spring = 1;
        elseif TensionButton.Value == true
            S.Spring = 2;
        end
        % Close the UI figure
        close(UIFigure);
    end

end