function showResizing(im)
    figure('name','Resizing');
    subplot(4,4,1);
    imshow(im)
    title('Original size');
    subplot(4,4,5);
    imhist(im);

    subplot(4,4,2);
    im_prov = imresize(im, 0.8);
    imshow(im_prov);
    title('Original size * 0.8');
    subplot(4,4,6);
    imhist(im_prov);

    subplot(4,4,3);
    im_prov = imresize(im, 0.5);
    imshow(im_prov);
    title('Original size * 0.5');
    subplot(4,4,7);
    imhist(im_prov);

    subplot(4,4,4);
    im_prov = imresize(im, 0.2);
    imshow(im_prov);
    title('Original size * 0.2');
    subplot(4,4,8);
    imhist(im_prov);

    subplot(4,4,10);
    imshow(im)
    title('Original image');
    subplot(4,4,14);
    imhist(im);

    im_back = imresize(im_prov, 5);
    subplot(4,4,11);
    imshow(im_back)
    title('Retrieved image from 0.2');
    subplot(4,4,15);
    imhist(im_prov);
end