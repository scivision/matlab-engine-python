function check_numpy()
%% wrangle Numpy issues from Matlab
% Numpy issues can happen with Matlab on Windows due to Numpy DLL conflicts.
% if this function doesn't error, Numpy may be OK.

if ispc
  setenv("KMP_DUPLICATE_LIB_OK", "TRUE")
  % this avoids Matlab crash due to:
  % OMP: Error #15: Initializing libiomp5md.dll, but found libiomp5md.dll already initialized.
  % is this error from Matlab libiomp5md.dll loaded and Numpy also loads that DLL?
end

try
  py.numpy.array([]);
catch err
  if ispc
    patch_dllpath()
    py.numpy.array([]);
    % checking that workaround worked--would probably error again otherwise
  else
    error("Could not load Numpy. Try diagnosing with py.importlib.import_module('numpy') \n%s %s", err.identifier, err.message)
  end
end

end


function patch_dllpath()

penv = pyenv;
pyhome = penv.Home;
dllpath = fullfile(pyhome, "Library", "bin");
assert(isfolder(dllpath), "Could not find DLL path for Python: %s", dllpath)
syspath = getenv("PATH");
setenv("PATH", append(syspath, pathsep, dllpath));

end
