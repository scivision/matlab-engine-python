classdef TestUnit < matlab.unittest.TestCase


methods (Test)

function test_image_proc(~)
close('all')
f1 = image_proc();
close(f1);
end

function test_pickle(~)

PythonPickle()

end

end

end