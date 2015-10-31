function im_result = applyFilter(im, h)
    h = h/sum(sum(h));
    im_result = imfilter(im, h);
end