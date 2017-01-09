function [face] = getFace(cm, dart, DEBUG)
%GETFACE get all darts of one face of the combinatorial map
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
%   face ... (num_elements x 1) the face from the input dart
%COPYRIGHT:
%   David Pfahler 2016
%PROJECT:
%   CombPyr_ImSeg

face = dart;
% initialize the face with only the id of the current dart

% iterate over the face until you find the starting dart and save all
% found darts in the face
next_dart = cm.next(cm.involution(dart));
%while ~any(next_dart==face)
while next_dart ~= dart 
   if DEBUG; assert(~any(next_dart==face),['loop insinde getFace with face: ',num2str(face), ' and dart ', num2str(next_dart)]); end;
   face(end+1) = next_dart;
   next_dart = cm.next(cm.involution(next_dart));   
   if DEBUG; assert(any(next_dart==cm.active),['access to not active dart',num2str(next_dart)]); end;
end