% https://docs.python.org/3/library/pickle.html

% create an 2D int32 array in Matlab of dimension 3x4
A = int32([1:4; 5:8; 9:12]);

% Have Python write this data to a Numpy.pickle file, same as if Python
% code generated the data
mpickle.matlab2pickle(A, "ex1.pkl")

% load Numpy pickle data
Ap = mpickle.pickle2matlab("ex1.pkl");

assert(isequal(A, Ap))