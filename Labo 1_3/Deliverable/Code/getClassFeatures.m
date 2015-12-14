function feature_array = getClassFeatures(directory, ext)
if ~isempty(strfind(ext,'.'))
    ext = strcat('*',ext);
else
    ext = strcat('*.',ext);
end

files = dir(fullfile(directory,ext));

if size(files,1) == 0
    error('No files found with such extension in the specified directory');
end

for i = 1:size(files,1)
    im = imread(fullfile(directory,files(i).name));
    feature_array(:,i) = [getFeatures(im,0); getColorFeatures(im)];
end

feature_array = feature_array';
end