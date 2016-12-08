function [ dart_indices ] = getDartIndices( width, height, class_str, neighborhood )
%COMBINATORIALMAP Create a combinatorial map from an image
% INPUT:
%   width ... the with of the image
%   height ... the height of the image
%   class ... the data type of the darts indices (default: uint16)
%   neighborhood ... the neighborhood. Currently only 4 is supported
% OUTPUT:
%   dart_indices ... returns the indices darts of the darts of a
%       combinatorial map. a struct with the inidices of: (N, S, E, W)
%COPYRIGHT:
%   David Pfahler 2016
%PROJECT:
%   CombPyr_ImSeg

switch nargin
    case 4
        % everything is fine
    case 3
       class_str = 'uint32';
    case 2 
       class_str = 'uint32';
       neighborhood = 4;
    otherwise
        error('Invalid number of arguments');
end
assertNeighborhood(neighborhood);

num_ns = (height-1)*width;
num_ew = height*(width-1);

% start values:
start_n = width * 3 - 1;
start_s = 1;
start_e = 2;
start_w = 5;

changes_N = ones(num_ns-1,1) * 4;
changes_S = ones(num_ns-1,1) * 4;
changes_E = ones(num_ew-1,1) * 4;
changes_W = ones(num_ew-1,1) * 4;

% set boundaries:
changes_N(1:width:end) = 3;
changes_N(width:width:end) = 3;
changes_S(1:width:end) = 3;
changes_S(width:width:end) = 3;
changes_E(1:width-1:end) = 3;
changes_E(width-1:width-1:end) = 7;
changes_W(width-1:width-1:end) = 7;
changes_W(width-2:width-1:end) = 3;

% set lower boundary:
changes_N(end-width+2:end) = changes_N(end-width+2:end) - 1;
% set upper boundary:
changes_S(1:width-1) = changes_S(1:width-1) - 1;
% set left boundary:
changes_E(1:width-1) = changes_E(1:width-1) - 1;
changes_W(1:width-2) = changes_W(1:width-2) - 1;
% set right boundary:
changes_E(end-width+2:end) = changes_E(end-width+2:end) - 1;
changes_W(end-width+2:end) = changes_W(end-width+2:end) - 1;
changes_W(end-width+2) = changes_W(end-width+2) - 1;

% create the struct for the indices
dart_indices = struct;
dart_indices.N = uint32(start_n + cumsum([0; changes_N]));
dart_indices.S = uint32(start_s + cumsum([0; changes_S]));
dart_indices.E = uint32(start_e + cumsum([0; changes_E]));
dart_indices.W = uint32(start_w + cumsum([0; changes_W]));

