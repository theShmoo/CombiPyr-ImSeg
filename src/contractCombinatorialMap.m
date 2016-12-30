function [nl] = contractCombinatorialMap( cm, contract_indices, neighborhood )
%contractCombinatorialMap contracts all edges in the combinatorial map
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
%   contract_indices ... (n x 1) the indices that get contracted
%   neighborhood ... the neighborhood. Currently only 4 is supported
%OUTPUT:
%   next_level ... the new combinatorial map which was contracted
%AUTHOR:
%   David Pfahler

switch nargin
    case 3
        % everything is fine
    case 2
       neighborhood = 4;
    otherwise
        error('Invalid number of arguments');
end
assertNeighborhood(neighborhood)

%% contract all surviving darts

% involution of the contraction darts
contract_involution = cm.involution(contract_indices);

% build the next level by copy the old
nl = cm;

% create the new active darts:
nl.active = setdiff(nl.active, [contract_indices; contract_involution]);
nl.num_active = length(nl.active);

% contract
for i = 1:length(contract_indices)
    dart = contract_indices(i);
    involution = contract_involution(i);
    
    next_dart = nl.next(dart);
    next_inv = nl.next(involution);
    prev_dart = nl.prev(dart);
    prev_inv = nl.prev(involution);
    
    % todo: check for self loop or pending edge
    
    % contracting:
    nl.next(prev_dart) = next_inv;
    nl.next(prev_inv) = next_dart;
    % set the previous dart.
    nl.prev(next_dart) = prev_inv;
        
    % remove the next dart from the orbit
    if nl.prev(nl.involution(nl.prev(nl.involution(prev_dart)))) == involution
        inv_prev_dart = nl.involution(prev_dart);
        nl.next(nl.prev(prev_dart)) = nl.next(prev_dart);
        nl.next(nl.prev(inv_prev_dart)) = nl.next(prev_inv);
        % set the previous dart.
        nl.prev(prev_dart) = inv_prev_dart;
    end
    if nl.next(nl.involution(nl.next(nl.involution(next_dart)))) == involution
        inv_next_dart = nl.involution(next_dart);
        nl.next(nl.prev(next_dart)) = nl.next(next_dart);
        nl.next(nl.prev(inv_next_dart)) = nl.next(prev_inv);
        % set the previous dart.
        nl.prev(next_dart) = inv_next_dart;
    end
end
% remove duplicates

% for dart = contract_involution.'
%     % iterate over the orbit until you find the starting dart and save all
%     % found darts in the orbit
%     orbit = dart;
%     next_dart = next_level.next(dart);
%     while next_dart ~= dart
%        if(any(next_dart==orbit))
%            % remove the next dart from the orbit
%            involution_next_dart = next_level.involution(next_dart);
%            next_level.next(next_level.prev(next_dart)) = next_level.next(next_dart);
%            next_level.next(next_level.prev(involution_next_dart)) = next_level.next(involution_next_dart);
%        else
%            orbit(end+1) = next_dart;
%        end
%        next_dart = next_level.next(next_dart);
%     end
% end

% change the x,y positions of the next level (debug)
for dart = contract_involution.'
    dart_orbit = cm.involution(getOrbit(cm,dart));
    nl.x(dart_orbit) = cm.x(dart);
    nl.y(dart_orbit) = cm.y(dart);
end

end