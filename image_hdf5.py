"""
example: image processing in Matlab from Python using HDF5 to exchange data
This does not require Matlab Engine
"""

from pathlib import Path
import scipy.signal.windows
import numpy as np
import shutil
import h5py
import subprocess
import tifffile
from matplotlib.pyplot import Figure

matlab = shutil.which("matlab")
if not matlab:
    raise FileNotFoundError("Could not find Matlab")

img_name = 'corn.tif'

img_file = subprocess.check_output([matlab, "-batch", f"disp(which('{img_name}'))"], text=True)
img_file = Path(img_file.strip()).resolve(strict=True)
# %% get test data from Matlab to Python efficiently
# Matlab factory test data:
# https://www.mathworks.com/help/matlab/import_export/matlab-example-data-sets.html#mw_d7b7b839-5281-47b0-a838-6c6fe5ec32c2

print(f"Using {img_file} as test image")

raw = tifffile.imread(img_file, key=2)
# in this file, a priori the third image is greyscale

# %% Gaussian kernel from Python
kernel = scipy.signal.windows.gaussian(15, std=3)
kernel = np.outer(kernel, kernel)

# %% interchange HDF5 file

h5file = Path("image_proc_matlab_engine.h5").resolve()
print(f"Using {h5file} to exchange data between Matlab and Python")

with h5py.File(h5file, "w") as f:
    f["/raw"] = raw
    f["/kernel"] = kernel

# %% filter image in Matlab using image_hdf5.m script function
subprocess.check_call([matlab, "-batch", f"image_hdf5('{h5file}')"])

fn = Path("image_proc_matlab_engine.png").resolve()

with h5py.File(h5file, "r") as f:
    proc = f["/proc"][:]

print(f"Matlab processing complete. Creating Figure {fn}")

# %% plot
f = Figure()
axs = f.subplots(1, 2)

axs[0].imshow(raw, cmap="gray")
axs[0].set_title("original")

axs[1].imshow(proc, cmap="gray")
axs[1].set_title("filtered in Matlab")

f.savefig(fn)
