path                 = pwd;
gtGraphFileName      = 'kitti-0003-0-40_GT.graph';
measGraphFileName    = 'kitti-0003-0-40_Meas.graph';
resultsGraphFileName = 'kitti-0003-0-40_result.g2o';
startFrame = 0; endFrame = 40;

% files path
gtFilePath     = strcat(path,'/Data/GraphFiles/',gtGraphFileName);
measFilePath   = strcat(path,'/Data/GraphFiles/',measGraphFileName);
resultFilePath = strcat(path,'/Data/GraphFiles/',resultsGraphFileName);

% vertices labels
config.poseVertexLabel            = 'VERTEX_POSE_R3_SO3';
config.pointVertexLabel           = 'VERTEX_POINT_3D';
config.SE3MotionVertexLabel       = 'VERTEX_SE3Motion';
% edges labels
config.posePoseEdgeLabel          = 'EDGE_R3_SO3';
config.posePointEdgeLabel         = 'EDGE_3D';
config.pointSE3MotionEdgeLabel    = 'EDGE_2POINTS_SE3MOTION';
config.pointsDataAssociationLabel = '2PointsDataAssociation';
% dimensions
config.dimPose                    = 6;
config.dimPoint                   = 3;

% GT graph
noDataAssociationGTFile = deleteDataAssociationFromGraphFile(gtFilePath);
gtCell                  = graphFileToCell(config,noDataAssociationGTFile);
graphGT                 = graphCellToGraph(config,gtCell);

% results graph
motionVertices          = identifyMotionIndices(gtFilePath);
resultGraphFile         = convertG2OGraphFileToOurs(config,resultFilePath,motionVertices);
resultCell              = graphFileToCell(config,resultGraphFile);
resultGraph             = graphCellToGraph(config,resultCell);


% pose error
resultsError = errorAnalysis(gtFilePath,graphGT,resultGraph);
% motion error
[translationError,rotationError,speedError] = objectMotionError(resultGraphFile,gtFilePath,measFilePath,startFrame,endFrame);
