function features = getColorFeatures(im)
    pixels = size(im,1)*size(im,2);
    
    red = double(im(:,:,1));
    green = double(im(:,:,2));
    blue = double(im(:,:,3));
    features = 15*[hist(red(:))'; hist(green(:))'; hist(blue(:))']./pixels;
end