tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));

im = imread('images\car_gray.jpg');
thresholds = [20 30 150 255];

num_thresholds = size(thresholds,2);
figure('name','Binarization with different thresholds');
for i=1:num_thresholds
    threshold = thresholds(i);
    im_prov = applyThreshold(im,threshold);
    im_prov = double(im_prov);
    subplot(2,2,i);
    imshow(im_prov);
    title(strcat('Image binarized with threshold: ',num2str(threshold)));
    if threshold == 150
        im_binary = im_prov;
        imwrite(im_binary,'images\car_binary.jpg');
    end
end

im_double = im2double(im);
im_multiplied = im_double.*im_binary;

inverted_binary = 1-im_binary;
im_inverted_multiplied = im_double.*inverted_binary;

figure('name','Binarization inversions');
subplot(2,2,1);
imshow(im_double)
title('Original image');
subplot(2,2,2);
imshow(im_binary);
title('Binarized image with threshold 150');
subplot(2,2,3);
imshow(im_multiplied)
title('Original image x binarized')
subplot(2,2,4);
imshow(im_inverted_multiplied);
title('Original image x inverted binarizes');

