cd '/home/mina/data/mina/workspace/src/Git/g2o/g2o/examples/dynamic_slam_graph'
path = '/home/mina/data/mina/workspace/src/Git/g2o/g2o/examples/dynamic_slam_graph';
gtGraphFileName = 'kitti-0003-0-40_GT.graph';
measGraphFileName = 'kitti-0003-0-40_Meas.graph';
resultsGraphFileName = 'kitti-0003-0-40_result_incremental.graph';
startFrame = 0; endFrame = 40;

config = CameraConfig();
config = setAppConfig(config);
config.set('folderPath',path);
config.set('graphFileFolderName','GraphFiles');
config.set('pointsDataAssociationLabel','2PointsDataAssociation')
config.set('posePointEdgeLabel','EDGE_3D');
config.set('pointSE3MotionEdgeLabel','EDGE_2POINTS_SE3MOTION');

config.set('measurementsFileName',measGraphFileName);
config.set('groundTruthFileName',gtGraphFileName);

deleteDataAssociationFromGraphFile(strcat(path,'/Data/GraphFiles/',gtGraphFileName))
gtCell = graphFileToCell(config,strcat(gtGraphFileName(1:end-6),'_noDataAssociation.graph'));
graphGT = Graph(config,gtCell);
    
motionVertices = identifyMotionIndices(strcat(path,'/Data/GraphFiles/',gtGraphFileName));
convertG2OGraphFileToOurs(config,strcat(path,'/Data/GraphFiles/',resultsGraphFileName),motionVertices)

resultsGraphFileName = strcat(resultsGraphFileName(1:end-6),'G2O.graph');
fid = fopen(strcat(path,'/Data/GraphFiles/',resultsGraphFileName), 'r');
Data = textscan(fid, '%s', 'delimiter', '\n', 'whitespace', '');
fclose(fid);
C = deblank(Data{1}); 
C(cellfun('isempty', C)) = [];
fid = fopen(strcat(path,'/Data/GraphFiles/',resultsGraphFileName), 'w');
fprintf(fid, '%s\n', C{:});
fclose(fid);

resultCell = graphFileToCell(config,resultsGraphFileName);
resultGraph = Graph(config,resultCell);

resultsError = errorAnalysis(config,graphGT,resultGraph);

resultFilePath = strcat(pwd,'/Data/GraphFiles/',resultsGraphFileName);
gtFilePath = strcat(pwd,'/Data/GraphFiles/',gtGraphFileName);
measFilePath = strcat(pwd,'/Data/GraphFiles/',measGraphFileName);
[translationError,rotationError,speedError] = objectMotionError(resultFilePath,...
    gtFilePath,measFilePath,startFrame,endFrame);
