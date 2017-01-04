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

% create the new active darts:
nl.active = setdiff(nl.active, [contract_indices; contract_involution]);
nl.num_active = length(nl.active);

% Contract the contraction kernels at the time

for i = 1:length(contract_indices)
    dart = contract_indices(i);
    inv_dart = contract_involution(i);
    next_dart = nl.next(dart);
    next_inv = nl.next(inv_dart);
    prev_dart = nl.prev(dart);
    prev_inv = nl.prev(inv_dart);

    % contracting:
    nl.next(prev_dart) = next_inv;
    nl.next(prev_inv) = next_dart;
    % set the previous dart.
    nl.prev(next_dart) = prev_inv;
end


faceSpec= 'Face with %d darts = (';

% check the number of indices for every face of the active darts
visited = false(nl.num_darts,1);
removed_darts = [];
for dart = nl.active.'
    if visited(dart)
        continue;
    end
    face = getFace(nl,dart).';
    inv_face = nl.involution(face);
    visited(face) = 1;
    visited(inv_face) = 1;
    % logging
    fprintf(faceSpec,length(face));
    fprintf('%d, ',face);
    fprintf(')\n');
    % /logging
    if length(face) < 3
        %remove the darts of the face!
        for i = 1:length(face)
            face_dart = face(i);
            inv_dart = inv_face(i);
            next_dart = nl.next(face_dart);
            prev_dart = nl.prev(face_dart);
            nl.next(prev_dart) = next_dart;
            nl.next(nl.prev(inv_dart)) = nl.next(inv_dart);
            % set the previous dart.
            nl.prev(next_dart) = prev_dart;
        end
        removed_darts = [removed_darts; face; inv_face];
    end
end

% create the new active darts:
nl.active = setdiff(nl.active, removed_darts);
nl.num_active = length(nl.active);

% change the x,y positions of the next level (debug)
for dart = contract_involution.'
    dart_orbit = cm.involution(getOrbit(cm,dart));
    nl.x(dart_orbit) = cm.x(dart);
    nl.y(dart_orbit) = cm.y(dart);
end

end