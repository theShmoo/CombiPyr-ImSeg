function [ cp ] = buildCombinatoricalPyramid( image, DEBUG, neighborhood )
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
    case 3
        % everything is fine
    case 2 
        neighborhood = 4;
    case 1
        neighborhood = 4;
        DEBUG = 0;
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
tic
dart_values = computeDartValues(image,1);
disp(['Computed dart values in t = ',num2str(toc)]);

%% build the combinatorical map from the computed dart values of the image
tic
cm = combinatorialMap(dart_values, width, height);
disp(['Build the first level in t = ',num2str(toc)]);

%% build the pyramid
cp = struct;
cp.levels = {cm};
cp.num_elements = cm.num_active;
cp.levels{end}.level = 1;

while true
    % logging
    fprintf('\nPyramid level %d:\n',cp.levels{end}.level);
    % /logging
    
    tic
    contraction_darts = computeContractionDarts(cp.levels{end},DEBUG);
    disp(['Computing contraction darts in t = ',num2str(toc)]);
    
    if DEBUG
        drawActiveDarts(cp.levels{end},contraction_darts); 
        title(['level ',num2str(cp.levels{end}.level)]);
    end;
    
    tic
    cp.levels{end+1} = contractCombinatorialMap(cp.levels{end}, contraction_darts, DEBUG);
    disp(['Contracting darts in t = ',num2str(toc)]);
    
    tic
    cp.levels{end} = contractionSimplification(cp.levels{end}, DEBUG);
    disp(['Simplify darts in t = ',num2str(toc)]);
    
    cp.num_elements(end+1) = length(cp.levels{end}.active);
    if cp.num_elements(end) == 0
       error('contracted and removed too much');
    elseif cp.num_elements(end) == cp.num_elements(end-1) || isempty(contraction_darts)
        break;
    end
end

drawActiveDarts(cp.levels{end});
title('last level');


end