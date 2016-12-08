function [ dart_values ] = computeDartValues( image_grayscale, get_differences, neighborhood, plot_images )
%COMPUTEDARTVALUES computes the differences to the neighborhood of the
%image.
%INPUT:
%   image_grayscale ... the grayscale input image 
%   get_differences ... compute the differences if this is 1 otherwise just
%   set the grayvalues (default: 1)
%   neighborhood ... the neighborhood. Currently only 4 is supported
%   (default: 4)
%   plot_images ... 1 to plot the created darts 0 to hide (default: 0)
%OUTPUT:
%   dart_values ... the dart values for every neighbor as struct array (N, S,
%   W, E)
%COPYRIGHT:
%   David Pfahler 2016
%PROJECT:
%   CombPyr_ImSeg

% check number of input arguments and set default values
switch nargin
    case 4
        % everything is fine
    case 3
        plot_images = 0;
    case 2
        neighborhood = 4;
        plot_images = 0;
    case 1
        get_differences = 1;
        neighborhood = 4;
        plot_images = 0;
    otherwise
        error('Invalid number of arguments');
end
assertNeighborhood(neighborhood);

% get the width and height of the image
[width, height] = size(image_grayscale);

if width < 2 || height < 2
    error('Too small image');
end

% compute in double to be able to look at negative values
d_image_grayscale = double(image_grayscale);

if get_differences
    % North edges differences
    N = d_image_grayscale(1:end-1,:)-d_image_grayscale(2:end,:);
    % South edges differences
    S = d_image_grayscale(2:end,:)-d_image_grayscale(1:end-1,:);
    % West edges differences
    W = d_image_grayscale(:,1:end-1)-d_image_grayscale(:,2:end);
    % East edges differences
    E = d_image_grayscale(:,2:end)-d_image_grayscale(:,1:end-1);
    
    % convert to int16
    % int8 is sadly to small
    N = int16(N);
    S = int16(S);
    W = int16(W);
    E = int16(E);
    
    % if we use the difference structure representation we dont need the
    % negative values. Because the involution gives us the information we
    % need!
    % and we remove the negatives and replace them with a nan values
    
%     N(N < 0) = NaN;
%     S(S < 0) = NaN;
%     W(W < 0) = NaN;
%     E(E < 0) = NaN;
    
    % and because a grayscale image has 255 values we can now save the
    % difference value in a uint8 (0-255)! yai
    
%     N = uint8(N);
%     S = uint8(S);
%     W = uint8(W);
%     E = uint8(E);

    % this is not done here but at the reduce darts function to stay
    % consistent.
     
else
    N = d_image_grayscale(1:end-1,:);
    S = d_image_grayscale(2:end,:);
    W = d_image_grayscale(:,1:end-1);
    E = d_image_grayscale(:,2:end);
end

%% Plot the edges in all directions
if plot_images
    plotn = 1;
    subplot(2,2,plotn)
    plotn = plotn + 1;
    imshow(N,[]);
    title('N')
    subplot(2,2,plotn)
    plotn = plotn + 1;
    imshow(S,[]);
    title('S')
    subplot(2,2,plotn)
    plotn = plotn + 1;
    imshow(W,[]);
    title('W')
    subplot(2,2,plotn)
    imshow(E,[]);
    title('E')
end

%% save it to the struct
dart_values = struct('N', N, 'E', E, 'W', W, 'S', S);
end

