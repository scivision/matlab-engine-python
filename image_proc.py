"""
example: image processing in Matlab from Python
"""

import scipy.signal.windows
import numpy as np
from matplotlib.pyplot import figure, show
import matlab.engine

eng = matlab.engine.start_matlab("-nojvm")

matlab_version = eng.version()
print(f"Matlab {matlab_version}")

# %% get test data from Matlab to Python efficiently
dat = eng.load("clown")

# Matlab array => Numpy array
img = np.array(dat["X"].tomemoryview()).reshape(dat["X"].size, order="F")

# %% Apply Gaussian filter to image using Gaussian kernel from Python
kernel = scipy.signal.windows.gaussian(15, std=3)
kernel = np.outer(kernel, kernel)

# %% filter image
Y = eng.conv2(matlab.double(img.tolist()), matlab.double(kernel.tolist()))

eng.quit()  # optional
# %% plot
f = figure()
axs = f.subplots(1, 2)

axs[0].imshow(img, cmap="gray")
axs[0].set_title("original")

axs[1].imshow(Y, cmap="gray")
axs[1].set_title("filtered in Matlab")


show()
