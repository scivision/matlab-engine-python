"""
example: image processing in Matlab from Python
"""

from pathlib import Path
import scipy.signal.windows
import numpy as np
from matplotlib.pyplot import Figure
import matlab.engine

eng = matlab.engine.start_matlab("-nojvm")

matlab_version = eng.version()
print(f"Matlab {matlab_version}")

# %% get test data from Matlab to Python efficiently
# Matlab factory test data:
# https://www.mathworks.com/help/matlab/import_export/matlab-example-data-sets.html#mw_d7b7b839-5281-47b0-a838-6c6fe5ec32c2

dat = eng.imread("corn.tif", 3)

# %% Matlab array => Numpy array
img = np.array(dat.tomemoryview()).reshape(dat.size, order="F")

# %% Apply Gaussian filter to image using Gaussian kernel from Python
kernel = scipy.signal.windows.gaussian(15, std=3)
kernel = np.outer(kernel, kernel)

# %% filter image
Y = eng.conv2(matlab.double(img.tolist()), matlab.double(kernel.tolist()))

eng.quit()  # optional

fn = Path("image_proc_matlab_engine.png").resolve()

print(f"Matlab Engine processing complete. Creating Figure {fn}")

# %% plot
f = Figure()
axs = f.subplots(1, 2)

axs[0].imshow(img, cmap="gray")
axs[0].set_title("original")

axs[1].imshow(Y, cmap="gray")
axs[1].set_title("filtered in Matlab")

f.savefig(fn)
