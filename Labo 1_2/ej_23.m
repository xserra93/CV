v = VideoReader('10Seconds.avi');
while hasFrame(v)
    video = enhance_edges(readFrame(v));
end