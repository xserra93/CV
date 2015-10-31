tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));

im_hand = imread('images\hand.jpg');
im_mapfre = imread('images\mapfre.jpg');

figure('name','Superposition of images');
subplot(3,4,2);
imshow(im_hand);
title('Hand image');
subplot(3,4,3);
imshow(im_mapfre);
title('Mapfre image');

threshold = 15;
increment = (220-threshold)/(length(5:12)-1);
for i=5:12
    im_hand_grey = rgb2gray(im_hand);
    im_hand_grey = double(applyThreshold(im_hand_grey, threshold));
    im_hand_inverse = 1-im_hand_grey;

    inverted_mask = uint8(cat(3,im_hand_inverse,im_hand_inverse,im_hand_inverse));
    binary_mask = uint8(cat(3,im_hand_grey,im_hand_grey,im_hand_grey));
    im_mapfre_modified = im_mapfre.*inverted_mask;
    im_hand_modified = im_hand .* binary_mask;
    im_final = im_mapfre_modified + im_hand_modified;

    subplot(3,4,i);
    imshow(im_final)
    title(strcat('Threshold: ',num2str(threshold)));
    threshold = threshold+increment;
    
    if i == 5
        imwrite(im_final,'images\hand_mapfre_3C.jpg');
    end
end

