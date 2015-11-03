function im_result = applyThreshold(im, threshold)
    im_result = im;
    im_result(im<threshold)=0;
    im_result(im>=threshold)=1;
end