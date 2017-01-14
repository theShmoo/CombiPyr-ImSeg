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
image = loadTestData(10,0);

%% build the combinatorical pyramid
cp = buildCombinatoricalPyramid(image, 1);