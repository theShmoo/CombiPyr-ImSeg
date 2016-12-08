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

%% draw the map
drawCombinatorialMap(cm, width, height);

%% reduce unencessary first darts
% keep_ids = cm.values >= 0;
% cm.num_darts = length(keep_ids);
% cm.values = uint8(cm.values(keep_ids));
% cm.involution = cm.involution(keep_ids);
% cm.next = cm.next(keep_ids);
% cm.prev = cm.prev(keep_ids);

%% get the surviving indices
tic;
surviving_indices = computeSurvivors(cm);
toc;

%% get the next level
next_level = contractCombinatorialMap(cm, surviving_indices);






end
