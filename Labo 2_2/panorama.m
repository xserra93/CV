tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));

run('vlfeat-0.9.16/toolbox/vl_setup');

for i=1:2
    im_1 = imread(strcat('images/im2_ex',num2str(i),'.jpg'));
    im_2 = imread(strcat('images/im1_ex',num2str(i),'.jpg'));
    for j = 1:3
        M = 10^j;
        for k = 2:2
            num_samples = 10^k;
            figure('name', ['Image: ' num2str(i) ' - M: ' num2str(M) ' - Num samples: ' num2str(num_samples)]);
            panoramizeImage(im_1,im_2, M, num_samples);
        end
    end
end