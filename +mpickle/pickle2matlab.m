%% PICKLE2MATLAB load a Python pickle file to Matlab array

function A = pickle2matlab(filename)

filename = py.pathlib.Path(filename).expanduser();

pyA = py.pickle.load(py.open(filename, "rb"));

A = py2mat(pyA);

end
