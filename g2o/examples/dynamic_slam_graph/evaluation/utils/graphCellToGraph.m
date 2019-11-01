function [graph] = graphCellToGraph(config,graphCell)

lineLengths  = cellfun(@length,graphCell);
vertexLines  = (lineLengths==3);
verticesCell = graphCell(vertexLines);
nVertices = size(verticesCell,1);

graph.vertices = Vertex();
graph.vertices(1:nVertices) = Vertex();

%construct vertices
for i = 1:nVertices
    switch verticesCell{i}{1}
        case config.poseVertexLabel
            type = 'pose';
            value = verticesCell{i}{3};
        case config.SE3MotionVertexLabel
            type = 'SE3Motion';
            value = verticesCell{i}{3};
        case config.pointVertexLabel
            type = 'point';
            value = verticesCell{i}{3};            
        otherwise; error('wrong type')
    end
    covariance = [];
    iEdges = [];
    index = verticesCell{i}{2};
    
    %construct
    graph.vertices(i) = Vertex(value,covariance,type,iEdges,index);
end

% sort vertices just in case
[~, I] = sort([graph.vertices.index]);
vertices = graph.vertices(I);
graph.vertices = vertices;

end

