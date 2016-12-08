function [orbit] = getOrbit( cm, id, neighborhood )
%COMBINATORIALMAP draws an image from a combinatorial map
%INPUT:
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
%   id ... (1x1 uint32) the index of which the orbit has to be obtained
%   neighborhood ... the neighborhood. Currently only 4 is supported
%OUTPUT:
%   orbit ... (1 x num_elements) the orbit from the input index
%COPYRIGHT:
%   David Pfahler 2016
%PROJECT:
%   CombPyr_ImSeg

switch nargin
    case 3
        % everything is fine
    case 2
       neighborhood = 4;
    otherwise
        error('Invalid number of arguments');
end
assertNeighborhood(neighborhood);

if id > cm.num_darts || id < 0
    error('The dart id exceeds the number of dart indices in the combinatorical map');
end

% initialize the orbit with only the id of the current dart
orbit = id;

% iterate over the orbit until you find the starting dart and save all
% found darts in the orbit
next_dart = cm.next(id);
while next_dart ~= id
   orbit(end+1) = next_dart;
   next_dart = cm.next(next_dart);
end


if length(orbit) == 1
    warning(['The dart with the index ', id, ' has no orbit']);
end