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

%% contract all surviving darts

faceSpec = 'Face with %d darts = (';

% check the number of indices for every face of the active darts
visited = false(nl.num_darts,1);
for dart = nl.active.'
    if visited(dart)
        continue;
    end
    
    face = getFace(nl,dart).';
    % every dart in this face is marked as visited (so we don't need to
    % compute it again!)
    visited(face) = 1;
    
    if DEBUG_FACES
        fprintf(faceSpec,length(face));
        fprintf('%d, ',face);
        fprintf(')\n');
    end
    
    if length(face) == 2
        inv_face = nl.involution(face);
        %remove the darts of the face!
        for i = 1:length(face)
            face_dart = face(i);
            inv_dart = inv_face(i);
            removeDart(face_dart, inv_dart);
        end
        
        %in this case the involution face is visited because the dart is
        %removed
        visited(inv_face) = 1; 
        
    elseif length(face) == 1
        disp('self-direct-loop while removing!');
        
        inv_dart = nl.involution(face);
        n_dart = nl.next(face);
        n_inv = nl.next(inv_dart);
        p_dart = nl.prev(face);
        p_inv = nl.prev(inv_dart);
        
        hexle = [dart; inv_dart; n_dart; p_dart; p_inv];
        for h = 1:length(hexle)
            assert(any(hexle(h)==nl.active),['access to not active dart ',num2str(hexle(h))]);
        end
        
        assert(face == n_inv, 'otherwise the face needs more darts');
        
        nl.next(p_dart) = n_dart;

        nl.active(nl.active == face) = [];
    end
end

% create the new active darts:
nl.num_active = length(nl.active);

function [] = removeDart(dart, inv_dart)

    next_dart = nl.next(dart);
    next_inv = nl.next(inv_dart);
    prev_dart = nl.prev(dart);
    prev_inv = nl.prev(inv_dart);
    remove_from_active = [];
    hexle = [dart; inv_dart; next_dart; prev_dart; prev_inv];
    for h = 1:length(hexle)
        assert(any(hexle(h)==nl.active),['access to not active dart ',num2str(hexle(h))]);
    end
    % but only if not bridge, pending edge or self direct loop 
    if next_inv == inv_dart
        % pending edge
        fprintf('Pending edge %d while removing! (-d = %d)\n', dart, inv_dart );
        % nl.next(prev_dart) = next_dart;
        % set the previous darts.
        % nl.prev(next_dart) = prev_dart;
        
        % remove_from_active = [dart; inv_dart];
    elseif next_dart == dart
        % pending edge
        fprintf('Strange Pending edge %d while removing! (-d = %d)\n', dart, inv_dart );
    elseif next_dart == inv_dart
        % self-direct-loop
        % disp('self-direct-loop while removing!');
        fprintf('self-direct-loop %d while removing! (-d = %d)\n', dart, inv_dart );
        % nl.next(prev_dart) = next_inv;
        % set the previous darts.
        % nl.prev(next_dart) = prev_dart;      
        % nl.prev(next_inv) = prev_inv;
    % else a self loop can be treated as regular removal!
    else
        nl.next(prev_dart) = next_dart;
        nl.next(prev_inv) = next_inv;
        % set the previous darts.
        nl.prev(next_dart) = prev_dart;      
        nl.prev(next_inv) = prev_inv; 
        
        
        fprintf('Removed %d with -d = %d\n', dart, inv_dart);
        
        remove_from_active = [dart; inv_dart];
    end
    
    nl.active = setdiff(nl.active,remove_from_active);
end

end