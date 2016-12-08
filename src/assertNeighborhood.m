function assertNeighborhood( neighborhood )
%ASSERTNEIGHBORHOOD check if the neighborhood is supported
%next pyramid level
%INPUT:
%   neighborhood ... the neighborhood. Currently only 4 is supported
%COPYRIGHT:
%   David Pfahler 2016
%PROJECT:
%   CombPyr_ImSeg

if nargin ~= 1
    error('Invalid number of arguments');
end

if neighborhood ~= 4
    error('Invalid Neighborhood defined');
end

end