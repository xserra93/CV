function applyDifferentSizeFilters(im)
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
    applyFilters(im, filters);
end