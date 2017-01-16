function [nl, finished] = contractionSimplification( nl, removal_canditates, DEBUG, neighborhood )
%contractCombinatorialMap contracts all edges in the combinatorial map
%INPUT:
%   nl ... the combinatorial map:
%   removal_canditates ... canditates for removal
%   DEBUG ... get debug output and additional checks (1 for yes, 0 for no)
%   neighborhood ... the neighborhood. Currently only 4 is supported
%OUTPUT:
%   next_level ... the new combinatorial map which was contracted
%   finished ... returns 1 if it is finished
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
REMOVE_SELF_DIRECT_LOOPS = 1;

%% contract all surviving darts

if DEBUG
    disp([num2str(length(removal_canditates)), ...
        ' canditates for removal']); 
end;

faceSpec = 'Face with %d darts = (';

finished = 0;

if isequal(sort(getOrbit(nl, nl.active(1), DEBUG)),sort(nl.active).')
    if DEBUG; disp('Remove cancled!'); end;
    finished = 1;
    return;
end

% check the number of indices for every face of the active darts
visited = false(nl.num_darts,1);
for face_dart = removal_canditates.'
    
    if visited(face_dart)
        continue;
    end
    
    face = getFace(nl, face_dart, DEBUG).';
    % every dart in this face is marked as visited (so we don't need to
    % compute it again!)
    visited(face) = 1;
    
    if DEBUG
        fprintf(faceSpec,length(face));
        fprintf('%d, ',face);
        fprintf(')\n');
    end
    
    if length(face) < 3
        %remove only the better matching dart of the face! which is the
        %first one because of the sorting of the remove canditates
        dart = face(1);
        inv_dart = nl.involution(dart);
        next_dart = nl.next(dart);
        next_inv = nl.next(inv_dart);
        prev_dart = nl.prev(dart);
        prev_inv = nl.prev(inv_dart);

        if DEBUG
            hexle = [dart; inv_dart; next_dart; next_inv; prev_dart; prev_inv];
            for h = 1:length(hexle)
                assert(any(hexle(h)==nl.active),['access to not active dart ',num2str(hexle(h))]);
            end
        end

        % self-direct-loop 1
        if next_dart == inv_dart
            if DEBUG; fprintf('Remove: self-direct-loop %d (-d = %d)\n', dart, inv_dart); end;
            if REMOVE_SELF_DIRECT_LOOPS
                nl.next(prev_dart) = next_inv;
                nl.prev(next_inv) = prev_dart;
            end

        % self-direct-loop 2
        elseif next_inv == dart
            if DEBUG; fprintf('Remove: self-direct-loop case 2 %d (-d = %d)\n', dart, inv_dart); end;
            if REMOVE_SELF_DIRECT_LOOPS
                nl.next(prev_inv) = next_dart;
                nl.prev(next_dart) = prev_inv;
            end

        % normal case
        else
            nl.next(prev_dart) = next_dart;
            nl.prev(next_dart) = prev_dart;
            
            if next_inv ~= inv_dart
                nl.next(prev_inv) = next_inv;
                nl.prev(next_inv) = prev_inv;
            elseif DEBUG
                 fprintf('Pending Edge removed!\n');
            end
            

            if DEBUG; fprintf('Remove: %d with -d = %d\n', dart, inv_dart); end;
        end

        %in this case the involution dart is visited because the dart is
        %removed
        visited(inv_dart) = 1;
        nl.active(nl.active==dart) = [];
        nl.active(nl.active==inv_dart) = [];
    end
end

% create the new active darts:
nl.num_active = length(nl.active);

end