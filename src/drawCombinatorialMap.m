function drawCombinatorialMap( dart_values, width, height, image_mean, neighborhood )
%COMBINATORIALMAP draws an image from a combinatorial map
% INPUT:
%   dart_values ... the values which the darts should contain
%   width ... the with of the image
%   height ... the height of the image
%   image_mean ... the mean grayvalue of the image
%   neighborhood ... the neighborhood. Currently only 4 is supported
% AUTHOR:
%   David Pfahler

switch nargin
    case 5
        % everything is fine
    case 4
       neighborhood = 4;
    otherwise
        error('Invalid number of arguments');
end
checkNeighborhood(neighborhood);

dart_indices = getDartIndices(width,height);

values = image_mean + reshape(dart_values(dart_indices{4},1),height,width-1);

figure;
imshow(values,[]);
title('Reconstructed Image');

end