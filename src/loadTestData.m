function [ test_data, width, height ] = loadTestData( test_data_id, plot_image )
%LOADEXAMPLEIMAGE load an image 
%INPUT:
%   test_data_id ... the test data id (default: 0)
%                   0 ... a 5x5 magic image
%                   1 ... a 10x10 zero image
%                   2 ... a 4x6 random image (with values 0-255)
%                   3 ... a 3x3 random image (with values 0-255)
%                   4 ... a 255x255 test image
%   plot_image ... plot the test data (default: 0)
%OUTPUT:
%   test_data ... (width x height) the loaded example test data as image
%   width ... the width of the image
%   height ... the height of the image
%COPYRIGHT:
%   David Pfahler 2016
%PROJECT:
%   CombPyr_ImSeg

% check number of input arguments and set default values
switch nargin
    case 2
        % everything is fine
    case 1
        plot_image = 0;
    case 0
        test_data_id = 0;
        plot_image = 0;
    otherwise
        error('Invalid number of arguments');
end

rng('default');

switch test_data_id
    case 0
        test_data = magic(5,5);
    case 1
        test_data = zeros(10);
    case 2
        test_data = randi(255,4,6);
    case 3
        test_data = randi(255,3,3);
    case 4
        test_data = imread('cameraman.tif');
    otherwise
        error('invalid test data id');
end

if plot_image == 1
    figure;
    imshow(test_data,[]);
    title('Original Image');
end

% get the width and height of the image
[width, height] = size(test_data);

if width < 2 || height < 2
    error('Too small image');
end

end