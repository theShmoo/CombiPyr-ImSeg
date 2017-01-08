function [ cp ] = buildCombinatoricalPyramid( image, neighborhood )
%BUILDCOMBINATORICALPYRAMID buids a combinatorical pyramid from the input
%image
%INPUT:
%   image_grayscale ... the grayscale input image (default:
%   'cameraman.tif') 
%   neighborhood ... the neighborhood. Currently only 4 is supported
%   (default: 4)
%OUTPUT:
%   cp ... the dart values for every neighbor as cell array (N, S,
%   W, E) 
%COPYRIGHT:
%   David Pfahler 2016
%PROJECT:
%   CombPyr_ImSeg

% check number of input arguments and set default values
switch nargin
    case 2
        % everything is fine
    case 1
        neighborhood = 4;
    case 0
        neighborhood = 4;
        image = loadExampleImage();
    otherwise
        error('Invalid number of arguments');
end
assertNeighborhood(neighborhood);

%% get some basic properties of the image
[width, height] = size(image);

%% compute the dart values of the graph
dart_values = computeDartValues(image,1);

%% build the combinatorical map from the computed dart values of the image
cm = combinatorialMap(dart_values, width, height);

%% build the pyramid
cp = struct;
cp.levels = {cm};
cp.num_elements = cm.num_active;
cp.levels{end}.level = 1;

while true
    % logging
    fprintf('\nPyramid level %d:\n',cp.levels{end}.level);
    % /logging
    
    contraction_darts = computeContractionDarts(cp.levels{end});
    drawActiveDarts(cp.levels{end},contraction_darts);
    cp.levels{end+1} = contractCombinatorialMap(cp.levels{end}, contraction_darts);
    drawActiveDarts(cp.levels{end});
    cp.levels{end} = contractionSimplification(cp.levels{end});
    % drawActiveDarts(cp.levels{end});
    
    cp.num_elements(end+1) = length(cp.levels{end}.active);
    if cp.num_elements(end) == cp.num_elements(end-1) || cp.num_elements(end) == 0
        break;
    end
end


end