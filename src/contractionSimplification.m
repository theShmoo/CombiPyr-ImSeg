function [nl] = contractionSimplification( nl, neighborhood )
%contractCombinatorialMap contracts all edges in the combinatorial map
%INPUT:
%   nl ... the combinatorial map:
%   neighborhood ... the neighborhood. Currently only 4 is supported
%OUTPUT:
%   next_level ... the new combinatorial map which was contracted
%AUTHOR:
%   David Pfahler

switch nargin
    case 2
        % everything is fine
    case 1
       neighborhood = 4;
    otherwise
        error('Invalid number of arguments');
end
assertNeighborhood(neighborhood)
DEBUG_FACES = 1;
REMOVE_SELF_LOOPS = 0;
REMOVE_SELF_DIRECT_LOOPS = 1;
REMOVE_PENDING_EDGES = 1;

%% contract all surviving darts

faceSpec = 'Face with %d darts = (';

% check the number of indices for every face of the active darts
visited = false(nl.num_darts,1);
for face_dart = nl.active.'
    if visited(face_dart)
        continue;
    end
    
    face = getFace(nl,face_dart).';
    % every dart in this face is marked as visited (so we don't need to
    % compute it again!)
    visited(face) = 1;
    
    if DEBUG_FACES
        fprintf(faceSpec,length(face));
        fprintf('%d, ',face);
        fprintf(')\n');
    end
    
    if length(face) < 3
        %remove only the first dart of the face!
        dart = face(1);
        removeDart(dart);
    end
end

% create the new active darts:
nl.num_active = length(nl.active);

function [] = removeDart(dart)

    inv_dart = nl.involution(dart);
    next_dart = nl.next(dart);
    next_inv = nl.next(inv_dart);
    prev_dart = nl.prev(dart);
    prev_inv = nl.prev(inv_dart);
    remove_from_active = []; %#ok<*NASGU>
    hexle = [dart; inv_dart; next_dart; prev_dart; prev_inv];
    for h = 1:length(hexle)
        assert(any(hexle(h)==nl.active),['access to not active dart ',num2str(hexle(h))]);
    end
    
    o = sort(getOrbit(nl, dart));
    i_o = sort(getOrbit(nl, inv_dart));
    if isequal(o, i_o)
        % self loop! -> don't delete! this is important :D
        disp(['Remove: self loop detected: ', num2str(o)]);
        
        if REMOVE_SELF_LOOPS
            nl.next(prev_dart) = next_dart;
            nl.next(prev_inv) = next_inv;
            % set the previous darts.
            nl.prev(next_dart) = prev_dart;      
            nl.prev(next_inv) = prev_inv;

            remove_from_active = [dart; inv_dart];
        end
    % pending edge 1
    elseif next_inv == inv_dart
        fprintf('Remove: Pending edge %d (-d = %d)\n', dart, inv_dart );
        if REMOVE_PENDING_EDGES
            nl.next(prev_dart) = next_dart;
            % set the previous darts.
            nl.prev(next_dart) = prev_dart;
            remove_from_active = [dart; inv_dart];
        end

    % pending edge 2
    elseif next_dart == dart    
        fprintf('Remove: Pending edge case 2 %d (-d = %d)\n', dart, inv_dart );
        if REMOVE_PENDING_EDGES
            nl.next(prev_inv) = next_inv;
             % set the previous darts.
            nl.prev(next_inv) = prev_inv;
            remove_from_active = [dart; inv_dart];
        end

    % self-direct-loop 1
    elseif next_dart == inv_dart

        fprintf('Remove: self-direct-loop %d (-d = %d)\n', dart, inv_dart);
        if REMOVE_SELF_DIRECT_LOOPS
            nl.next(prev_dart) = next_inv;
            
            remove_from_active = dart;
        end
        
    % self-direct-loop 2
    elseif next_inv == dart
        
        fprintf('Remove: self-direct-loop case 2 %d (-d = %d)\n', dart, inv_dart);
        if REMOVE_SELF_DIRECT_LOOPS
            nl.next(prev_inv) = next_dart;
            
            remove_from_active = dart;
        end
    else
        nl.next(prev_dart) = next_dart;
        nl.next(prev_inv) = next_inv;
        % set the previous darts.
        nl.prev(next_dart) = prev_dart;      
        nl.prev(next_inv) = prev_inv; 


        fprintf('Remove: %d with -d = %d\n', dart, inv_dart);

        remove_from_active = [dart; inv_dart];
    end
    
    %in this case the involution face is visited because the dart is
    %removed
    visited(remove_from_active) = 1;
    nl.active = setdiff(nl.active,remove_from_active);
end

end