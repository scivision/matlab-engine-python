function image_hdf5(h5fn)
arguments
    h5fn (1,1) string {mustBeFile}
end

raw = h5read(h5fn, '/raw');
kernel = h5read(h5fn, '/kernel');

proc = conv2(raw, kernel, 'same');

h5create(h5fn, '/proc', size(proc), 'Datatype', 'double');
h5write(h5fn, '/proc', proc);

disp("Matlab: done filtering image in " + h5fn)

end
