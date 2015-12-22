function PCAImagesDim = apply_pca(images, dim)
    % APPLY_PCA 
    % PCAImagesDim It returns the matrix with reduced attributes.
    % Each column is an image
    % 

    %% PCA
    % Use princomp.m to compute:
    % 5. To complete:
    [PCACoefficients, PCAImages, PCAValues] = princomp(images);

    %% Show the 30 first eigenfaces
    % 6. To complete:
    show_eigenfaces(PCACoefficients, PCAImages);

    %% Plot the explained variance using 100 dimensions
    % 7. To complete:
    % >> code here <<

    %% Keep the first 'dim' dimensions where dim is given or computed as the
    %% dimensions necessary to preserve 90% of the data variance.
    if dim>0
        PCAImagesDim = PCAImages(:,1:dim);
    else
        % Compute the number of dimensions necessary to preserve 95% of the data variance.
        % 8. To complete:
        % >> code here <<

    end
end