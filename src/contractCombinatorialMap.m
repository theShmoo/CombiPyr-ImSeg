function [nl, removal_canditates] = contractCombinatorialMap( cm, contract_indices, DEBUG, neighborhood )
%contractCombinatorialMap contracts all edges in the combinatorial map
%INPUT:
%   cm ... the combinatorial map
%   contract_indices ... (n x 1) the indices that get contracted
%   neighborhood ... the neighborhood. Currently only 4 is supported
%OUTPUT:
%   next_level ... the new combinatorial map which was contracted
%   removal_canditates .... the indices of the canditates for removal
%AUTHOR:
%   David Pfahler

switch nargin
    case 4
        % everything is fine
    case 3
        neighborhood = 4;
    case 2
        DEBUG = 0;
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

%removal_canditates = [];

% Contract the contraction kernels at the time

for dart = contract_indices.'
    % get the hexel
    inv_dart = nl.involution(dart);
    next_dart = nl.next(dart);
    next_inv = nl.next(inv_dart);
    prev_dart = nl.prev(dart);
    prev_inv = nl.prev(inv_dart);
    
    nl.next(prev_dart) = next_inv;
    nl.next(prev_inv) = next_dart;
    % set the previous darts.
    nl.prev(next_dart) = prev_inv;
    nl.prev(next_inv) = prev_dart;
    
    % set the canditates for removal
    %removal_canditates = [removal_canditates; next_dart; next_inv; prev_dart; prev_inv]; %#ok<AGROW>
end

%finalize the new level:
% remove them from active darts
keep = true(1,max(nl.active));
keep([contract_indices; contract_involution]) = false;
nl.active = nl.active(keep(nl.active));
nl.num_active = length(nl.active);
nl.level = cm.level + 1;

% remove double added darts from the canditates
%removal_canditates = unique(removal_canditates);
% remove darts that were removed by contraction operations
%removal_canditates = intersect(nl.active, removal_canditates);
% sort the canditates w.r.t. the dart values
%[~,idx] = sort(abs(cm.values(removal_canditates)),1,'ascend');
%removal_canditates(idx);
removal_canditates = nl.active;

% change the x,y positions of the next level (debug)
for dart = contract_involution.'
    dart_orbit = cm.involution(getOrbit(cm,dart,DEBUG));
    nl.x(dart_orbit) = cm.x(dart);
    nl.y(dart_orbit) = cm.y(dart);
end
end