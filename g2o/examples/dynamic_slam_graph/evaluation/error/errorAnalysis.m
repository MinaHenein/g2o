function [results] = errorAnalysis(gtFilePath,graphGT,graphN)
%ERRORANALYSYS Summary of this function goes here
%   Detailed explanation goes here

%poses
posesN = [graphN.vertices(identifyVertices(graphN,'pose')).value];
posesGT = [graphGT.vertices(identifyVertices(graphN,'pose')).value];
v_rel_pose = AbsoluteToRelativePoseR3xso3(posesGT(:,1),posesN(:,1));

%% 1. Pose Error
%ATE
[ATE_translation_error,ATE_rotation_error,...
    ATE_squared_translation_error,ATE_squared_rotation_error,absRotError] = ...
    Compute_AbsoluteTrajectoryError(posesN,posesGT,v_rel_pose);
%RPE
n_delta = 1;
[RPE_translation_error,RPE_rotation_error,...
    RPE_squared_translation_error,RPE_squared_rotation_error,relRotError] = ...
    Compute_RelativePoseError(posesN,posesGT,v_rel_pose,n_delta);
%AARPE
[AARPE_translation_error,AARPE_rotation_error,AARPE_squared_translation_error,...
    AARPE_squared_rotation_error] = ...
    Compute_RelativePoseError_AllToAll(posesN,posesGT,v_rel_pose);

results.ATE_translation_error               = ATE_translation_error;
results.ATE_rotation_error                  = ATE_rotation_error;
results.ATE_squared_translation_error       = ATE_squared_translation_error;
results.ATE_squared_rotation_error          = ATE_squared_rotation_error;
results.RPE_translation_error               = RPE_translation_error;
results.RPE_rotation_error                  = RPE_rotation_error;
results.RPE_squared_translation_error       = RPE_squared_translation_error;
results.RPE_squared_rotation_error          = RPE_squared_rotation_error;
results.AARPE_translation_error             = AARPE_translation_error;
results.AARPE_rotation_error                = AARPE_rotation_error;
results.AARPE_squared_translation_error     = AARPE_squared_translation_error;
results.AARPE_squared_rotation_error        = AARPE_squared_rotation_error;
results.absRotationErrorVector = absRotError;
results.relRotationErrorVector = relRotError;

%% debug
fprintf('Absolute Trajectory Translation Error: %.3f \n',results.ATE_translation_error)
fprintf('Absolute Trajectory Rotation Error: %.3f \n',results.ATE_rotation_error)
fprintf('Relative Trajectory Translation Error: %.3f \n',results.RPE_translation_error)
fprintf('Relative Trajectory Rotation Error: %.3f \n',results.RPE_rotation_error)
fprintf('All to All Relative Pose Translation Error: %.3f \n',results.AARPE_translation_error)
fprintf('All to All Relative Pose Rotation Error: %.3f \n',results.AARPE_rotation_error)

[~,~,~,~,~,~,totalTranslation,~] = computeDistanceAndRotation(gtFilePath);
averageCameraTranslation = totalTranslation/(size(posesN,2)-1);
fprintf('Relative Trajectory Percentage Translation Error: %.3f \n',...
    100*results.RPE_translation_error/averageCameraTranslation)
fprintf('Relative Trajectory Rotation Error (deg/m): %.3f \n',...
    results.RPE_rotation_error/averageCameraTranslation)

end

