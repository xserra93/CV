tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));


images = {'car_gray.jpg' 'street.png' 'clooney.jpg'};

for i = 1:length(images);
    im = imread(strcat('images\',images{i}));
    if (length(size(im))==3)
        im = rgb2gray(im);
    end

    % 1.3.b
    showResizing(im);

    % 1.3.c
    % Apply gaussian and self defined
    applyGaussianFilter(im,3);

    % Size of the filter?
    applyDifferentSizeFilters(im);

    % Apply filter 10 times
    applyFilterXTimes(im, 10);
    
    % Apply median filters
    applyMedianFilter(im);
end

im_rgb = imread('images\clooney.jpg');
applyFilterToRGB(im_rgb);

applyFiltersNotNormalized(im);
