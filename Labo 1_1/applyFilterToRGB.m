function applyFilterToRGB(im)
    h = [1 1 1; 1 1 1; 1 1 1];
    im_filtered = applyFilter(im, h);

    figure('name','Applying filter to RGB image');
    subplot(1,2,1);
    imshow(im);
    title('Original RGB image');
    subplot(1,2,2);
    imshow(im_filtered);
    title('Filtered RGB image');
end