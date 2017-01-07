%COPYRIGHT:
%   David Pfahler 2016
%PROJECT:
%   CombPyr_ImSeg

%% reset
clc;
clearvars;
close all;
rng('default')

%% image loading
image = loadTestData(2,0);

%% build the combinatorical pyramid
cp = buildCombinatoricalPyramid(image);

%% draw the image for every layer
for level = cp.levels
   drawImageForPyramidLevel(image, level);
end
