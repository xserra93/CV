function createFeaturesDatabase()
    dir1 = '../texturesimages/buildings';
    dir2 = '../texturesimages/forest';
    dir3 = '../texturesimages/sunset';
    ext = 'jpg';
    
    buildings = getClassFeatures(dir1,ext);
    forest = getClassFeatures(dir2,ext);
    sunset = getClassFeatures(dir3,ext);
    classFeatures = [buildings; forest; sunset];
    save('featuresDatabase.mat','classFeatures');
end