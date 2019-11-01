function [graphCell] = graphFileToCell(config,filePath)
%GRAPHFILETOCELL Parses graph file into cell array
%   This is largely for convenience. ie edge indexes are added here.
%   In some cases however, additional edges are added to the graph - but
%   these are specific to the solution method and are not required in the
%   graph file: eg prior on the pose, edge n'n-1=0 constraining plane
%   normals to be unit vectors.

%open file
fileID = fopen(filePath,'r');

graphCell = cell(0);
%read lines
tline = fgets(fileID);
while ischar(tline)
    lineSplit = strsplit(tline);
    label = lineSplit{1};
    values = cellfun(@str2num,{lineSplit{2:end-1}});
    switch label
        case config.poseVertexLabel
            lineCell = {label,values(1),values(2:7)'};
            %store
            graphCell{end+1,1} = lineCell;
        case config.SE3MotionVertexLabel
            lineCell = {label,values(1),values(2:7)'};
            %store
            graphCell{end+1,1} = lineCell;
        case config.pointVertexLabel
            lineCell = {label,values(1),values(2:4)'};
            %store
            graphCell{end+1,1} = lineCell;
        otherwise
            %error('%s type invalid',label)
    end
    %get next line
    tline = fgets(fileID);
end

%% close file
fclose(fileID);

end

