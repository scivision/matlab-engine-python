# Matlab Python interfacing

Install necessary package by either:

```sh
conda install --file requirements.txt
```

or

```sh
python -m pip install -r requirements.txt
```

Another way (particularly if using a brand new Matlab release) is to install directly from Matlab directory like:

```sh
python -m pip install /Applications/MATLAB_R2023b.app/extern/engines/python/
```

## HDF5 data exchange

To avoid using Matlab Engine, which requires compatible versions of Python and Matlab,
one can interchange data using a file and calling the other language interpreter.

Example: [image_hdf5.py](./image_hdf5.py) calls Matlab function [image_hdf5.m](./image_hdf5.m).

## Matlab Engine examples

Python can directly exchange data with Matlab and call Matlab functions via
[Matlab Engine for Python](https://www.mathworks.com/help/matlab/apiref/matlab.engine.matlabengine.html).
[Setup](https://www.mathworks.com/help/matlab/matlab_external/install-the-matlab-engine-for-python.html)
Matlab Engine for Python:

```sh
python -m pip install matlabengine
```

Example: [image_matlab_engine.py](./image_matlab_engine.py).

## Matlab using Python

Matlab can use Python code via
[pyenv](https://www.mathworks.com/help/matlab/ref/pyenv.html).

Example: [image_proc.m](./image_proc.m).

## Troubleshooting

### Numpy import issues

[check_numpy.m](./check_numpy.m)
shows how to check issues with DLLs on Windows with Numpy and Matlab.

Python
[importlib](https://docs.python.org/3/library/importlib.html)
can also give hints about problems importing:

```matlab
py.importlib.import_module('numpy')
```

Other things to try especially on Windows include:

```matlab
setenv("KMP_DUPLICATE_LIB_OK", "TRUE")
```

this avoids Matlab crash below--is this error from Matlab libiomp5md.dll loaded and Numpy also loads that DLL?

```
OMP: Error #15: Initializing libiomp5md.dll, but found libiomp5md.dll already initialized.
```
