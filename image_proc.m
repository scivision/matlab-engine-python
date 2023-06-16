%% example of doing image processing in Python with image from Matlab
% assumes that you have previously installed scipy in Python.

check_numpy()
%% get test data from Matlab to Python efficiently
% Matlab factory test data:
% https://www.mathworks.com/help/matlab/import_export/matlab-example-data-sets.html#mw_d7b7b839-5281-47b0-a838-6c6fe5ec32c2

dat = imread("corn.tif", 3);
%% Apply Gaussian filter to image
% Y = py.skimage.filters.gaussian(dat, 3);  % Scikit-image
Y = py.scipy.ndimage.gaussian_filter(dat, 3);  % Scipy
%% convert from Numpy array to Matlab array
Y = uint8(Y);
%% plot
figure(1), clf(1)
t = tiledlayout(1,3);

nexttile(t)
imshow(dat)
title('original')

nexttile(t)
imshow(Y)
title('filtered in Python')
%% Matlab image processing toolbox, if available
% the filter truncation radius isn't the same, so the numerical results differ.
try
  F = fspecial('gaussian', [15,15], 3);
  M = imfilter(dat, F);
  nexttile(t)
  imshow(M), title('Matlab filtered')
catch e
  if e.identifier == "MATLAB:UndefinedFunction"
      disp("skipped Image Processing Toolbox example")
  else
      rethrow(e)
  end
end
