function motionIndices = identifyMotionIndices(gtFileName)

fileID = fopen(gtFileName,'r');
Data = textscan(fileID, '%s', 'delimiter', '\n', 'whitespace', '');
CStr = Data{1};
fclose(fileID);

IndexC = strfind(CStr, 'VERTEX_SE3Motion');
Index = find(not(cellfun('isempty',IndexC)));

motionIndices = [];

for i=1:1:length(Index)
    fileID = fopen(gtFileName,'r');
    line = textscan(fileID,'%s',1,'delimiter','\n','headerlines',Index(i)-1);
    splitLine = strsplit(cell2mat(line{1,1}),' ');
    %label = splitLine{1,1};
    motionIndices = [motionIndices, str2double(splitLine{1,2})];
end 

motionIndices = unique(motionIndices);
end