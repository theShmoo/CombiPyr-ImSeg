function [survivors] = computeContractionDarts( cm, DEBUG, neighborhood )
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
    case 3
        % everything is fine
    case 2
        neighborhood = 4;
    case 1
        DEBUG = 0;
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

% now select survivors from the active darts
for dart = cm.active.'
    
    % if the dart is already marked as part of the survivors or marked as
    % invalid kick it off
    if survivors(dart) > 0
        continue;
    end
    
    % get the indices of the darts of the orbits that are untouched
    %surviving_darts = dart_orbit(survivors(dart_orbit)==0);
    % set all untouched darts to survivors
    %survivors(surviving_darts) = 2;
    
    inv_dart = cm.involution(dart);
    % get the orbit of the dart
    dart_orbit = getOrbit(cm, dart, DEBUG);
    % get the involution of the orbit (all darts that count to the node)
    dart_orbit_inv = cm.involution(dart_orbit);
    dart_orbit_inv(survivors(dart_orbit_inv) == 2) = [];
    % get the orbit of the involution
    involution_orbit = getOrbit(cm, inv_dart, DEBUG);
    % get the involutions of the involution orbit: (the original dart is in this set)
    involution_orbit_inv = cm.involution(involution_orbit);
    
    %check for self loop
    if isequal(sort(dart_orbit), sort(involution_orbit))
        if DEBUG; disp(['Contract: self loop detected: ', num2str(dart_orbit)]); end;
        % set them invalid
        survivors(dart_orbit) = 1;
        survivors(dart_orbit_inv) = 1;
        survivors(involution_orbit_inv) = 1;
        
    elseif length(dart_orbit) == 1 || length(involution_orbit) == 1
        if DEBUG; disp(['Contract: pending edge detected: ', num2str(dart_orbit)]); end;
        % set them invalid
        survivors(inv_dart) = 1;
        
    else
        % set them invalid
        survivors(involution_orbit_inv) = 1;
        survivors(dart_orbit_inv) = 1;
        % but the dart is a survivor!
        survivors(dart) = 2;
    end
end

survivors = uint32(find(survivors == 2));
end





