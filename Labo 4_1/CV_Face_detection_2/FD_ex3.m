% Computational Vision
% 2015-2016
% Students names: Hugo BERTICHE, Xavier SERRA
%
% >> OBJECTIVE:
% 1) Write the code for Exercise 3
% 2) Execute the code and check the results
% 3) Comment the experiments and results in a report

% main
function [frames, hasFace] = FD_ex3()

% Load video file and face detector
filename = 'Black_or_White_face_Morphing.mp4';
video = VideoReader(filename);
detector = vision.CascadeObjectDetector;

% Read & process video frames
tic;
for i = 1:video.NumberOfFrames
    frames(:,:,:,i) = read(video,i); % This function 'read' might need to be replaced with 'readFrame' in newer MatLab versions
    bbox = step(detector,frames(:,:,:,i));
    frames(:,:,:,i) = insertObjectAnnotation(frames(:,:,:,i),'rectangle',bbox,'Face');
    hasFace(i) = size(bbox,1) > 0;
    % As computational time is long, we output its progress and remaining
    % time
    time = datestr((video.NumberOfFrames - i)/(86400*i/toc),'MM:SS');
    disp(['Progress: ', num2str(100*i/video.NumberOfFrames), '%']);
    disp(['Remaining time: ', time, 's']);
end
end















