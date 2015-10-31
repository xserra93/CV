function applyFiltersNotNormalized(im)
    h1 = ones(1,7); % Horizontal blurring
    h2 = ones(7,1); % Vertical blurring
    h3 = ones(7,7);
    h4 = ones(5,1);
    h5 = ones(1,5);
    h6 = ones(5,5);
    h7 = ones(1,3); % Less blurred, less noise suppressed
    h8 = ones(3,1);
    h9 = ones(3,3);
    filters = {h1 h2 h3 h4 h5 h6 h7 h8 h9};

    num_filters = length(filters);
    num_columns = min(length(filters),3);
    num_rows = ceil(num_filters/num_columns)+1;
    figure('name','Applying non normalized filters');
    subplot(num_rows,num_columns,2);
    imshow(im);
    title('Original image');
    for i = 1:length(filters)
        h = filters{i};
        im_filtered = applyFilterNotNormalized(im, h);
        subplot(num_rows, num_columns, i+3);
        imshow(im_filtered);
        title(['Size filter: ',int2str(size(filters{i}))]);
    end
end