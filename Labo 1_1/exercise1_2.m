tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));

filename = 'images\sillas.jpg';

im = imread(filename);

red_channel = im2double(im(:,:,1));
blue_channel = im2double(im(:,:,2));
green_channel = im2double(im(:,:,3));

figure('name','Modification of colour channels');
subplot(2,3,1);
im_interchanged = cat(3,blue_channel,red_channel,green_channel);
imshow(im_interchanged);
title('RGB transformed into BRG');
subplot(2,3,2);
imshow(im);
title('Original image');
subplot(2,3,3);
im_with_0 = cat(3,red_channel,0*green_channel,blue_channel);
imshow(im_with_0);
title('Green channel suppressed');
subplot(2,3,4);
imshow(red_channel);
title('Only red channel displayed');
subplot(2,3,5);
imshow(blue_channel);
title('Only blue channel displayed');
subplot(2,3,6);
imshow(green_channel);
title('Only green channel displayed');
