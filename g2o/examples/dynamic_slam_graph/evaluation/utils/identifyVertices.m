function [indexes] = identifyVertices(graph,type)
%IDENTIFYVERTICES returns indexes of desired vertices

vertexTypes = {graph.vertices.type}';

%find observations that have target value
indexes = strcmp(vertexTypes,type);
indexes = find(indexes);

end

