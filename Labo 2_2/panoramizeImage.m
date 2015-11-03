function panoramizeImage(Ia, Ib, M, num_samples)
    tic;
    Ia = single(rgb2gray(Ia));
    Ib = single(rgb2gray(Ib));
    [fa,da] = vl_sift(Ia);
    [fb,db] = vl_sift(Ib);
    [matches, scores] = vl_ubcmatch(da,db);
    numMatches = size(matches,2);
    xa = fa(1:2,matches(1,:));
    xb = fb(1:2,matches(2,:));


    best_n = 0;
    best_p = 0;
    error_threshold=5;
    for num_iteration=1:M
        subset = vl_colsubset(1:numMatches, num_samples);

        d = xb(1:2,subset) - xa(1:2,subset);
        p = mean(d,2);
        xb_ = zeros(size(xb));
        for i=1:numMatches,
            xb_(:,i) = xa(:,i) + p;
        end

        n = 0;
        for i=1:numMatches,
            e = xb_(:,i) - xb(:,i);
            if (norm(e) < error_threshold)
                n = n + 1;
            end
        end
        if n > best_n
            best_n = n;
            best_p = p;
        end
    end

    box2 = [1 size(Ia,2) size(Ia,2) 1;
    1 1 size(Ia,1) size(Ia,1)];
    box2_ = zeros(2,4);
    for i=1:4,
        box2_(:,i) = box2(:,i) + best_p;
    end
    min_x = min(1,min(box2_(1,:)));
    min_y = min(1,min(box2_(2,:)));
    max_x = max(size(Ib,2),max(box2_(1,:)));
    max_y = max(size(Ib,1),max(box2_(2,:)));

    ur = min_x:max_x;
    vr = min_y:max_y;
    [u,v] = meshgrid(ur,vr);
    Ib_ = vl_imwbackward(im2double(Ib),u,v);

    p_inverse = -p;
    u_ = u + p_inverse(1);
    v_ = v + p_inverse(2);
    Ia_ = vl_imwbackward(im2double(Ia),u_,v_);

    mass = ~isnan(Ib_) + ~isnan(Ia_);
    Ib_(isnan(Ib_)) = 0;
    Ia_(isnan(Ia_)) = 0;
    panoramic = (Ib_ + Ia_) ./ mass;
    
    time = toc;
    
    subplot(2,2,1);
    imshow(Ia, []);
    title('First image');
    subplot(2,2,2);
    imshow(Ib, []);
    title('Second image');
    subplot(2,2,3:4);
    imshow(panoramic,[]);
    title(['Panoramic image - Total time: ' num2str(time)]);
end