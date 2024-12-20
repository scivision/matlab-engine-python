function [dat, sv] = loadRINEXpickle(filename, keys)
arguments
  filename (1,1) string
  keys (1,:) string
end

pyA = mpickle.load_pickle(filename);

sv = string(pyA{"sv"}.values.tolist());

dat = struct();

for k = keys
  dat.(k) = py2mat(pyA{k});
end

end