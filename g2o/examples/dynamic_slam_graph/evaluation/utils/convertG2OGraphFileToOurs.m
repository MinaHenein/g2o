function newFilePath = convertG2OGraphFileToOurs(config,filepath,motionVertices)

% vertices only
%VERTEX_SE3:QUAT i x y z qx qy qz qw 
%VERTEX_TRACKXYZ i x y z

fileID = fopen(filepath,'r');
Data = textscan(fileID,'%s','delimiter','\n','whitespace',' ');
CStr = Data{1};

poseVertexFormat  = strcat('%s %d ',repmat(' %f',1,config.dimPose));
pointVertexFormat = strcat('%s %d ',repmat(' %f',1,config.dimPoint));

CStrOutput = cell(length(CStr),1);
for i=1:length(CStr)
line = CStr{i,1};
splitLine = strsplit(line,' ');
g2oLabel = splitLine{1};
switch g2oLabel
    case 'VERTEX_SE3:QUAT'
        index = str2double(splitLine{1,2});
        if ismember(index, motionVertices)
            label = config.SE3MotionVertexLabel;
        else
            label = config.poseVertexLabel;
        end
        value= [];
        for j=1:config.dimPose+1
            value = [value,str2double(splitLine{1,3+j-1})];
        end
        xyzw = value(4:end)';
        wxyz = [xyzw(4),xyzw(1),xyzw(2),xyzw(3)];
        aa = q2a(wxyz);
        CStrOutput(i) =  cellstr(sprintf(poseVertexFormat,label,index,value(1:3),aa));
    case 'VERTEX_TRACKXYZ'
        label = config.pointVertexLabel;
        index = str2double(splitLine{1,2});
        value = [];
        for j=1:config.dimPoint
            value = [value,str2double(splitLine{1,3+j-1})];
        end
        CStrOutput(i) =  cellstr(sprintf(pointVertexFormat,label,index,value));
end
end
fclose(fileID);

% Save in a different file
newFilePath = strcat(filepath(1:end-4),'.graph');
fileID = fopen(newFilePath,'w');
fprintf(fileID, '%s\n', CStrOutput{:});
fclose(fileID);

% delete empty lines
fid = fopen(newFilePath, 'r');
Data = textscan(fid, '%s', 'delimiter', '\n', 'whitespace', '');
fclose(fid);
C = deblank(Data{1}); 
C(cellfun('isempty', C)) = [];
fid = fopen(newFilePath, 'w');
fprintf(fid, '%s\n', C{:});
fclose(fid);

end