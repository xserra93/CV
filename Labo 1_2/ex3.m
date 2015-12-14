% load the video
vr = VideoReader('10Seconds.avi');

% read a fixed number of frames: if not done, the process goes out of 
% memory
frames_to_read = 1000;
ff = read(vr, [1 frames_to_read]);

% apply the Canny detector to each frame of the video
for i = 1:frames_to_read
   im = rgb2gray(ff(:,:,:,i));
   edges_im = edge(im, 'Canny', [], 'both', 1);
   ff(:,:,1,i) = uint8(edges_im)*255 + ff(:,:,1,i);
end

implay(ff);