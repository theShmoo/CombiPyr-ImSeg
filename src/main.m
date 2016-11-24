%AUTHOR:
%   David Pfahler

%% reset
clear all;
close all;
rng('default')

%% image loading
[image_grayscale, width, height] = loadExampleImage(); 

%% compute the values of the graph
dart_values = computeDartValues(image_grayscale,1);

%% build the combinatorical map from image
darts = combinatorialMap(dart_values, width, height);

%% get the surviving indices
tic;
surviving_indices = computeSurvivors(darts);
toc;

%% get the next level
next_level = contractCombinatorialMap(darts, surviving_indices);

%% draw the map
drawCombinatorialMap(darts, width, height, mean_image_value);


