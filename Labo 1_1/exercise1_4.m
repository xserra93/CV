tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));

im = imread('images\clooney.jpg');
num_column = 212;
im_interchanged = interchange(im, num_column);

figure('name', 'Image interchanging');
subplot(1,2,1);
imshow(im);
title('Original image');
subplot(1,2,2);
imshow(im_interchanged);
title('Interchanged image');