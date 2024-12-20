%% PICKLE2MATLAB load a Python pickle file to Matlab array

function pyA = load_pickle(filename, varname)
arguments
  filename (1,1) string {mustBeFile}
  varname (1,1) string = ""
end

filename = py.pathlib.Path(filename).expanduser();

pyA = py.pickle.load(py.open(filename, "rb"));

if strlength(varname) > 0
  pyA = pyA{varname};
end

end
