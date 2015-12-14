tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));

run('vlfeat-0.9.16/toolbox/vl_setup');


%% Question 1

I = vl_impattern('roofs1');
I = single(rgb2gray(I));
imshow(I);
[f,d] = vl_sift(I);

show_keypoints(I,f);

show_keypoints(I,random_selection(f,50));


%% Question 2

[f,d] = vl_sift(I,'PeakThresh', 0.01);
show_keypoints(I,f);


%% Question 3

[f,d] = vl_sift(I,'PeakThresh', 0.04, 'EdgeThresh', 10);
show_keypoints(I,f);
