function  newFilePath = deleteDataAssociationFromGraphFile(FilePath)
FID = fopen(FilePath, 'r');
if FID == -1, error('Cannot open file'), end
Data = textscan(FID,'%s','Delimiter','\n');
CStr = Data{1};
fclose(FID);

IndexC = strfind(CStr, '2PointsDataAssociation');
Index = find(cellfun('isempty', IndexC));

% Save the file again:
newFilePath = strcat(FilePath(1:end-6),'_noDataAssociation.graph');
FID = fopen(newFilePath, 'w');
if FID == -1, error('Cannot open file'), end
fprintf(FID, '%s\n', CStr{Index});
fclose(FID);
end