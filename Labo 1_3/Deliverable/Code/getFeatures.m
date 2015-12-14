function features = getFeatures(im, use_plot)
    if use_plot == 1
        figure('name','Filter applied');
    end
    F=makeLMfilters();
    im = rgb2gray(im);
    num_filters = size(F,3);
    features = zeros(num_filters,1);
    for i=1:size(F,3)
        im2 = imfilter(im, F(:,:,i));
        features(i) = mean(mean(im2));
        if use_plot == 1
            colormap jet
            subplot(ceil(num_filters/8),8,i);
            imagesc(im2);
        end
    end
end