function drawCombinatorialMap( cm, width, height, neighborhood )
%COMBINATORIALMAP draws an image from a combinatorial map
% INPUT:
%   cm ... the combinatorial map: 
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
%   width ... the with of the image
%   height ... the height of the image
%   neighborhood ... the neighborhood. Currently only 4 is supported
% AUTHOR:
%   David Pfahler

switch nargin
    case 4
        % everything is fine
    case 3
       neighborhood = 4;
    otherwise
        error('Invalid number of arguments');
end
assertNeighborhood(neighborhood);

% the coordinates of the pixels
num_outgoing_darts = zeros(height,width);

for dart = cm.active.'
   orbit = getOrbit(cm, dart, 0);
   involution = cm.involution(dart);
   num_outgoing_darts(cm.x(involution),cm.y(involution)) = length(orbit);
end

num_outgoing_darts'
