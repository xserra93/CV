tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));

run('vlfeat-0.9.16/toolbox/vl_setup');

one_figure = 0;

Ia = imread('images/im2_ex1.jpg');
Ib = imread('images/im1_ex1.jpg');
Ia = single(rgb2gray(Ia));
Ib = single(rgb2gray(Ib));
if one_figure == 1
    figure('name','Feature extraction');
    subplot(4,6,1:6);
else
    figure('name','Initial image');
end
imshow([Ia Ib],[]);
title('Initial images');

[fa, da] = vl_sift(Ia);
[fb, db] = vl_sift(Ib);
[matches, scores] = vl_ubcmatch(da, db);

if one_figure == 1
    subplot(4,6,7:8);
else
    figure('name','Matches');
    subplot(3,1,1);
end
show_matches(Ia,Ib,fa,fb,matches);
title('All matches');

if one_figure == 1
    subplot(4,6,9:10);
else
    subplot(3,1,2);
end
show_matches(Ia,Ib,fa,fb,random_selection(matches, 50));
title('50 matches randomly choosen');

[matches3, scores2] = vl_ubcmatch(da, db, 3.5);
if one_figure == 1
    subplot(4,6,11:12);
else
    subplot(3,1,3);
end
show_matches(Ia,Ib,fa,fb,matches3);
title('Raised threshold');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           QUESTION 1          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

d = fb(1:2,matches(2,:))-fa(1:2,matches(1,:));
p = mean(d,2);
if one_figure == 1
    subplot(4,6,13:15);
else
    figure('name','Models');
    subplot(2,1,1);
end
show_matches_linear_model(Ia, Ib, fa, fb, p);
title('Linear model');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           QUESTION 2          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

d = fb(1:2, matches(2,:))-fa(1:2, matches(1,:));
i = size(d,2);
A = zeros(6,6);
b = zeros(6,1);
for j = 1:i
    x = fa(1:2, matches(1,j));
    J = [x(1), x(2), 0, 0, 1, 0; 0, 0, x(1), x(2), 0, 1];
    A = A + J'*J;
    b = b + J'*d(1:2,j);
end
p = inv(A)*b;
if one_figure == 1
    subplot(4,6,16:18);
else
    subplot(2,1,2);
end
show_matches_affine_model(Ia, Ib, fa, fb, p);
title('Affine model');


N = 10;
[Y I] = sort(scores);
matches_sorted = matches(:,I);
if one_figure == 1
    subplot(4,6,19:20);
else
    figure('name','Using 10 best matches')
    subplot(3,1,1);
end
show_matches(Ia, Ib, fa, fb, matches_sorted(:,1:N));
title('Only 10 best matches');

N = 10;
d = fb(1:2, matches_sorted(2,1:N))-fa(1:2, matches_sorted(1,1:N));
p = mean(d,2);
if one_figure == 1
    subplot(4,6,21:22);
else
    subplot(3,1,2);
end
show_matches_linear_model(Ia, Ib, fa, fb, p);
title('Linear model with 10 best matches');

N = 10;
d = fb(1:2, matches_sorted(2,1:N))-fa(1:2,matches_sorted(1,1:N));
i = size(d, 2);
A = zeros(6,6);
b = zeros(6,1);
for j = 1:i
    x = fa(1:2, matches_sorted(1,j));
    J = [x(1), x(2), 0, 0, 1, 0; 0, 0, x(1), x(2), 0, 1];
    A = A + J'*J;
    b = b + J'*d(1:2, j);
end
p = inv(A)*b;
if one_figure == 1
    subplot(4,6,23:24);
else
    subplot(3,1,3);
end
show_matches_affine_model(Ia, Ib, fa, fb, p);
title('Affine model with 10 best matches');


