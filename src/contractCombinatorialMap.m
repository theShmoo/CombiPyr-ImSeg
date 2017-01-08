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
%       cm.num_active (1 x 1 uint32)
%           contains the number of active darts in the map
%       cm.active (num_active x 1) the active darts in the map
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

% Contract the contraction kernels at the time

for i = 1:length(contract_indices)
    dart = contract_indices(i);
    inv_dart = contract_involution(i);
    contractDart(dart,inv_dart);
end

%finalize the new level:
nl.num_active = length(nl.active);
nl.level = cm.level + 1;

real_contracted = setdiff(contract_involution, nl.active);

% change the x,y positions of the next level (debug)
for dart = real_contracted.'
    dart_orbit = cm.involution(getOrbit(cm,dart));
    nl.x(dart_orbit) = cm.x(dart);
    nl.y(dart_orbit) = cm.y(dart);
end

    function [] = contractDart(dart,inv_dart)        
        next_dart = nl.next(dart);
        next_inv = nl.next(inv_dart);
        prev_dart = nl.prev(dart);
        prev_inv = nl.prev(inv_dart);
        hexle = [dart; inv_dart; next_dart; prev_dart; prev_inv];
        for h = 1:length(hexle)
            assert(any(hexle(h)==nl.active),['access to not active dart ',num2str(hexle(h))]);
        end
        
        remove_from_active = [];
        
        % pending edge 1
        if next_inv == inv_dart
            fprintf('Contract: Pending edge %d (-d = %d)\n', dart, inv_dart );
            
            nl.next(prev_dart) = next_dart;
            % set the previous darts.
            nl.prev(next_dart) = prev_dart;
            remove_from_active = [dart; inv_dart];
            
        % pending edge 2
        elseif next_dart == dart    
            fprintf('Contract: Pending edge case 2 %d (-d = %d)\n', dart, inv_dart );
            
            nl.next(prev_inv) = next_inv;
             % set the previous darts.
            nl.prev(next_inv) = prev_inv;
            remove_from_active = [dart; inv_dart];
            
        % self-direct-loop 1
        elseif next_dart == inv_dart
            
            fprintf('Contract: self-direct-loop %d (-d = %d)\n', dart, inv_dart);
            nl.next(prev_dart) = next_inv;
            
            remove_from_active = dart;
            
       % self-loop
%      elseif isequal(sort(getOrbit(nl, dart)), sort(getOrbit(nl, inv_dart)))
%             
%          fprintf('self-loop %d while contracting! (-d = %d)\n', dart, inv_dart);

        % self-direct-loop 2
        elseif next_inv == dart
            
            fprintf('Contract: self-direct-loop case 2 %d (-d = %d)\n', dart, inv_dart);
            nl.next(prev_inv) = next_dart;
            
            remove_from_active = dart;
            
        % normal contracting:
        else
            nl.next(prev_dart) = next_inv;
            nl.next(prev_inv) = next_dart;
            % set the previous darts.
            nl.prev(next_dart) = prev_inv;
            nl.prev(next_inv) = prev_dart;
            
            fprintf('Contract: %d (-d = %d)\n', dart, inv_dart);
            
            remove_from_active = [dart; inv_dart];
        end
        
        nl.active = setdiff(nl.active,remove_from_active);
    end

end