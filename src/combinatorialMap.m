function [ darts ] = combinatorialMap( dart_values, width, height, neighborhood )
%COMBINATORIALMAP Create a combinatorial map from an image
% INPUT:
%   dart_values ... the values which the darts should contain
%   width ... the with of the image
%   height ... the height of the image
%   neighborhood ... the neighborhood. Currently only 4 is supported
% OUTPUT:
%   darts ... returns the darts of the map: 
%       the first column contains the dart values
%       the second column the involution dart index
%       the third column contains the index of the next dart in the map
%       the forth column contains the index of the previous dart in the map
% AUTHOR:
%   David Pfahler

% check number of input arguments and set default values
switch nargin
    case 4
        % everything is fine
    case 3
       neighborhood = 4;
    otherwise
        error('Invalid number of arguments');
end
checkNeighborhood(neighborhood);

%% build graph
num_darts = width*height*4 - 2*width - 2*height;

dart_indices = getDartIndices(width,height);

%% put together the darts arrays
darts = zeros(num_darts,4);
% first value in edges is the difference
% second value is the involution
darts(dart_indices{1}, 1:2) = [dart_values{1} dart_indices{2}];
darts(dart_indices{2}, 1:2) = [dart_values{2} dart_indices{1}];
darts(dart_indices{3}, 1:2) = [dart_values{3} dart_indices{4}];
darts(dart_indices{4}, 1:2) = [dart_values{4} dart_indices{3}];

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

% put together
next_darts = [next_darts_first_row; next_darts_middle; next_darts_last_row];
next_darts = next_darts + double(1:num_darts).';
darts(:,3) = next_darts;

%% fourth value is the index of the previous dart
darts(next_darts,4) = double(1:num_darts);

end

