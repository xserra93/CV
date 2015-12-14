close all
clear all

tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));

testFilters();



%% getFeatures()
class = 'forest';
image = '13';
filename = strcat('../texturesimages/',class,'/',class,'_',image,'.jpg');
im = imread(filename);
figure;
imshow(im);

% This variable is used to plot the filters applied to the image
%   - 0: not plotted
%   - 1: plotted
use_plot = 1;
feature_vector = getFeatures(im, use_plot);


%% Retrieve similar images

% Only texture descriptors
figure('name','Only features from textures');
retrieveKImages(im,9,'textures');

% Only color descriptors
figure('name','Only features from colors');
retrieveKImages(im,9,'colors');

% Texture and color descriptors
figure('name','Both kinds of features');
retrieveKImages(im,9,'both');