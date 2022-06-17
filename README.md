# Matlab Python interfacing

[Setup](https://www.mathworks.com/help/matlab/matlab_external/install-the-matlab-engine-for-python.html)
Matlab Engine for Python:

```sh
python setup_matlab_engine.py
```

Matlab can use Python via
[pyenv](https://www.mathworks.com/help/matlab/ref/pyenv.html).
See example in [image_proc.py](./image_proc.m).
We show how to workaround issues with DLLs on Windows with Numpy and Matlab in the example.

Separately, Python can use Matlab via
[Matlab Engine for Python](https://www.mathworks.com/help/matlab/apiref/matlab.engine.matlabengine.html).
See example in [image_proc.py](./image_proc.py).
