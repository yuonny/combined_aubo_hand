clear all

% Load your robot model
robot = importrobot("Krysalis_Assem_w_tip_w_wrist.urdf");
show(robot, 'Visuals', 'on','Frames', 'off');

% Set axes background to white
ax = gca;
ax.Color = 'w';

% Define RGB colors for each end effector
color1 = [1, 0, 0];   % Red
color2 = [0, 0, 1];   % Blue
color3 = [0, 1, 0];   % Green
color4 = [0, 0, 0];   % Black
color5 = [1.0, 0.5, 0.0];   % Orange

% Define end-effector names corresponding to the fingertips
ee1 = "I_DIP_Tip"; % Index finger
ee2 = "M_DIP_Tip"; % Middle finger
ee3 = "R_DIP_Tip"; % Ring finger
ee4 = "P_DIP_Tip"; % Pinky finger
ee5 = "T_IP_Tip"; % Thumb

hold on

% Process for ee1 (Index finger)
rng default
[workspace1, configs1] = generateRobotWorkspace(robot, {}, ee1, 'IgnoreSelfCollision','on', 'MaxNumSamples', 25000);
s1 = scatter3(workspace1(:,1), workspace1(:,2), workspace1(:,3), 10, color1, 'filled');

% Process for ee2 (Middle finger)
[workspace2, configs2] = generateRobotWorkspace(robot, {}, ee2, 'IgnoreSelfCollision','on', 'MaxNumSamples', 25000);
s2 = scatter3(workspace2(:,1), workspace2(:,2), workspace2(:,3), 10, color2, 'filled');

% Process for ee3 (Ring finger)
[workspace3, configs3] = generateRobotWorkspace(robot, {}, ee3, 'IgnoreSelfCollision','on', 'MaxNumSamples', 25000);
s3 = scatter3(workspace3(:,1), workspace3(:,2), workspace3(:,3), 10, color3, 'filled');

% Process for ee4 (Pinky finger)
[workspace4, configs4] = generateRobotWorkspace(robot, {}, ee4, 'IgnoreSelfCollision','on', 'MaxNumSamples', 25000);
s4 = scatter3(workspace4(:,1), workspace4(:,2), workspace4(:,3), 10, color4, 'filled');

% Process for ee5 (Thumb)
[workspace5, configs5] = generateRobotWorkspace(robot, {}, ee5, 'IgnoreSelfCollision','on', 'MaxNumSamples', 25000);
s5 = scatter3(workspace5(:,1), workspace5(:,2), workspace5(:,3), 10, color5, 'filled');

legend([s5, s1, s2, s3, s4,], "D1", "D2", "D3", "D4", "D5", 'Location', 'bestoutside', 'FontSize', 14);
axis off
hold off

alphaVal = 0.04; % Try different values if needed

% Compute manipulability volume using alphaShape
shpIndex = alphaShape(workspace1, alphaVal);
vol1 = volume(shpIndex)*1e9;

shpMiddle = alphaShape(workspace2, alphaVal);
vol2 = volume(shpMiddle)*1e9;

shpRing = alphaShape(workspace3, alphaVal);
vol3 = volume(shpRing)*1e9;

shpPinky = alphaShape(workspace4, alphaVal);
vol4 = volume(shpPinky)*1e9;

shpThumb = alphaShape(workspace5, alphaVal);
vol5 = volume(shpThumb)*1e9;

% Display results
fprintf("Manipulability Volumes (in cubic mm):\n");
fprintf("Thumb (D1):  %.2f\n", vol5);
fprintf("Index (D2):  %.2f\n", vol1);
fprintf("Middle (D3): %.2f\n", vol2);
fprintf("Ring (D4):   %.2f\n", vol3);
fprintf("Pinky (D5):  %.2f\n", vol4);
fprintf("Total Hand Volume: %.2f\n", vol1 + vol2 + vol3 + vol4 + vol5);

% Visualize alpha shapes
figure;
subplot(2,3,1); plot(shpIndex); title('Index (D2)'); axis equal
subplot(2,3,2); plot(shpMiddle); title('Middle (D3)'); axis equal
subplot(2,3,3); plot(shpRing); title('Ring (D4)'); axis equal
subplot(2,3,4); plot(shpPinky); title('Pinky (D5)'); axis equal
subplot(2,3,5); plot(shpThumb); title('Thumb (D1)'); axis equal

% Opposability volume:
% --- Estimate voxel volume based on point spacing in thumb workspace ---
D = pdist2(workspace5, workspace5);
D(D == 0) = NaN;  % Ignore self-distances
avgSpacing = nanmean(min(D, [], 2)); % Average nearest-neighbor distance (in meters)
voxelVol = avgSpacing^3;             % Voxel volume (m^3)
voxelVol_mm3 = voxelVol * 1e9;       % Convert to mm^3

% --- Opposability estimation: count how many thumb points lie within each finger's shape ---
opposeVolTH_Index  = sum(inShape(shpIndex,  workspace5)) * voxelVol_mm3;
% opposeVolTH_Middle = sum(inShape(shpMiddle, workspace5)) * voxelVol_mm3;
opposeVolTH_Ring   = sum(inShape(shpRing,   workspace5)) * voxelVol_mm3;
opposeVolTH_Pinky  = sum(inShape(shpPinky,  workspace5)) * voxelVol_mm3;

% --- Display results ---
fprintf("Opposability Volumes (Thumb vs Finger) in mm³:\n");
fprintf("Index:  %.2f\n", opposeVolTH_Index);
% fprintf("Middle: %.2f\n", opposeVolTH_Middle);
fprintf("Ring:   %.2f\n", opposeVolTH_Ring);
fprintf("Pinky:  %.2f\n", opposeVolTH_Pinky);

%Visualize
% --- Visualize Opposability Regions (thumb points inside other fingers' workspace) ---
figure;
hold on;
axis equal;
grid on;
title('Thumb-Finger Opposability Regions');
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');

% Plot each full workspace in light color
scatter3(workspace1(:,1), workspace1(:,2), workspace1(:,3), 3, [1 0.7 0.7], 'filled'); % Index (light red)
scatter3(workspace3(:,1), workspace3(:,2), workspace3(:,3), 3, [0.6 1 0.6], 'filled'); % Ring (light green)
scatter3(workspace4(:,1), workspace4(:,2), workspace4(:,3), 3, [0.7 0.7 0.7], 'filled'); % Pinky (gray)
scatter3(workspace5(:,1), workspace5(:,2), workspace5(:,3), 3, [1.0 0.8 0.4], 'filled'); % Thumb (light orange)

% Highlight opposability regions: thumb points inside each finger's alpha shape
opposePoints_Index = workspace5(inShape(shpIndex,  workspace5), :);
opposePoints_Ring  = workspace5(inShape(shpRing,   workspace5), :);
opposePoints_Pinky = workspace5(inShape(shpPinky,  workspace5), :);

scatter3(opposePoints_Index(:,1), opposePoints_Index(:,2), opposePoints_Index(:,3), ...
    20, [0 1 0], 'filled');  % Green for Thumb-Index
scatter3(opposePoints_Ring(:,1),  opposePoints_Ring(:,2),  opposePoints_Ring(:,3), ...
    20, [0 0.5 1], 'filled'); % Blueish for Thumb-Ring
scatter3(opposePoints_Pinky(:,1), opposePoints_Pinky(:,2), opposePoints_Pinky(:,3), ...
    20, [0.4 0 0.6], 'filled'); % Purple for Thumb-Pinky

legend({'Index Workspace','Ring Workspace','Pinky Workspace','Thumb Workspace',...
        'Thumb-Index Region','Thumb-Ring Region','Thumb-Pinky Region'}, ...
        'Location','bestoutside');