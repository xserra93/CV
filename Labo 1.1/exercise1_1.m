tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));

mat_width = 256;
mat_width_2 = round(mat_width/2);

mat_1 = [zeros(mat_width,mat_width_2) ones(mat_width, mat_width_2)];
mat_2 = [zeros(mat_width_2,mat_width); ones(mat_width_2, mat_width)];
mat_3 = [ones(mat_width_2,mat_width_2) zeros(mat_width_2,mat_width_2); ...
            zeros(mat_width_2,mat_width)];
        
figure('name','Matrix defined images');
subplot(2,2,1);
imshow(mat_1);
title('First image');
subplot(2,2,2);
imshow(mat_2);
title('Second image');
subplot(2,2,3);
imshow(mat_3);
title('Third image');

colour_matrix = cat(3,mat_1,mat_2,mat_3);
subplot(2,2,4);
colour_image = image(colour_matrix);
title('Colour image');
imwrite(colour_matrix,'images\3channels.jpg');