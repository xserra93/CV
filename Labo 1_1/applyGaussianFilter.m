function applyGaussianFilter(im, side_size)
    figure('name','Applying gaussian and self-made filter');
    h1 = fspecial('gaussian', [side_size side_size], 2);
    h2 = ones(side_size);
    subplot(1,3,1);
    imshow(applyFilter(im,h1));
    title('Gaussian filter');

    subplot(1,3,2);
    imshow(im);
    title('Original image');

    subplot(1,3,3);
    imshow(applyFilter(im,h2));
    title('Self defined filter');
end