function [next_level] = contractCombinatorialMap( darts, surviving_indices, neighborhood )
%COMPUTESURVIVORS contracts all edges in the combinatorial map 
% INPUT:
%   darts ... 
%   surviving_indices ...
%   neighborhood ... the neighborhood. Currently only 4 is supported
% OUTPUT:
%   next_level ... the new combinatorial map which was contracted
% AUTHOR:
%   David Pfahler

switch nargin
    case 3
        % everything is fine
    case 2
       neighborhood = 4;
    otherwise
        error('Invalid number of arguments');
end
checkNeighborhood(neighborhood)

end