function [tx,ty,tz,ox,oy,oz,translation,rotation] = computeDistanceAndRotation(gtFilePath)
% GT
fileID = fopen(gtFilePath,'r');
Data = textscan(fileID, '%s', 'delimiter', '\n', 'whitespace', '');
CStr = Data{1};
fclose(fileID);

nPoses = 0;
for i=1:1:length(CStr)
    splitLine = strsplit(CStr{i,1},' ');
    label = splitLine{1,1};
    if strcmp(label(1:length('VERTEX_POSE')),'VERTEX_POSE')
        nPoses = nPoses+1;
        value = str2double(splitLine(3:end));
        poses(:,nPoses) = value'; 
    end
end

tx = 0; ty = 0; tz = 0;
ox = 0; oy = 0; oz = 0;
translation = 0;
rotation = 0;
deg_per_rad = 180/pi;

for i=1:nPoses-1
    relativePose = AbsoluteToRelativePoseR3xso3(poses(:,i),poses(:,i+1));
    translation = translation + norm(relativePose(1:3));
    rotation = rotation + wrapToPi(norm(relativePose(4:6))) * deg_per_rad;
    tx = tx + norm(relativePose(1));
    ty = ty + norm(relativePose(2));
    tz = tz + norm(relativePose(3));
    R = rot(relativePose(4:6));
    eulXYZ = rot2Eul(R,'XYZ');
    ox = ox + norm(eulXYZ(1));
    oy = oy + norm(eulXYZ(2));
    oz = oz + norm(eulXYZ(3));
end

end