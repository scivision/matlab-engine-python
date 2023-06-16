# Matlab Python interfacing

[Setup](https://www.mathworks.com/help/matlab/matlab_external/install-the-matlab-engine-for-python.html)
Matlab Engine for Python:

```sh
python -m pip install matlabengine
```

## Matlab using Python

Matlab can use Python via
[pyenv](https://www.mathworks.com/help/matlab/ref/pyenv.html).
See example in [image_proc.m](./image_proc.m).

## Python using Matlab Engine

Separately, Python can use Matlab via
[Matlab Engine for Python](https://www.mathworks.com/help/matlab/apiref/matlab.engine.matlabengine.html).
See example in [image_proc.py](./image_proc.py).

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
