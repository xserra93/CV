% Computational Vision
% Practicum Face Recognition: Subject recognition
%
% Student name: ...
%
% >> OBJECTIVE: 
% 1)Complete this function to solve the subject recognition problem

% main function
function main_subject_recognition(subject)
tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));

%% These sub-directories are required
addpath(genpath('feature_extraction'))
addpath(genpath('classification'))

%% Load database of images
ARFace = importdata('ARFace.mat');
if ~any(subject == ARFace.person)
    error('There is not such subject on provided data.');
end

%% Prepare the data set samples identifying data and labels.
display(ARFace)

images = ARFace.internal;
labels = ARFace.person == subject;
subjects = ARFace.person;
    
%% Atention! We will use the dataset in the representation: Sample x Variables (Samples x 1188):
images = images';
labels = labels';
subjects = subjects';

%% Decision over plotting

plot_results = true;

%% Feature Extraction using PCA
mat_features_pca = feature_extraction('PCA', images, [], plot_results);


%% Feature Extraction using PCA (95% variance explained)
mat_features_pca95 = feature_extraction('PCA95', images, [], plot_results);


%% Feature Extraction using LDA
mat_features_lda = feature_extraction('LDA', images, labels);


%% Classification

F = 10;
k = 3;
Rates_pca = validation(mat_features_pca', labels', subjects', F, k);
display(Rates_pca);
Rates_pca95 = validation(mat_features_pca95', labels', subjects', F, k);
display(Rates_pca95);
Rates_lda = validation(mat_features_lda', labels', subjects', F, k);
display(Rates_lda);
end



