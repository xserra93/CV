function Res = enhance_edges( Frame )
% Frame as a matrix (as an image)
    edg = edges(rgb2gray(Frame), 'canny', 0.2, 2);
    [w,h] = size(edg);
    Res = [];
    for i=1:w
        for j=1:h
            if (edg(i,j) == 1)
                Res(i,j,:) = uint8([0 0 0]);   % Turn black
            else
                Res(i,j,:) = Frame(i,j,:);
            end
        end
    end
    Res = uint8(Res);
end

