% Computational Vision
% Practicum Face Recognition: Gender recognition
%
% Student name: Hugo Bertiche & Xavier Serra
%
% >> OBJECTIVE: 
% 1) Analize the code
% 2) Understand the function of each part of the code
% 3) Code the missing parts
% 4) Answer the pose questions
% 5) Execute the code 
% 6) Check the results and comment them in the report

% main function
function main_gender_recognition()

clc; close all; clear;
tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));

%% These sub-directories are required
addpath(genpath('feature_extraction'))
addpath(genpath('classification'))

%% Load database of images and analyze the structure
ARFace = importdata('ARFace.mat');

%% Prepare the data set samples identifying data and labels (male/female).
% We will use the internal faces loaded in the structure
display(ARFace)

% 1. To complete:
% Answer these questions: 
% a. Why the size of the field internal, size(ARFace.internal), is 1188 x
% 2210?
    % ANSWER: Because there are 2210 samples, each of them containing an image.
    % Each image consists of 36x33 pixels, which corresponds to 1188 pixels.
% b. Which is the information contained in ARFace.person?
    % ANSWER: It contains the identifier of the person corresponding to that sample
    % Concretely, there are 85 different samples


%% Count the number of samples and samples males and females of the data set.
% This information is in ARFace.gender ==> male == 1, female == 0
% 2. To complete:
NumberMales = sum(ARFace.gender);
NumberSamples = size(ARFace.gender,2);
NumberFemales = NumberSamples - NumberMales;

%% Visualize some of the internal faces and save in bmp images
% Use the function reshape to transform the information from a vector to a
% matrix.
% 3. To complete:
for i=1:10:NumberSamples
    image = ARFace.internal(:,i);
    image = reshape(image,ARFace.internalSz);
    imwrite(image,['Images/image_' num2str(i) '.jpg']);
end


%% Define the training set and test set from the data set using:
% a. Use the whole data set (an unbalanced problem)
% Build this data structure: 
%   images(:,i) is the image of sample i.
%   labels(i) is the label of sample i.
%   subjects(i) is the number of the subject of sample i.
% Use the "internal" images, we will reduce dimensionality later.

% 4. To complete:
images = ARFace.internal;
labels = ARFace.gender;
subjects = ARFace.person;
    
%% Atention! We will use the dataset in the representation: Sample x Variables (Samples x 1188):
images = images';
labels = labels';
subjects = subjects';

%% Decision over plotting
% Set this variable to true if you want the feature_extraction
% method (with 'PCA' and 'PCA95' options) to display both the 
% first 30 eigenfaces and the accumulated variance
plot_results = false;

%% Feature Extraction using PCA
mat_features_pca = feature_extraction('PCA', images, [], plot_results);


%% Feature Extraction using PCA (95% variance explained)
mat_features_pca95 = feature_extraction('PCA95', images, [], plot_results);


%% Feature Extraction using LDA
mat_features_lda = feature_extraction('LDA', images, labels);


%% Classification
% Call the function validation to perform the F-fold
% cross validation with: the samples, labels, information
% about the training set subjects and F the number of folds.
F = 10;
k = 3;
Rates_pca = validation(mat_features_pca', labels', subjects', F, k);
display(Rates_pca);
Rates_pca95 = validation(mat_features_pca95', labels', subjects', F, k);
display(Rates_pca95);
Rates_lda = validation(mat_features_lda', labels', subjects', F, k);
display(Rates_lda);

% 11. To complete:
% Answer this question: 
% Which is the best result?
    % ANSWER: The best result is clearly the one using 'lda'. Therefore,
    % for this particular case, we would rather use the LDA method
    % instead of the PCA one. Moreover, retaining 95% of the variance
    % has backfired regarding using only the best 5 dimensions. A possible
    % explanation for this is that, generally, simpler methods tend to
    % obtain better results and, therefore, using only 5 dimensions works
    % better than using 124.

end



