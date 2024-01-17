# Matlab Engine for Python

This repo gives examples of calling Matlab functions from Python using
[Matlab Engine for Python](https://www.mathworks.com/help/matlab/apiref/matlab.engine.matlabengine.html).

Install necessary packages for these examples:

```sh
conda install --file requirements.txt

# OR
python -m pip install -r requirements.txt
```

Python can directly exchange data with Matlab and call Matlab functions via Matlab Engine for Python.
[Setup](https://www.mathworks.com/help/matlab/matlab_external/install-the-matlab-engine-for-python.html)
Matlab Engine for Python:

```sh
python -m pip install matlabengine
```

Or install directly from Matlab directory like:

```sh
python -m pip install $(matlab -batch "disp(matlabroot)" | tail -n1)/extern/engines/python/
```

[Article](https://www.scivision.dev/matlab-engine-python-install/)
explains more details of Matlab Engine for Python.

## Numpy.ndarray return from Matlab

Matlab Engine accepts Numpy.ndarray into Matlab functions.
Getting Numpy.ndarray from Matlab Engine returned arrays requires like:

```python
import numpy
import matlab.engine
eng = matlab.engine.start_matlab("-nojvm")

x = numpy.random.random((3,2))

y_m = eng.my_matlab_fun(x)

y = numpy.array(y_m.tomemoryview()).reshape(y_m.size, order="F")
```

## Matlab functions with more than one output

For Matlab functions that return more than one output, use "nargout=" like:

```python
import matlab.engine
eng = matlab.engine.start_matlab("-nojvm")

x, y = eng.myfun(x, nargout=2)
```

## HDF5 data exchange

To avoid using Matlab Engine, which requires compatible versions of Python and Matlab,
one can interchange data using a file and calling the other language interpreter.

Example: [image_hdf5.py](./image_hdf5.py) calls Matlab function [image_hdf5.m](./image_hdf5.m).

Matlab Engine example: [image_matlab_engine.py](./image_matlab_engine.py).

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
