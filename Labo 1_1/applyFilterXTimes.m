function applyFilterXTimes(im, num_times)
    filters = {ones(1,5) ones(5,1) ones(5)};
    images = {im im im};
    for i=1:num_times
        for j=1:length(filters)
            images{j}=applyFilter(images{j},filters{j});
        end
    end
    figure('name', ['Applying filters ', num2str(num_times), ' times']);
    for j=1:length(filters)
        subplot(1,length(filters),j);
        imshow(images{j});
        title(['Size filter: ',int2str(size(filters{j}))]);
    end
end