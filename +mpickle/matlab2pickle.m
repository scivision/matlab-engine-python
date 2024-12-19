%% MATLAB2PICKLE save a MATLAB array to a Python pickle file
%
% A is a Matlab array of type int32, double, single, logical, etc.
%   that is a representable in Python.

function matlab2pickle(A, filename)

pyA = py.numpy.array(A);

filename = py.pathlib.Path(filename).expanduser();

% create a python file handle to a binary file, overwriting existing file
% dump the array to the pickle file
py.pickle.dump(pyA, py.open(filename, "wb"));

end
