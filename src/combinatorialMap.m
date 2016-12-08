function [ cm ] = combinatorialMap( dart_values, width, height, neighborhood )
%COMBINATORIALMAP Create a combinatorial map from an image
%INPUT:
%   dart_values ... the values which the darts. a struct with a dart from
%   every pixel to every neighboring pixel (based on the neighborhood
%   function)
%   width ... the width of the image
%   height ... the height of the image
%   neighborhood ... the neighborhood. (default: 4)
%OUTPUT:
%   cm ... returns the combinatorial map: 
%       cm.values (num_darts x 1 int16)
%           contains the dart values
%       cm.involution (num_darts x 1 uint32) 
%           column the involution dart index 
%       cm.next column (num_darts x 1 uint32)
%           contains the index of the next dart in the map 
%       cm.prev column (num_darts x 1 uint32)
%           contains the index of the previous dart in the map 
%       cm.num_darts (1 x 1 uint32) 
%           contains the number of darts in the map
%       
%COPYRIGHT:
%   David Pfahler 2016
%PROJECT:
%   CombPyr_ImSeg

% check number of input arguments and set default values
switch nargin
    case 4
        % everything is fine
    case 3
       neighborhood = 4;
    otherwise
        error('Invalid number of arguments');
end
assertNeighborhood(neighborhood);

%% build the graph graph

% the number of darts with the image
num_darts = width*height*4 - 2*width - 2*height;

%% create the darts structure
cm = struct;

% the first column contains the dart values
cm.values = int16(zeros(num_darts,1));

% the second column the involution dart index so how to come back to this
% index
cm.involution = uint32(zeros(num_darts,1));

% the third column contains the index of the next dart in the map
% but it gets assigned later
% cm.next = uint32(zeros(num_darts,1));

% the forth column contains the index of the previous dart in the map (the
% involution of the next dart)
% but it gets assigned later
cm.prev = uint32(zeros(num_darts,1));

% additional combinatorical map information:
cm.num_darts = num_darts;

%% get the dart indices of a standard image
dart_indices = getDartIndices(width,height);

%% first value in edges is the difference
cm.values(dart_indices.N) = dart_values.N;
cm.values(dart_indices.S) = dart_values.S;
cm.values(dart_indices.W) = dart_values.W;
cm.values(dart_indices.E) = dart_values.E;

%% second value is the involution
cm.involution(dart_indices.N) = dart_indices.S;
cm.involution(dart_indices.S) = dart_indices.N;
cm.involution(dart_indices.W) = dart_indices.E;
cm.involution(dart_indices.E) = dart_indices.W;

%% third value is the index of the next dart

next_darts_first_row = repmat([2; -1; -1], width-2, 1);
% some specials of the left and right upper corner of the first row:
next_darts_first_row = [1; -1; next_darts_first_row; 1; -1; 2; -1; -1];

% this are the next darts for one row of the image (within)
next_darts_one_row = repmat([2; 2; -1; -3], width-2, 1);

% combined with the first and the last pixel (the boundaries) 
next_darts_middle = repmat([next_darts_one_row; 1; 1; -2; 2; -1; -1], height-2, 1);
next_darts_middle(end-2:end) = [1; -1; 1];

next_darts_last_row = repmat([1; -2; 1], width-2, 1);
% special of the left and right bottom corner
next_darts_last_row = [next_darts_last_row; -1];

% put together the next darts
next_darts = [next_darts_first_row; next_darts_middle; next_darts_last_row];
next_darts = next_darts + double(1:num_darts).';
cm.next = uint32(next_darts);

%% fourth value is the index of the previous dart
cm.prev(cm.next) = uint32(1:num_darts);

end

