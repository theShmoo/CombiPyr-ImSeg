%COPYRIGHT:
%   David Pfahler 2017
%PROJECT:
%   CombPyr_ImSeg

%% reset
clc;
clearvars;
close all;
rng('default')

%% image loading
image = loadTestData(9,0);

%% build the combinatorical pyramid
cp = buildCombinatoricalPyramid(image, 1);

%% draw only first level
figure;
drawActiveDarts(cp.levels{end-1},[],image);

%% draw the pyramid
numLevels = length(cp.levels);
figure;
for level = 1:numLevels
    subplot(numLevels,1,level);
    drawActiveDarts(cp.levels{level},[],image);
    title(['level ', num2str(level)]);
end