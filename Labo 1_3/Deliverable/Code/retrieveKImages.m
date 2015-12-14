function nearest_images = retrieveKImages(im, k, features)

    if ~exist('featuresDatabase.mat','file')
        createFeaturesDatabase;
    end
        
    load('featuresDatabase.mat');
        
    imFeatures = [getFeatures(im,0); getColorFeatures(im)]';
    
    if strcmp(features,'textures')
        IDX = knnsearch(classFeatures(:,1:48),imFeatures(1:48),'K',k + 1);
    elseif strcmp(features,'colors')
        IDX = knnsearch(classFeatures(:,49:end),imFeatures(49:end),'K',k + 1);
    elseif strcmp(features,'both')
        IDX = knnsearch(classFeatures,imFeatures,'K',k + 1);
    else
        error('Wrong type of features');
    end
    
    dir1 = '../texturesimages/buildings';
    buildings = dir(fullfile(dir1,'*.jpg'));
    dir2 = '../texturesimages/forest';
    forest = dir(fullfile(dir2,'*.jpg'));
    dir3 = '../texturesimages/sunset';
    sunset = dir(fullfile(dir3,'*.jpg'));
    for i = 1:length(IDX)
        if IDX(i)<= 30
            im = imread(fullfile(dir1,buildings(IDX(i)).name));
        elseif IDX(i) > 30 && IDX(i) <= 60
            im = imread(fullfile(dir2,forest(IDX(i) - 30).name));
        elseif IDX(i) >60
            im = imread(fullfile(dir3,sunset(IDX(i)-60).name));
        end
        subplot(ceil(length(IDX)/5),5,i)
        imshow(im);
        if i == 1
            title('Image query');
        else
            title(strcat('Similar image number: ', int2str(i-1)));
        end
        nearest_images(:,:,:,i) = im;
    end
    
end