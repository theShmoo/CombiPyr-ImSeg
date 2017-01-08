function [nl] = contractCombinatorialMap( cm, neighborhood )
%contractCombinatorialMap contracts all edges in the combinatorial map
%INPUT:
%   cm ... the combinatorial map:
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

% build the next level by copy the old
nl = cm;
nl.level = cm.level + 1;

removed_darts = [];
contracted_darts = [];

% logical edge indices
visited = false(nl.num_darts,1);

% Sort the active edges w.r.t. weight
darts = sortrows([cm.sorted_idx_values(nl.active).',nl.active]);

% now select survivors from the active darts
for dart = darts(:,2).'
    % skip already visited darts
    if visited(dart)
        continue;
    end
    
    % create the hexle of the dart:
    inv_dart = nl.involution(dart);
    next_dart = nl.next(dart);
    next_inv = nl.next(inv_dart);
    prev_dart = nl.prev(dart);
    prev_inv = nl.prev(inv_dart);
    
%     if next_inv == dart
%         disp('self-direct-loop while removing!');
%         nl.next(prev_dart) = next_inv;
%         removed_darts = [removed_darts dart];
%         removed = 1;
%     else
    nin_dart = cm.next(cm.involution(next_dart));
    if nin_dart == dart
        % a 2 face detected! remove it!
        disp('a 2 face detected! remove it!');
        removeDart(dart,inv_dart,next_dart,next_inv,prev_dart,prev_inv);
        removeDart(next_inv);
    else
        contractDart(dart,inv_dart,next_dart,next_inv,prev_dart,prev_inv);
    end
    
end  

% create the new active darts:
nl.active = setdiff(nl.active, [removed_darts; contracted_darts]);
nl.num_active = length(nl.active);

% change the x,y positions of the next level (debug)
contract_involution = nl.involution(contracted_darts);
for dart = contract_involution.'
    dart_orbit = cm.involution(getOrbit(cm,dart));
    nl.x(dart_orbit) = cm.x(dart);
    nl.y(dart_orbit) = cm.y(dart);
end

    function [] = removeDart(dart,inv_dart,next_dart,next_inv,prev_dart,prev_inv)
        
        switch nargin
            case 6
                % everything is fine
            case 1
                % create the heple of the dart:
                inv_dart = nl.involution(dart);
                next_dart = nl.next(dart);
                next_inv = nl.next(inv_dart);
                prev_dart = nl.prev(dart);
                prev_inv = nl.prev(inv_dart);
            otherwise
                error('Invalid number of arguments');
        end
        
        % but only if not bridge, pending edge or self direct loop 
        if next_inv == inv_dart
            % pending edge
            disp('pending edge while removing!');
           
        elseif next_dart == inv_dart
            % self-direct-loop
            disp('self-direct-loop while removing');
            
        elseif next_inv == dart
            % self-direct-loop
            disp('strange!!');
        % else a self loop can be treated as regular removal!
        else
            nl.next(prev_dart) = next_dart;
            nl.next(prev_inv) = next_inv;
            % set the previous darts.
            nl.prev(next_dart) = prev_dart;      
            nl.prev(next_inv) = prev_inv; 
        end
        
        removed_darts = [removed_darts dart inv_dart];
        visited([dart inv_dart]) = 1;
    end

    function [] = contractDart(dart,inv_dart,next_dart,next_inv,prev_dart,prev_inv)
        
        switch nargin
            case 6
                % everything is fine
            case 1
                % create the heple of the dart:
                inv_dart = nl.involution(dart);
                next_dart = nl.next(dart);
                next_inv = nl.next(inv_dart);
                prev_dart = nl.prev(dart);
                prev_inv = nl.prev(inv_dart);
            otherwise
                error('Invalid number of arguments');
        end

        % contract only if not pending edge or self-loop
        if next_inv == inv_dart
            % pending edge
            disp('pending edge while contracting!');
            
        elseif isequal(getOrbit(nl,dart),getOrbit(nl,inv_dart))
            % self-loop
            disp('self-loop while contracting!');
        elseif next_dart == inv_dart
            % self-direct-loop
        else
            % normal contracting:
            nl.next(prev_dart) = next_inv;
            nl.next(prev_inv) = next_dart;
            % set the previous darts.
            nl.prev(next_dart) = prev_inv;
            nl.prev(next_inv) = prev_dart;
            
            contracted_darts = [contracted_darts dart inv_dart];
            visited([dart inv_dart]) = 1;
        end
        
    end

end