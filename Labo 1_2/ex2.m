im_col = imread('dol.jpg');
im = rgb2gray(im_col);

detector_list = {'Canny' 'log' 'Prewitt' 'Roberts' 'Sobel' 'zerocross'};
threshold = {[] 0.3 0.6};
threshold_lbl = {'threshold = []' 'threshold = 0.3' 'threshold = 0.6'};

% we plot the results for Canny and log using sigma from 1 to 3 and
% threshold empty, 0.3 and 0.6
for i = 1:2
    for sigma = 1:3
       for threshold_j = 1:3
            figure
            lbl = sprintf('%s detector, sigma = %d; %s', ...
                        detector_list{i}, sigma, threshold_lbl{threshold_j});
            edges_im = edge(im, detector_list{i}, threshold{threshold_j}, ...
                            'both', sigma);
            subplot(1, 3, 1);
            imshow(im_col);
            title('Original image');
            
            subplot(1, 3, 2);
            imshow(edges_im);
            title(lbl);
            
            subplot(1, 3, 3);
            aux_im = im_col;
            aux_im(:,:,1) = aux_im(:,:,1) + uint8(edges_im)*255;
            imshow(aux_im);
            title('Overlapping of edges');
       end
    end
end

% we plot the result of the rest of detectors
for i = 3:length(detector_list)
    figure;
    lbl = sprintf('%s detector', detector_list{i});
    edges_im = edge(im, detector_list{i});

    subplot(1, 3, 1);
    imshow(im_col);
    title('Original image');
    
    subplot(1, 3, 2);
    imshow(edges_im);
    title(lbl);

    subplot(1, 3, 3);
    aux_im = im_col;
    aux_im(:,:,1) = aux_im(:,:,1) + uint8(edges_im)*255;
    imshow(aux_im);
    title('Overlapping of edges');
end