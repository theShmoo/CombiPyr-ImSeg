function [orbit] = getOrbit( cm, ids)
%GETORBIT get the orbit of one index or multiple indices
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
%       cm.num_darts (1 x 1 uint32) 
%           contains the number of darts in the map
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
    %while ~any(next_dart==orbit)
    while next_dart ~= id
       orbit(end+1) = next_dart;
       next_dart = cm.next(next_dart);
    end
end