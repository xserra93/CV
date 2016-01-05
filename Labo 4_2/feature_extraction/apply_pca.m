function PCAImagesDim = apply_pca(images, dim, plot_results)
    % APPLY_PCA 
    % PCAImagesDim It returns the matrix with reduced attributes.
    % Each column is an image
    % 

    %% PCA
    % Use princomp.m to compute:
    % 5. To complete: DONE
    [PCACoefficients, PCAImages, PCAValues] = pca(images);

    %% Show the 30 first eigenfaces
    % 6. To complete: I THINK IT'S DONE
    if plot_results
        show_eigenfaces(PCACoefficients);
    end

    %% Plot the explained variance using 100 dimensions
    % 7. To complete: DONE
    cummulative = cumsum(PCAValues)./sum(PCAValues);
    if plot_results
        figure('Color','white')
        plot(cummulative(1:100))
        title('Variance')
        xlabel('Num. dimensions')
        ylabel('Accumulated variance')
    end

    %% Keep the first 'dim' dimensions where dim is given or computed as the
    %% dimensions necessary to preserve 90% of the data variance.
    if dim>0
        PCAImagesDim = PCAImages(:,1:dim);
    else
        % Compute the number of dimensions necessary to preserve 95% of the data variance.
        % 8. To complete: DONE
        dim = find(cummulative>=0.95,1);
        PCAImagesDim = PCAImages(:,1:dim);
    end
end