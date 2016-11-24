function [survivors] = computeSurvivors( darts, neighborhood )
%COMPUTESURVIVORS computes the survivers of the combinatorial map for the
%next pyramid level
% INPUT:
%   darts ... the values which the darts should contain
%   neighborhood ... the neighborhood. Currently only 4 is supported
% AUTHOR:
%   David Pfahler

switch nargin
    case 2
        % everything is fine
    case 1
       neighborhood = 4;
    otherwise
        error('Invalid number of arguments');
end
checkNeighborhood(neighborhood)

% number of edges    
num_darts = size(darts,1);      
% logical edge index; 1 for the edges that will be survivors
l_survivors = false(num_darts,2); 
                                  
% Sort edges w.r.t. weight
[~,idx] = sort(abs(darts(:,1)),1,'descend');
%sorted_darts = darts(idx,:);

% now select survivors from the darts
for dart = idx.'
    if l_survivors(dart,2)
        continue;
    end
    involution = darts(dart,2);
    l_survivors(dart,2) = 1;
    l_survivors(involution,2) = 1;
    next_dart = darts(dart,3);
    while next_dart ~= dart && ~l_survivors(next_dart,1)
       l_survivors(next_dart,2) = 1;
       next_dart = darts(next_dart,3);
    end

    next_involution = darts(involution,3);
    while next_involution ~= involution && ~l_survivors(next_involution, 1)
       l_survivors(next_involution, 2) = 1;
       next_involution = darts(next_involution,3);
    end

    l_survivors(dart,1) = next_dart == dart && next_involution == involution;
end

survivors = find(l_survivors(:,1));
end





