function applyFilters(im, filters)
    num_filters = length(filters);
    num_columns = min(length(filters),3);
    num_rows = ceil(num_filters/num_columns)+1;
    figure('name','Applying different filters');
    subplot(num_rows,num_columns,2);
    imshow(im);
    title('Original image');
    for i = 1:length(filters)
        h = filters{i};
        im_filtered = applyFilter(im, h);
        subplot(num_rows, num_columns, i+3);
        imshow(im_filtered);
        title(['Size filter: ',int2str(size(filters{i}))]);
    end
end