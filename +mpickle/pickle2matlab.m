function dat = pickle2matlab(filename)
arguments
  filename (1,1) string {mustBeFile}
end

pyA = mpickle.load_pickle(filename);

dat = py2mat(pyA);

end
