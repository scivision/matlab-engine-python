function check_numpy()
%% wrangle Numpy issues from Matlab
% Numpy issues can happen with Matlab on Windows due to Numpy DLL conflicts.
% if this function doesn't error, Numpy may be OK.

penv = pyenv();

disp("Python " + penv.Version + " home dir: " + penv.Home)

if ispc
  % setenv("KMP_DUPLICATE_LIB_OK", "TRUE")
  % this avoids Matlab crash due to:
  % OMP: Error #15: Initializing libiomp5md.dll, but found libiomp5md.dll already initialized.
  % is this error from Matlab libiomp5md.dll loaded and Numpy also loads that DLL?
end

try
  py.numpy.array([]);
catch err
  if ispc
    patch_dllpath()
  else
    rethrow(err)
  end
end

try
  py.numpy.array([]);
  % checking that workaround worked--would probably error again otherwise
catch err
  error("Could not load Numpy. Try diagnosing with py.importlib.import_module('numpy') \n%s %s", err.identifier, err.message)
end

disp("OK: Numpy " + string(py.numpy.version.version))

end


function patch_dllpath()

penv = pyenv;
dllpath = fullfile(penv.Home, "Library", "bin");
assert(isfolder(dllpath), "Could not find DLL path for Python: %s", dllpath)

disp("prepending environment variable PATH with: " + dllpath)

setenv("PATH", append(getenv("PATH"), pathsep, dllpath))

end
