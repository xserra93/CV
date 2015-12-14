% Resize images or_im1 and or_im2 to have the same size.
function [im1 im2] = formatImages(or_im1, or_im2)
    if length(size(or_im1)) < 3
        [m1 n1] = size(or_im1);
        [m2 n2] = size(or_im2);
        m = max(m1, m2);
        n = max(n1, n2);
        or_im1 = imresize(or_im1, max(m/m1, n/n1));
        or_im2 = imresize(or_im2, max(m/m2, n/n2));
        [m1 n1] = size(or_im1);
        [m2 n2] = size(or_im2);
        m = max(m1, m2);
        n = max(n1, n2);
        im1=zeros(m, n);
        aux_m = (m - m1)/2;
        aux_n = (n - n1)/2;
        im1((1 + aux_m):(m1+aux_m), (1 + aux_n):(n1+aux_n)) = or_im1;
  
        im2=zeros(m, n);
        aux_m = (m - m2)/2;
        aux_n = (n - n2)/2;
        im2((1 + aux_m):(m2+aux_m), (1 + aux_n):(n2+aux_n)) = or_im2;
    else
        [m1 n1 z1] = size(or_im1);
        [m2 n2 z2] = size(or_im2);
        m = max(m1, m2);
        n = max(n1, n2);
        or_im1 = imresize(or_im1, max(m/m1, n/n1));
        or_im2 = imresize(or_im2, max(m/m2, n/n2));
        [m1 n1 z1] = size(or_im1);
        [m2 n2 z2] = size(or_im2);
        m = max(m1, m2);
        n = max(n1, n2);
        im1 = zeros(m, n, 3);
        im2 = zeros(m, n, 3);
        for i = 1:3
            aux_m = (m - m1)/2;
            aux_n = (n - n1)/2;
            im1((1 + aux_m):(m1+aux_m), (1 + aux_n):(n1+aux_n), i) = or_im1(:,:,i);

            aux_m = (m - m2)/2;
            aux_n = (n - n2)/2;
            im2((1 + aux_m):(m2+aux_m), (1 + aux_n):(n2+aux_n), i) = or_im2(:,:,i); 
        end
    end
end