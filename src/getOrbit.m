function [orbit] = getOrbit( cm, ids, DEBUG)
%GETORBIT get the orbit of one index or multiple indices
%INPUT:
%   cm ... the combinatorial map
%   ids ... (num_ids x 1 uint32) the indices of which the orbit has to be
%       obtained 
%OUTPUT:
%   orbit ... (num_ids x num_elements) the orbit from the input indices
%COPYRIGHT:
%   David Pfahler 2016
%PROJECT:
%   CombPyr_ImSeg

orbit = ids';
% initialize the orbit with only the id of the current dart
for id = ids'
    % iterate over the orbit until you find the starting dart and save all
    % found darts in the orbit
    next_dart = cm.next(id);
    while next_dart ~= id
       if DEBUG; assert(~any(next_dart==orbit),['loop insinde getOrbit with orbit: ',num2str(orbit), ' and dart ', num2str(next_dart)]); end;
       orbit(end+1) = next_dart; %#ok<AGROW>
       next_dart = cm.next(next_dart);
       if DEBUG; assert(any(next_dart==cm.active),['access to not active dart ',num2str(next_dart)]); end;
    end
end