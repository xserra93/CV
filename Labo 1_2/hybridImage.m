% It returns the hybrid image of images im1 and im2 using sigma1 and sigma
% 2. It can be applied to color images.
function res_im = hybridImage(im1, im2, sigma1, sigma2)
    if length(size(im1)) < 3
        [m n] = size(im1);
        h1 = fspecial('gaussian', [m n], sigma1);
        h2 = fspecial('gaussian', [m n], sigma2);
        im1_low_filtered = imfilter(im1, h1);
        im2_low_filtered = imfilter(im2, h2);
    else
        [m n z] = size(im1);
        h1 = fspecial('gaussian', [m n], sigma1);
        h2 = fspecial('gaussian', [m n], sigma2);
        im1_low_filtered = zeros(m, n, 3);
        im2_low_filtered = zeros(m, n, 3);
        for i = 1:3
            im1_low_filtered(:,:,i) = imfilter(im1(:,:,i), h1);
            im2_low_filtered(:,:,i) = imfilter(im2(:,:,i), h2);
        end
    end
    im2_high_filtered = im2 - im2_low_filtered;
    res_im = im1_low_filtered + im2_high_filtered;
end