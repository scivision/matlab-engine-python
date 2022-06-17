%% example of doing image processing in Python with image from Matlab
% assumes that you have previously installed scipy in Python.
assert(~verLessThan('matlab', '9.5'), 'Matlab >= R2018b required')
addons = matlab.addons.installedAddons();
has_img = any(contains(addons.Name, 'Image Processing Toolbox'));

check_numpy()
%% 200x320 image
dat = load('clown');
img = dat.X;
%% Apply Gaussian filter to image
% Y = py.skimage.filters.gaussian(Xp, 3);  % segfaults R2018b with Python 3.6
Y = py.scipy.ndimage.gaussian_filter(img, 3);  % another way
%% convert from Numpy array to Matlab array
Y = double(Y);
%% plot
figure(1), clf(1)
t = tiledlayout(1,3);

nexttile(t)
imshow(img, dat.map)
title('original')

nexttile(t)
imshow(Y, dat.map)
title('filtered in Python')
%% Matlab image processing toolbox, if available
% the filter truncation radius isn't the same, so the numerical results differ.
if has_img
  F = fspecial('gaussian', [15,15], 3);
  M = imfilter(img, F);
  nexttile(t)
  imshow(M, dat.map), title('Matlab filtered')
end
