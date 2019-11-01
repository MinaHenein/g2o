function [translationError,rotationError,speedError] = ...
    objectMotionError(resultFilePath,gtFilePath,measFilePath,startFrame,endFrame)

%% object motion estimates
fileID = fopen(resultFilePath,'r');
Data = textscan(fileID,'%s','delimiter','\n','whitespace',' ');
resultCStr = Data{1};
fclose(fileID);
IndexC = strfind(resultCStr, 'VERTEX_SE3Motion');
IndexObjMotions = find(not(cellfun('isempty',IndexC)));
objectMotions = zeros(6,length(IndexObjMotions));
objectMotionIndices = zeros(1,length(IndexObjMotions));
for i=1:length(IndexObjMotions)
    line = resultCStr{IndexObjMotions(i),1};
    splitLine = strsplit(line,' ');
    motionValue = str2double(splitLine(3:end))';
    objectMotions(:,i) = motionValue;
    objectMotionIndices(1,i) = str2double(splitLine(2));
end

%% gt object motions
fileID = fopen(gtFilePath,'r');
gtData = textscan(fileID,'%s','delimiter','\n','whitespace',' ');
gtCStr = gtData{1};
fclose(fileID);
IndexC = strfind(gtCStr, 'VERTEX_SE3Motion');
IndexObjMotions = find(not(cellfun('isempty',IndexC)));
gtObjectMotions = zeros(6,length(IndexObjMotions));
gtObjectMotionIndices = zeros(1,length(IndexObjMotions));
for i=1:length(IndexObjMotions)
    line = gtCStr{IndexObjMotions(i),1};
    splitLine = strsplit(line,' ');
    gtMotionValue = str2double(splitLine(3:end))';
    gtObjectMotions(:,i) = gtMotionValue;
    gtObjectMotionIndices(1,i) = str2double(splitLine(2));
end

translationError = inf; rotationError = inf; speedError = inf;
if size(objectMotions,2)==0
    disp('no dynamic objects detected; thus no motion error to be calculated')
    return;
end

%assert(size(objectMotions,2)==size(gtObjectMotions,2));
%assert(isequal(objectMotionIndices,gtObjectMotionIndices));

%% object motions errors
objectMotionTranslationError = zeros(1,length(IndexObjMotions));
objectMotionRotationError = zeros(1,length(IndexObjMotions));

for i=1:length(IndexObjMotions)
    currentObjectMotion = objectMotions(:,objectMotionIndices==gtObjectMotionIndices(i));
    currentGTObjectMotion = gtObjectMotions(:,i);    
    
    currentObjectMotionError = poseToTransformationMatrix(currentObjectMotion)\...
        poseToTransformationMatrix(currentGTObjectMotion);
    currentObjectMotionError = transformationMatrixToPose(currentObjectMotionError); 
    
    objectMotionTranslationError(1,i) = 100*(norm(currentObjectMotionError(1:3))/...
            norm(currentGTObjectMotion(1:3)));
    objectMotionRotationError(1,i) = wrapToPi(norm(currentObjectMotionError(4:6)))*...
        (180/pi)/norm(currentGTObjectMotion(1:3));
end

translationError = mean(objectMotionTranslationError);
rotationError = mean(objectMotionRotationError);

%Sequence0000
%vanTrError = mean([objectMotionTranslationError(1:2:11) objectMotionTranslationError(12:2:16) objectMotionTranslationError(18:end)]);
%vanRotError = mean([objectMotionRotationError(1:2:11) objectMotionRotationError(12:2:16) objectMotionRotationError(18:end)]);
%cyclistTrError = mean([objectMotionTranslationError(2:2:10) objectMotionTranslationError(13:2:17)]);
%cyclistRotError = mean([objectMotionRotationError(2:2:10) objectMotionRotationError(13:2:17)]);

%Sequence0003
% obj1TrError = mean([objectMotionTranslationError(1:26) objectMotionTranslationError(28)]);
% obj1RotError = mean([objectMotionRotationError(1:26) objectMotionRotationError(28)]);
% obj2TrError = mean([objectMotionTranslationError(27) objectMotionTranslationError(29:end)]);
% obj2RotError = mean([objectMotionRotationError(27) objectMotionRotationError(29:end)]);

%% object speeds errors
objectPoints = pointObservability(measFilePath);
motionIndices = unique(gtObjectMotionIndices);
objectMotionSpeedError = [];
%Sequence0003
%obj1SpeedError = [];
%obj2SpeedError = [];
for i=1:length(IndexObjMotions)
    currentObjectMotion = objectMotions(:,objectMotionIndices==gtObjectMotionIndices(i));
    currentGTObjectMotion = gtObjectMotions(:,i);
    for j = 1:endFrame-(startFrame-1)
        if size(objectPoints,2) > j
            objectIndx = find(motionIndices == gtObjectMotionIndices(i));
            if objectIndx <= size(objectPoints,1)
            objectFramePoints = objectPoints{objectIndx,j};
            if ~isempty(objectFramePoints)
                pointFramePositions = zeros(3,length(objectFramePoints));
                pointFrameGTPositions = zeros(3,length(objectFramePoints));
                for k = 1:length(objectFramePoints)
                    IndexC = strfind(resultCStr, strcat({'VERTEX_POINT_3D'},{' '},...
                        {num2str(objectFramePoints(k))},{' '}));
                    lineIndex = find(~cellfun('isempty', IndexC));
                    splitLine = strsplit(resultCStr{lineIndex,1},' ');
                    pointFramePositions(:,k) = str2double(splitLine(3:end))';
                    
                    IndexC = strfind(gtCStr, strcat({'VERTEX_POINT_3D'},{' '},...
                        {num2str(objectFramePoints(k))},{' '}));
                    lineIndex = find(~cellfun('isempty', IndexC));
                    splitLine = strsplit(gtCStr{lineIndex,1},' ');
                    pointFrameGTPositions(:,k) = str2double(splitLine(3:end))';
                end
                centroid = mean(pointFramePositions,2);
                gtCentroid = mean(pointFrameGTPositions,2);
                 
                speedVector = currentObjectMotion(1:3) - (eye(3)-rot(currentObjectMotion(4:6)))*centroid;
                gtSpeedVector = currentGTObjectMotion(1:3) - (eye(3)-rot(currentGTObjectMotion(4:6)))*gtCentroid;
                objectMotionSpeedError = [objectMotionSpeedError,100*norm(gtSpeedVector-speedVector)/norm(gtSpeedVector)];
                %Sequence0003
                %if ismember(i,[1:26,28])
                %    obj1SpeedError = [obj1SpeedError,100*norm(gtSpeedVector-speedVector)/norm(gtSpeedVector)];
                %else
                %    obj2SpeedError = [obj2SpeedError,100*norm(gtSpeedVector-speedVector)/norm(gtSpeedVector)];
                %end
            end
            end
        end
    end
end
speedError = mean(objectMotionSpeedError);

fprintf('Object Motion Percentage Translation Error: %.3f \n',translationError)
fprintf('Object Motion Rotation Error (deg/m): %.3f \n',rotationError)
fprintf('Object Motion Percentage Speed Error: %.3f \n',speedError)

end