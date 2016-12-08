function [survivors] = computeSurvivors( cm, neighborhood )
%COMPUTESURVIVORS computes the survivers of the combinatorial map for the
%next pyramid level
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
%   neighborhood ... the neighborhood. Currently only 4 is supported
%OUTPUT:
%   survivors ... the surviving darts of the combinatorial map
%COPYRIGHT:
%   David Pfahler 2016
%PROJECT:
%   CombPyr_ImSeg

switch nargin
    case 2
        % everything is fine
    case 1
       neighborhood = 4;
    otherwise
        error('Invalid number of arguments');
end
assertNeighborhood(neighborhood)

% logical edge index; 
% first row is 1 for the darts that will be survivors
% second row is 1 for darts that can't become survivors (and are therefore
% skipped)
l_survivors = false(cm.num_darts,2);
                                  
% Sort edges w.r.t. weight
[~,idx] = sort(cm.values,1,'descend');
%sorted_darts = darts(idx,:);

% now select survivors from the darts
for dart = idx.'
    % if the dart is already marked as part of the survivors kick it off
    if l_survivors(dart,2)
        continue;
    end
    % get the involution and the next dart of the dart
    involution = cm.involution(dart);
    next_dart = cm.next(dart);
    
    l_survivors(dart,2) = 1;
    l_survivors(involution,2) = 1;

    while next_dart ~= dart && ~l_survivors(next_dart,1)
       l_survivors(next_dart,2) = 1;
       next_dart = cm.next(next_dart);
    end

    next_involution = cm.next(involution);
    while next_involution ~= involution && ~l_survivors(next_involution, 1)
       l_survivors(next_involution, 2) = 1;
       next_involution = cm.next(next_involution);
    end

    l_survivors(dart,1) = next_dart == dart && next_involution == involution;
end

survivors = uint32(find(l_survivors(:,1)));
end





