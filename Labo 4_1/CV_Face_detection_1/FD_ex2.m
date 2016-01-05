% Computational Vision
% 2015-2016
% Student name: ...
%
% >> OBJECTIVE: 
% 1) Write the code for Exercise 2
% 2) Execute the code and check the results
% 3) Comment the experiments and results in a report

% main function
function FD_ex2()
    clc; close all; clear;
    tmp = matlab.desktop.editor.getActive;
    cd(fileparts(tmp.Filename));


    %% Initialization
    % Define Viola & Jones parameters for the 6 feature masks
    % SEE THE ATTACHED IMAGE FOR DETAILS!!!
    L = 80;                             % mask size [px]
    d1 = 10; d2 = 15; d3 = 20; d4 = 10; % distances from the border
    d5 = 15; d6 = 15; d7 = 10; d8 = 20;
    d9 = 15;
    w1 = 50; w2 = 20; w3 = 20; w4 = 50;  % width of the rectangles
    w5 = 25; w6 = 15; w7 = 20;
    h1 = 10; h2 = 20; h3 = 10; h4 = 10;  % height of the rectangles
    h5 = 6; h6 = 10; h7 = 10; h8 = 12;
    


    %% Draw the 2 feature masks (just for visualization purpose)
    m1 = zeros(L,L);
    m2 = zeros(L,L);
    m3 = zeros(L,L);
    m4 = zeros(L,L);
    m5 = zeros(L,L);
    m6 = zeros(L,L);

    m1(d1+1:d1+h1,d2+1:d2+w1) = 1;
    m1(d1+1+h1:d1+2*h1,d2+1:d2+w1) = 2;

    m2(d3+1:d3+h2,d4+1:d4+w2) = 1;
    m2(d3+1:d3+h2,d4+w2+1:d4+w2+w3) = 2;
    m2(d3+1:d3+h2,d4+w2+w3+1:d4+2*w2+w3) = 1;

    m3(d5+1:d5+h3,d5+1:d5+w4) = 1;
    m3(d5+h3+1:d5+h3+h4,d5+1:d5+w4) = 2;
    m3(d5+h3+h4+1:d5+2*h3+h4,d5+1:d5+w4) = 1;

    m4(d6+1:d6+h5,d6+1:d6+w5) = 1;
    m4(d6+1:d6+h5,d6+w5+1:d6+2*w5) = 2;
    m4(d6+h5+1:d6+2*h5,d6+1:d6+w5) = 2;
    m4(d6+h5+1:d6+2*h5,d6+w5+1:d6+2*w5) = 1;

    m5(d7+1:d7+h6,d8+1:d8+w6) = 1;
    m5(d7+h6+1:d7+h6+h7,d8+1:d8+w6) = 2;
    m5(d7+h6+h7+1:d7+2*h6+h7,d8+1:d8+w6) = 1;
    
    m6(d9+1:d9+h8,d9+1:d9+w7)=1;
    m6(d9+1:d9+h8,d9+w7+1:d9+2*w7)=2;
    
    figure(1);
    subplot(3,2,1)
    imagesc(m1);
    title('Rectangular mask for feature 1');
    axis square;
    colormap([128 128 128; 0 0 0; 255 255 255]/255);

    subplot(3,2,2)
    imagesc(m2);
    title('Rectangular mask for feature 2');
    axis square;
    colormap([128 128 128; 0 0 0; 255 255 255]/255);

    subplot(3,2,3)
    imagesc(m3);
    title('Rectangular mask for feature 3');
    axis square;
    colormap([128 128 128; 0 0 0; 255 255 255]/255);

    subplot(3,2,4)
    imagesc(m4);
    title('Rectangular mask for feature 4');
    axis square;
    colormap([128 128 128; 0 0 0; 255 255 255]/255);

    subplot(3,2,5)
    imagesc(m5);
    title('Rectangular mask for feature 5');
    axis square;
    colormap([128 128 128; 0 0 0; 255 255 255]/255);

    subplot(3,2,6)
    imagesc(m6);
    title('Rectangular mask for feature 6');
    axis square;
    colormap([128 128 128; 0 0 0; 255 255 255]/255);
    
    %% Load image, compute Integral Image and visualize it

    % Load image 'NASA1.jpg' and convert image from rgb to grayscale 
    I=imread('NASA1.bmp');
    S=rgb2gray(I);

    % Compute the Integral Image
    S=integralImage(S);



    %% Compute features for regions with faces

    % (X,Y) coordinates of the top-left corner of windows with face
    X = [193 340 444 573 717 834 979 1066 1224 195 445 717 964 1200];
    Y = [118 151 112 177 114 177 121 184 127 270 298 279 285 295];
    XY_FACE =  [X' Y'];    %[x1 y1; x2 y2 .....]

    % Initialize the feature matrix for faces
    FEAT_FACE = [];

    for i = 1:size(XY_FACE,1)

        % current top-left corner coordinates
         x = XY_FACE(i,1); 
         y = XY_FACE(i,2);

        % compute area of regions A and B for the first feature
        % HERE WE USE INTEGRAL IMAGE!
        area_A = S(y+d1+h1,x+d2+w1) - S(y+d1+1,x+d2+w1) - (S(y+d1+h1,x+d2+1) - S(y+d1+1,x+d2+1));
        area_B = S(y+2*h1+d1,x+w1+d2) - S(y+d1+h1+1,x+d2+w1) - (S(y+d1+2*h1,x+d2+1)-S(y+d1+h1+1,x+d2+1));

        % compute area of regions C, D and E for the second feature
        % HERE WE USE INTEGRAL IMAGE!
        area_C = S(y+d3+h2,x+d4+w2) - S(y+d3+1,x+d4+w2) - (S(y+d3+h2,x+d4+1) - S(y+d3+1,x+d4+1));
        area_D = S(y+d3+h2,x+d4+w2+w3) - S(y+d3+1,x+d4+w2+w3) - (S(y+d3+h2,x+d4+w2+1) - S(y+d3+1,x+d4+w2+1));
        area_E = S(y+d3+h2,x+d4+2*w2+w3) - S(y+d3+1,x+d4+2*w2+w3) - (S(y+d3+h2,x+d4+w2+w3+1) - S(y+d3+1,x+d4+w2+w3+1));

        % compute area of regions F, G and H for the second feature
        % HERE WE USE INTEGRAL IMAGE!
        area_F = S(y+d5+h3,x+d5+w4) - S(y+d5+1,x+d5+w4) - (S(y+d5+h3,x+d5+1) - S(y+d5+1,x+d5+1));
        area_G = S(y+d5+h3+h4,x+d5+w4) - S(y+d5+h3,x+d5+w4) - (S(y+d5+h3+h4,x+d5+1) - S(y+d5+h3,x+d5+1));
        area_H = S(y+d5+h3+h4+h3,x+d5+w4) - S(y+d5+h3+h4,x+d5+w4) - (S(y+d5+h3+h4+h3,x+d5+1) - S(y+d5+h3+h4,x+d5+1));

        % compute area of regions I, J, K and L for the second feature
        % HERE WE USE INTEGRAL IMAGE!
        area_I = S(y+d6+h5,x+d6+w5) - S(y+d6+1,x+d6+w5) - (S(y+d6+h5,x+d6+1) - S(y+d6+1,x+d6+1));
        area_J = S(y+d6+h5,x+d6+w5*2) - S(y+d6+1,x+d6+w5*2) - (S(y+d6+h5,x+d6+w5+1) - S(y+d6+1,x+d6+w5+1));
        area_K = S(y+d6+2*h5,x+d6+w5) - S(y+d6+h5+1,x+d6+w5) - (S(y+d6+2*h5,x+d6+1) - S(y+d6+h5+1,x+d6+1));
        area_L = S(y+d6+2*h5,x+d6+w5*2) - S(y+d6+h5+1,x+d6+w5*2) - (S(y+d6+2*h5,x+d6+w5+1) - S(y+d6+h5+1,x+d6+w5+1));

        % compute area of regions M, N and O for the second feature
        % HERE WE USE INTEGRAL IMAGE!
        area_M = S(y+d7+h6,x+d8+w6) - S(y+d7+1,x+d8+w6) - (S(y+d7+h6,x+d8+1) - S(y+d7+1,x+d8+1));
        area_N = S(y+d7+h6+h7,x+d8+w6) - S(y+d7+h6+1,x+d8+w6) - (S(y+d7+h6+h7,x+d8+1) - S(y+d7+h6+1,x+d8+1));
        area_O = S(y+d7+h6+h7+h6,x+d8+w6) - S(y+d7+h6+h7+1,x+d8+w6) - (S(y+d7+h6+h7+h6,x+d8+1) - S(y+d7+h6+h7+1,x+d8+1));

        % compute area of regions P and Q for the second feature
        % HERE WE USE INTEGRAL IMAGE!
        area_P = S(y+d9+h8,x+d9+w7) - S(y+d9+1,x+d9+w7) - (S(y+d9+h8,x+d9+1) - S(y+d9+1,x+d9+1));
        area_Q = S(y+d9+h8,x+d9+w7*2) - S(y+d9+1,x+d9+w7*2) - (S(y+d9+h8,x+d9+w7+1) - S(y+d9+1,x+d9+w7+1));
        

        % compute features value
        F1 = area_B - area_A;
        F2 = area_D - (area_C + area_E);
        F3 = area_G - (area_F + area_H);
        F4 = area_J + area_K - (area_I + area_L);
        F5 = area_N - (area_M + area_O);
        F6 = area_Q - area_P;

        % cumulate the computed values
        FEAT_FACE = [FEAT_FACE; [F1 F2 F3 F4 F5 F6]];

    end

    %% Compute features for regions with non-faces

    % (X,Y) coordinates of the top-left corner of windows with non-face
    X=[ 28 307 574 829 1093 203 350 523 580 800 931 1127 692 1265];
    Y=[ 36    28    27    30    46   768   757   742   859   745   912   777   994   820];
    XY_NON_FACE = [X' Y'];

    % Initialize the feature matrix for non-faces
    FEAT_NON_FACE = [];

    for i = 1:size(XY_NON_FACE,1)

        % current top-left corner coordinates
        x = XY_NON_FACE(i,1); y = XY_NON_FACE(i,2);

        % compute area of regions A and B for the first feature
        % HERE WE USE INTEGRAL IMAGE!
        area_A = S(y+d1+h1,x+d2+w1) - S(y+d1+1,x+d2+w1) - (S(y+d1+h1,x+d2+1) - S(y+d1+1,x+d2+1));
        area_B = S(y+2*h1+d1,x+w1+d2) - S(y+d1+h1+1,x+d2+w1) - (S(y+d1+2*h1,x+d2+1)-S(y+d1+h1+1,x+d2+1));

        % compute area of regions C, D and E for the second feature
        % HERE WE USE INTEGRAL IMAGE!
        % >> code to compute the area of regions C and E <<
        area_C = S(y+d3+h2,x+d4+w2) - S(y+d3+1,x+d4+w2) - (S(y+d3+h2,x+d4+1) - S(y+d3+1,x+d4+1));
        area_D = S(y+d3+h2,x+d4+w2+w3) - S(y+d3+1,x+d4+w2+w3) - (S(y+d3+h2,x+d4+w2+1) - S(y+d3+1,x+d4+w2+1));
        area_E = S(y+d3+h2,x+d4+2*w2+w3) - S(y+d3+1,x+d4+2*w2+w3) - (S(y+d3+h2,x+d4+w2+w3+1) - S(y+d3+1,x+d4+w2+w3+1));

        % compute area of regions F, G and H for the second feature
        % HERE WE USE INTEGRAL IMAGE!
        area_F = S(y+d5+h3,x+d5+w4) - S(y+d5+1,x+d5+w4) - (S(y+d5+h3,x+d5+1) - S(y+d5+1,x+d5+1));
        area_G = S(y+d5+h3+h4,x+d5+w4) - S(y+d5+h3,x+d5+w4) - (S(y+d5+h3+h4,x+d5+1) - S(y+d5+h3,x+d5+1));
        area_H = S(y+d5+h3+h4+h3,x+d5+w4) - S(y+d5+h3+h4,x+d5+w4) - (S(y+d5+h3+h4+h3,x+d5+1) - S(y+d5+h3+h4,x+d5+1));

        % compute area of regions I, J, K and L for the second feature
        % HERE WE USE INTEGRAL IMAGE!
        area_I = S(y+d6+h5,x+d6+w5) - S(y+d6+1,x+d6+w5) - (S(y+d6+h5,x+d6+1) - S(y+d6+1,x+d6+1));
        area_J = S(y+d6+h5,x+d6+w5*2) - S(y+d6+1,x+d6+w5*2) - (S(y+d6+h5,x+d6+w5+1) - S(y+d6+1,x+d6+w5+1));
        area_K = S(y+d6+2*h5,x+d6+w5) - S(y+d6+h5+1,x+d6+w5) - (S(y+d6+2*h5,x+d6+1) - S(y+d6+h5+1,x+d6+1));
        area_L = S(y+d6+2*h5,x+d6+w5*2) - S(y+d6+h5+1,x+d6+w5*2) - (S(y+d6+2*h5,x+d6+w5+1) - S(y+d6+h5+1,x+d6+w5+1));

        % compute area of regions M, N and O for the second feature
        % HERE WE USE INTEGRAL IMAGE!
        area_M = S(y+d7+h6,x+d8+w6) - S(y+d7+1,x+d8+w6) - (S(y+d7+h6,x+d8+1) - S(y+d7+1,x+d8+1));
        area_N = S(y+d7+h6+h7,x+d8+w6) - S(y+d7+h6+1,x+d8+w6) - (S(y+d7+h6+h7,x+d8+1) - S(y+d7+h6+1,x+d8+1));
        area_O = S(y+d7+h6+h7+h6,x+d8+w6) - S(y+d7+h6+h7+1,x+d8+w6) - (S(y+d7+h6+h7+h6,x+d8+1) - S(y+d7+h6+h7+1,x+d8+1));

        % compute area of regions P and Q for the second feature
        % HERE WE USE INTEGRAL IMAGE!
        area_P = S(y+d9+h8,x+d9+w7) - S(y+d9+1,x+d9+w7) - (S(y+d9+h8,x+d9+1) - S(y+d9+1,x+d9+1));
        area_Q = S(y+d9+h8,x+d9+w7*2) - S(y+d9+1,x+d9+w7*2) - (S(y+d9+h8,x+d9+w7+1) - S(y+d9+1,x+d9+w7+1));
        
        
        % compute features value
        F1 = area_B - area_A;
        F2 = area_D - (area_C + area_E);
        F3 = area_G - (area_F + area_H);
        F4 = area_J + area_K - (area_I + area_L);
        F5 = area_N - (area_M + area_O);
        F6 = area_Q - area_P;

        % cumulate the computed values
        FEAT_NON_FACE = [FEAT_NON_FACE; [F1 F2 F3 F4 F5 F6]];

    end

    %% Visualize samples in the feature space
    figure(3)
    scatter3(FEAT_FACE(:,1),FEAT_FACE(:,2),FEAT_FACE(:,3),'g');
    hold on
    scatter3(FEAT_NON_FACE(:,1),FEAT_NON_FACE(:,2),FEAT_NON_FACE(:,3),'r');
    xlabel('Feature 1');
    ylabel('Feature 2');
    zlabel('Feature 3');
    title('Feature space');
    legend('Face', 'Non face')
    
    figure(4)
    scatter3(FEAT_FACE(:,4),FEAT_FACE(:,5),FEAT_FACE(:,6),'g');
    hold on
    scatter3(FEAT_NON_FACE(:,4),FEAT_NON_FACE(:,5),FEAT_NON_FACE(:,6),'r');
    xlabel('Feature 4');
    ylabel('Feature 5');
    zlabel('Feature 6');
    title('Feature space');
    legend('Face', 'Non face')


    %% Visualize image with used regions
    figure(4);
    imshow(I);

    % patches with faces
    for i = 1:size(XY_FACE,1)
        PATCH = [XY_FACE(i,:) L L];
        Rectangle = [PATCH(1) PATCH(2); PATCH(1)+PATCH(3) PATCH(2); PATCH(1)+PATCH(3) PATCH(2)+PATCH(4); PATCH(1)  PATCH(2)+PATCH(4); PATCH(1) PATCH(2)];
        hold on;
        plot (Rectangle(:,1), Rectangle(:,2), 'g');
        hold off;
    end

    % patches without faces
    for i = 1:size(XY_NON_FACE,1)
        PATCH = [XY_NON_FACE(i,:) L L];
        Rectangle = [PATCH(1) PATCH(2); PATCH(1)+PATCH(3) PATCH(2); PATCH(1)+PATCH(3) PATCH(2)+PATCH(4); PATCH(1)  PATCH(2)+PATCH(4); PATCH(1) PATCH(2)];
        hold on;
        plot (Rectangle(:,1), Rectangle(:,2), 'r');
        hold off;
    end



    %% Part 2:

    %% Define the new regions of the test image 

    % Load image 'NASA2.bmp' and convert image from rgb to grayscale 
    I2=imread('NASA2.bmp');
    S2=rgb2gray(I2);

    % Select regions with FACES and NON-FACES
    figure(5), imshow(S2);
    [x1, y1] = ginput();
    % You can use ginput only once and copy the coordinates here

    x1 = round(x1);
    y1 = round(y1);

    % (X,Y) coordinates of the top-left corner of windows with face
    XY_TEST = [x1 y1];


    %% Compute features for these new regions
    % Compute the Integral Image
    S2 = integralImage(S2);

    % Initialize the feature matrix for faces
    FEAT_TEST = [];

    for i = 1:size(XY_TEST,1)

        % current top-left corner coordinates
        x = XY_TEST(i,1);
        y = XY_TEST(i,2);

        % compute area of regions A and B for the first feature
        % HERE WE USE INTEGRAL IMAGE!
        area_A = S2(y+d1+h1,x+d2+w1) - S2(y+d1+1,x+d2+w1) - (S2(y+d1+h1,x+d2+1) - S2(y+d1+1,x+d2+1));
        area_B = S2(y+2*h1+d1,x+w1+d2) - S2(y+d1+h1+1,x+d2+w1) - (S2(y+d1+2*h1,x+d2+1)-S2(y+d1+h1+1,x+d2+1));

        % compute area of regions C, D and E for the second feature
        % HERE WE USE INTEGRAL IMAGE!
        area_C = S2(y+d3+h2,x+d4+w2) - S2(y+d3+1,x+d4+w2) - (S2(y+d3+h2,x+d4+1) - S2(y+d3+1,x+d4+1));
        area_D = S2(y+d3+h2,x+d4+w2+w3) - S2(y+d3+1,x+d4+w2+w3) - (S2(y+d3+h2,x+d4+w2+1) - S2(y+d3+1,x+d4+w2+1));
        area_E = S2(y+d3+h2,x+d4+2*w2+w3) - S2(y+d3+1,x+d4+2*w2+w3) - (S2(y+d3+h2,x+d4+w2+w3+1) - S2(y+d3+1,x+d4+w2+w3+1));  

        % compute area of regions F, G and H for the second feature
        % HERE WE USE INTEGRAL IMAGE!
        area_F = S(y+d5+h3,x+d5+w4) - S(y+d5+1,x+d5+w4) - (S(y+d5+h3,x+d5+1) - S(y+d5+1,x+d5+1));
        area_G = S(y+d5+h3+h4,x+d5+w4) - S(y+d5+h3,x+d5+w4) - (S(y+d5+h3+h4,x+d5+1) - S(y+d5+h3,x+d5+1));
        area_H = S(y+d5+h3+h4+h3,x+d5+w4) - S(y+d5+h3+h4,x+d5+w4) - (S(y+d5+h3+h4+h3,x+d5+1) - S(y+d5+h3+h4,x+d5+1));

        % compute area of regions I, J, K and L for the second feature
        % HERE WE USE INTEGRAL IMAGE!
        area_I = S(y+d6+h5,x+d6+w5) - S(y+d6+1,x+d6+w5) - (S(y+d6+h5,x+d6+1) - S(y+d6+1,x+d6+1));
        area_J = S(y+d6+h5,x+d6+w5*2) - S(y+d6+1,x+d6+w5*2) - (S(y+d6+h5,x+d6+w5+1) - S(y+d6+1,x+d6+w5+1));
        area_K = S(y+d6+2*h5,x+d6+w5) - S(y+d6+h5+1,x+d6+w5) - (S(y+d6+2*h5,x+d6+1) - S(y+d6+h5+1,x+d6+1));
        area_L = S(y+d6+2*h5,x+d6+w5*2) - S(y+d6+h5+1,x+d6+w5*2) - (S(y+d6+2*h5,x+d6+w5+1) - S(y+d6+h5+1,x+d6+w5+1));

        % compute area of regions M, N and O for the second feature
        % HERE WE USE INTEGRAL IMAGE!
        area_M = S(y+d7+h6,x+d8+w6) - S(y+d7+1,x+d8+w6) - (S(y+d7+h6,x+d8+1) - S(y+d7+1,x+d8+1));
        area_N = S(y+d7+h6+h7,x+d8+w6) - S(y+d7+h6+1,x+d8+w6) - (S(y+d7+h6+h7,x+d8+1) - S(y+d7+h6+1,x+d8+1));
        area_O = S(y+d7+h6+h7+h6,x+d8+w6) - S(y+d7+h6+h7+1,x+d8+w6) - (S(y+d7+h6+h7+h6,x+d8+1) - S(y+d7+h6+h7+1,x+d8+1));

        % compute area of regions P and Q for the second feature
        % HERE WE USE INTEGRAL IMAGE!
        area_P = S(y+d9+h8,x+d9+w7) - S(y+d9+1,x+d9+w7) - (S(y+d9+h8,x+d9+1) - S(y+d9+1,x+d9+1));
        area_Q = S(y+d9+h8,x+d9+w7*2) - S(y+d9+1,x+d9+w7*2) - (S(y+d9+h8,x+d9+w7+1) - S(y+d9+1,x+d9+w7+1));
        
        % compute features value
        F1 = area_B - area_A;
        F2 = area_D - (area_C + area_E);
        F3 = area_G - (area_F + area_H);
        F4 = area_J + area_K - (area_I + area_L);
        F5 = area_N - (area_M + area_O);
        F6 = area_Q - area_P;

        % cumulate the computed values
        FEAT_TEST = [FEAT_TEST; [F1 F2 F3 F4 F5 F6]];

    end


    %% Train a k-nn classifier and test the new windows
    features = [FEAT_FACE; FEAT_NON_FACE];
    Group = [repmat(1, length(FEAT_FACE), 1); repmat(2, length(FEAT_NON_FACE), 1)];
    % Call the function knnclassify
    knn_classification = knnclassify(FEAT_TEST,features,Group);


    %% Visualize samples in the feature space
    
    % First, visualize the training samples:
    figure();
    scatter3(FEAT_FACE(:,1),FEAT_FACE(:,2),FEAT_FACE(:,3),'g');
    hold on
    scatter3(FEAT_NON_FACE(:,1),FEAT_NON_FACE(:,2),FEAT_NON_FACE(:,3),'r');
    xlabel('Feature 1');
    ylabel('Feature 2');
    zlabel('Feature 3');
    title('Feature space');

    % Second, visualize the test samples in two different colors
    scatter3(FEAT_TEST(knn_classification==1,1),FEAT_TEST(knn_classification==1,2),FEAT_TEST(knn_classification==1,3),'b');
    scatter3(FEAT_TEST(knn_classification==2,1),FEAT_TEST(knn_classification==2,2),FEAT_TEST(knn_classification==2,3),'k');
    legend('Face', 'Non face', 'New faces', 'New non-faces')

    
    % First, visualize the training samples:
    figure();
    scatter3(FEAT_FACE(:,4),FEAT_FACE(:,5),FEAT_FACE(:,6),'g');
    hold on
    scatter3(FEAT_NON_FACE(:,4),FEAT_NON_FACE(:,5),FEAT_NON_FACE(:,6),'r');
    xlabel('Feature 4');
    ylabel('Feature 5');
    zlabel('Feature 6');
    title('Feature space');
    
    % Second, visualize the test samples in two different colors
    scatter3(FEAT_TEST(knn_classification==1,4),FEAT_TEST(knn_classification==1,5),FEAT_TEST(knn_classification==1,6),'b');
    scatter3(FEAT_TEST(knn_classification==2,4),FEAT_TEST(knn_classification==2,5),FEAT_TEST(knn_classification==2,6),'k');
    legend('Face', 'Non face', 'New faces', 'New non-faces')


    %% Visualize classification results in the test image

    figure();
    imshow(I2);

    XY_TEST_FACE = XY_TEST(knn_classification==1,:);
    XY_TEST_NON_FACE = XY_TEST(knn_classification==2,:);

    % patches with faces
    for i = 1:size(XY_TEST_FACE,1)
        PATCH = [XY_TEST_FACE(i,:) L L];
        Rectangle = [PATCH(1) PATCH(2); PATCH(1)+PATCH(3) PATCH(2); PATCH(1)+PATCH(3) PATCH(2)+PATCH(4); PATCH(1)  PATCH(2)+PATCH(4); PATCH(1) PATCH(2)];
        hold on;
        plot (Rectangle(:,1), Rectangle(:,2), 'b');
        hold off;
    end

    % patches without faces
    for i = 1:size(XY_TEST_NON_FACE,1)
        PATCH = [XY_TEST_NON_FACE(i,:) L L];
        Rectangle = [PATCH(1) PATCH(2); PATCH(1)+PATCH(3) PATCH(2); PATCH(1)+PATCH(3) PATCH(2)+PATCH(4); PATCH(1)  PATCH(2)+PATCH(4); PATCH(1) PATCH(2)];
        hold on;
        plot (Rectangle(:,1), Rectangle(:,2), 'k');
        hold off;
    end

end