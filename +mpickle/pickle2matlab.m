%% PICKLE2MATLAB load a Python pickle file to Matlab array

function A = pickle2matlab(filename)

pyA = py.pickle.load(py.open(filename, "rb"));

A = mpickle.py2mat(pyA);

end
