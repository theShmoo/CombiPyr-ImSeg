function [ dart_values ] = computeDartValues( image_grayscale, get_differences, neighborhood, plot_images )
%COMPUTEDARTVALUES computes the differences to the neighborhood of the
%image.
%INPUT:
%   image_grayscale ... the grayscale input image 
%   get_differences ... compute the differences if this is 1 otherwise just
%   set the grayvalues
%   neighborhood ... the neighborhood. Currently only 4 is supported
%   (default: 4)
%   plot_images ... 1 to plot the created darts 0 to hide (default: 0)
%OUTPUT:
%   dart_values ... the dart values for every neighbor as cell array (N, S,
%   W, E) 
%AUTHOR:
%   David Pfahler

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
        get_differences = 0;
        neighborhood = 4;
        plot_images = 0;
    otherwise
        error('Invalid number of arguments');
end
checkNeighborhood(neighborhood);

% get the width and height of the image
[width, height] = size(image_grayscale);

if width < 2 || height < 2
    error('Too small image');
end

N = zeros(width,height-1);
S = zeros(width,height-1);
E = zeros(width-1,height);
W = zeros(width-1,height);

% compute in double to be able to look at negative values
d_image_grayscale = double(image_grayscale);

if get_differences
    dart_values = cell(neighborhood, 1);

    % North edges differences
    N = d_image_grayscale(1:end-1,:)-d_image_grayscale(2:end,:);
    % South edges differences
    S = d_image_grayscale(2:end,:)-d_image_grayscale(1:end-1,:);
    % West edges differences
    W = d_image_grayscale(:,1:end-1)-d_image_grayscale(:,2:end);
    % East edges differences
    E = d_image_grayscale(:,2:end)-d_image_grayscale(:,1:end-1);

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

%% save it to the return matrix
dart_values{1} = N(:);
dart_values{2} = S(:); 
dart_values{3} = W(:); 
dart_values{4} = E(:);
end

