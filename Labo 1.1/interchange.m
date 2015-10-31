function im_return = interchange(im,num_column)
    num_total_columns = length(im(1,:,1));
    im_1 = im(:,1:num_column,:);
    im_2 = im(:,num_column+1:num_total_columns,:);
    im_return = [im_2 im_1];
end