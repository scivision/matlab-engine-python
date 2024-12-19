classdef TestPy2Mat < matlab.unittest.TestCase


properties (TestParameter)
matlabA = {"single",  "double",  "single",  "complex",   "complex",    "int8", "int16", "int32", "int64", "uint8", "uint16", "uint32", "uint64", "logical"}
pythonA = {"float32", "float64", "float16", "complex64", "complex128", "int8", "int16", "int32", "int64", "uint8", "uint16", "uint32", "uint64", "bool"}
matlabS = {"datetime", "double",  "complex", "int64", "logical"}
end

methods (Test, ParameterCombination = 'sequential')

function test_py2mat_numpy(tc, matlabA, pythonA)
import matlab.unittest.constraints.IsOfClass;

A = 1:5;

if matlabA == "complex"
  A = complex(A);
else
  A = cast(A, matlabA);
end

% https://numpy.org/doc/stable/reference/generated/numpy.array.html
pyA = py.numpy.array(A, pythonA);

B = py2mat(pyA);

if matlabA == "complex"
  tc.verifyFalse(isreal(B));
else
  tc.verifyThat(B, IsOfClass(matlabA));
  tc.verifyEqual(B, A);
end

end


function test_py2mat_scalar(tc, matlabS)
import matlab.unittest.constraints.IsOfClass;

A = 1;

switch matlabS
case "complex"
  A = complex(A);
  pyA = py.complex(A);
case "datetime"
  A = datetime(2021, 12, 25, 1, 2, 34.56);
  pyA = mpickle.datetime2pydatetime(A);
case "int64"
  A = int64(A);
  pyA = py.int(A);
case "double"
  pyA = py.float(A);
case "logical"
  pyA = py.bool(A);
  A = logical(A); %#ok<LOGL>
otherwise
  error("Unknown type")
end

B = py2mat(pyA);

if matlabS == "complex"
  tc.verifyFalse(isreal(B));
else
  tc.verifyThat(B, IsOfClass(matlabS));
  tc.verifyEqual(B, A);
end

end

end

end
