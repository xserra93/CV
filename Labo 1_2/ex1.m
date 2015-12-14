% load the images
original_im1 = im2double(imread('samu.jpg'));
original_im2 = im2double(imread('xavi.jpg'));

% resize both images to have the same size
[im1 im2] = formatImages(original_im1, original_im2);

subplot(3,3,1);
imshow(im1);
subplot(3,3,2);
imshow(im2);

sigma1 = 4;
sigma2 = 7;

% make an hybrid image from these two images
hybrid_im1_im2 = hybridImage(im1, im2, sigma1, sigma2);

subplot(3,3,3);
imshow(hybrid_im1_im2);

% plot the result
for i = 1:6
    subplot(3,3,3+i);
    res_im = imresize(hybrid_im1_im2, 1 - i/10);
    if length(size(im1)) < 3
        im_aux=zeros(size(im1,1),size(im1,2));
        im_aux(1:size(res_im,1),1:size(res_im,2))=res_im;
    else
        im_aux=zeros(size(im1,1),size(im1,2));
        for i = 1:3
            im_aux(1:size(res_im,1),1:size(res_im,2),i)=res_im(:,:,i);
        end
    end

    imshow(im_aux);
end