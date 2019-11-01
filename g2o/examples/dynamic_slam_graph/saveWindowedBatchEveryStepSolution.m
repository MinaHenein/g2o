function saveWindowedBatchEveryStepSolution(resultFilePath, nSteps)

graphCellStr = cell(0);
allIndices = [];

for i = 1:nSteps
    fileID = fopen(strcat(resultFilePath,num2str(i-1),'.g2o'),'r');
    %read lines
    tline = fgets(fileID);
    while ischar(tline)
        lineSplit = strsplit(tline);
        label = lineSplit{1};
        values = cellfun(@str2num,{lineSplit{2:end-1}});
        index = values(1);
        switch label
            case 'VERTEX_SE3:QUAT'
                if ~ismember(index,allIndices)
                    allIndices = [allIndices, index];
                end
                value= [];
                for j=1:7
                    value = [value,values(1,2+j-1)];
                end
                lineCellStr = strcat({label},{' '},{num2str(values(1))},{' '},...
                    {num2str(value(1))},{' '},{num2str(value(2))},{' '},{num2str(value(3))},{' '},...
                    {num2str(value(4))},{' '},{num2str(value(5))},{' '},{num2str(value(6))},{' '},{num2str(value(7))},{' '});
            case 'VERTEX_TRACKXYZ'
                if ~ismember(index,allIndices)
                    allIndices = [allIndices, index];
                end
                lineCellStr = strcat({label},{' '},{num2str(values(1))},{' '},...
                    {num2str(values(2))},{' '},{num2str(values(3))},{' '},{num2str(values(4))},{' '});
            otherwise
                % get next line
                tline = fgets(fileID);
                continue;
        end
        indx = find(allIndices == index);
        %store
        graphCellStr(indx,1) = lineCellStr;
        % get next line
        tline = fgets(fileID);
    end
    
end

fileID = fopen(strcat(resultFilePath(1:end-1),'.graph'),'w');
fprintf(fileID, '%s\n', graphCellStr{:});
fclose(fileID);

end