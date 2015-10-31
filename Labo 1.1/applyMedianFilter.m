function applyMedianFilter(im)
    figure('name', 'Applying median and gaussian filtering');
    subplot(4,3,2);
    imshow(im);
    title('Original image');
    for i = 3:3:9
        im_median = medfilt2(im, [i i]);
        h1 = fspecial('gaussian', [i i], 2);
        im_gaussian = applyFilter(im,h1);
        h2 = ones(i);
        im_defined_filter = applyFilter(im,h2);
        
        subplot(4,3,1+i);
        imshow(im_median);
        title(['Median filter: ' num2str(i) 'x' num2str(i)]);
        
        subplot(4,3,2+i);
        imshow(im_gaussian);
        title(['Gaussian filter: ' num2str(i) 'x' num2str(i)]);
        
        subplot(4,3,3+i);
        imshow(im_defined_filter);
        title(['User defined filter: ' num2str(i) 'x' num2str(i)]);
    end
end