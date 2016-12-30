%COPYRIGHT:
%   David Pfahler 2016
%PROJECT:
%   CombPyr_ImSeg

%% reset
clear all;
close all;
rng('default')

%% image loading
%image = loadExampleImage(); 
image = loadTestData(2,0);

%% build the combinatorical pyramid
cp = buildCombinatoricalPyramid(image);

