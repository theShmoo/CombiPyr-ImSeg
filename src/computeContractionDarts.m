function [survivors] = computeContractionDarts( cm, neighborhood )
%COMPUTECONTRACTIONDARTS computes the contraction kernels of the
%combinatorial map for the next pyramid level 
%INPUT:
%   cm ... the combinatorial map
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

% logical edge indices
% survivors is 2 for the darts that will be survivors
% survivors is 1 for the darts that can't become survivors (and are
% therefore skipped)
survivors = uint8(zeros(length(cm.values), 1));
                                  
% Sort the active edges w.r.t. weight
darts = sortrows([cm.sorted_idx_values(cm.active).', cm.active]);

% now select survivors from the active darts
for dart = darts(:,2).'
    
    % if the dart is already marked as part of the survivors or marked as
    % invalid kick it off
    if survivors(dart) > 0
        continue;
    end
    
    % get the indices of the darts of the orbits that are untouched
    %surviving_darts = dart_orbit(survivors(dart_orbit)==0);
    % set all untouched darts to survivors
    %survivors(surviving_darts) = 2;
    survivors(dart) = 2;
    
    % get the orbit of the dart
    dart_orbit = getOrbit(cm,dart);
    % set the involution of the orbit to invalid
    dart_orbit_inv = cm.involution(dart_orbit);
    assert(all(survivors(dart_orbit_inv) ~= 2),'contraction kernel creation error!');
    survivors(dart_orbit_inv) = 1;
    
    % get the orbit of the involution dart of the new survivor
    involution_orbit = getOrbit(cm, cm.involution(dart));
    assert(all(survivors(involution_orbit) ~= 2),'contraction kernel creation error!');
    % and set all of them to invalid
    survivors(involution_orbit) = 1;
    
    % additionally set the involutions of the involution orbit to invalid!
    y = setdiff(cm.involution(involution_orbit), dart);
    assert(all(survivors(y) ~= 2),'contraction kernel creation error!');
    survivors(y) = 1;
end

survivors = uint32(find(survivors == 2));
end





