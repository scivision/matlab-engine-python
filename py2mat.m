%% PY2MAT Convert a native Python variable to an equivalent native MATLAB variable.
%
% futher enhanced in 2024 by SciVision
% {{{ code/matlab_py/py2mat.m   v 1.3  2023-09-15
% This code accompanies the book _Python for MATLAB Development:
% Extend MATLAB with 300,000+ Modules from the Python Package Index_
% ISBN 978-1-4842-7222-0 | ISBN 978-1-4842-7223-7 (eBook)
% DOI 10.1007/978-1-4842-7223-7
% https://github.com/Apress/python-for-matlab-development
%
% Copyright © 2022-2023 Albert Danial
%
% Contributions by:
%   - https://github.com/hcommin (performance enhancements)
%
% MIT License:
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in
% all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
% THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
% FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
% DEALINGS IN THE SOFTWARE.
% }}}
function [x_mat] = py2mat(x_py)
  switch class(x_py)
    % MATLAB types
    case {'logical', 'double', 'datetime'}
      x_mat = x_py;

    % Python dictionaries
    case 'py.dict'
      try
        % the obvious dict -> struct conversion only works
        % if the key string can be a MATLAB variable
        x_mat = struct(x_py);
      catch EO
        % A failure most likely means a Python key is not
        % a proper MATLAB variable name.  Go through them
        % individually
        key_index = int64(0);
        key_list = cell(py.list(x_py.keys()));
        for key = key_list
          key_index = key_index + 1;
          if class(key) == "cell"
            % key could be a Python number
            v_name = string(py.str(key{1}));
          else
            v_name = string(key);
          end
          if isvarname(v_name)
            x_mat.(v_name) = x_py.get(key_list{key_index});
          else
            x_mat.(matlab.lang.makeValidName(v_name)) = x_py.get(key_list{key_index});
          end
        end
      end
      fields = fieldnames(x_mat);
      for i = 1:length(fields)
        new_var = py2mat(x_mat.(fields{i}));
        x_mat = setfield(x_mat,fields{i}, new_var); %#ok<SFLD>
      end

    % NumPy arrays and typed scalars
    case "py.numpy.ndarray"
      switch string(x_py.dtype.name)
        case "float64"
          x_mat = x_py.double;
        case "float32"
          x_mat = x_py.single;
        case "float16"
          % doesn't exist in matlab, upcast to float32
          x_mat = single(x_py.astype('float32'));
        % only reals and logicals can be cast to arrays so
        % have to cast the rest to either single or double
        case "uint8"
          x_mat = uint8(x_py.astype('float32'));
        case "int8"
          x_mat = int8(x_py.astype('float32'));
        case "uint16"
          x_mat = uint16(x_py.astype('float32'));
        case "int16"
          x_mat = int16(x_py.astype('float32'));
        case "uint32"
          x_mat = uint32(x_py.astype('float32'));
        case "int32"
          x_mat = int32(x_py.astype('float32'));
        case "uint64"
          x_mat = uint64(x_py.astype('float64'));
        case "int64"
          x_mat = int64(x_py.astype('float64'));
        case "bool"
          x_mat = logical(x_py);
        % Complex types require a math operation to coerce the
        % real and imaginary components to contiguous arrays.
        % Use "+0" for minimal performance impact.  Without this,
        % complex creation fails with
        %   Python Error: ValueError: ndarray is not contiguous
        case "complex64"
          x_mat = complex(single(x_py.real+0), single(x_py.imag+0));
        case "complex128"
          x_mat = complex(double(x_py.real+0), double(x_py.imag+0));
        case "complex256"
          fprintf('py2mat:  MATLAB does not support quad precision complex\n')
          x_mat = [];
          return
        otherwise
          % gets here with custom dtypes
          fprintf('py2mat: %s not recognized\n', ...
                  string(x_py.dtype.name));
          x_mat = [];
          return
      end

    % Scipy sparse matrices
    case {'py.scipy.sparse.coo.coo_matrix', ...
          'py.scipy.sparse.csr.csr_matrix', ...
          'py.scipy.sparse.csc.csc_matrix', ...
          'py.scipy.sparse.dok.dok_matrix', ...
          'py.scipy.sparse.bsr.bsr_matrix', ...
          'py.scipy.sparse.dia.dia_matrix', ...
          'py.scipy.sparse.lil.lil_matrix', }
      ndims = x_py.get_shape();
      if length(ndims) ~= 2
          fprintf('py2mat:  can only convert 2D sparse matrices\n')
          x_mat = [];
          return
      end
      nR = int64(ndims{1});
      nC = int64(ndims{2});
      x_py = x_py.tocoo();
      values = py2mat(x_py.data);
      if isempty(values)
          % gets here if trying to convert a complex256 sparse matrix
          return
      end
      % add 1 to row & col indices to go from 0-based to 1-based
      x_mat = sparse(single(x_py.row)+1, single(x_py.col)+1, values, nR, nC);

    % Python sets, tuples, and lists
    case {'cell', 'py.tuple', 'py.list'}
      [nR, nC] = size(x_py);
      x_mat = cell(nR,nC);
      for r = 1:nR
        for c = 1:nC
          x_mat{r,c} = py2mat(x_py{r,c});
        end
      end

    % Python strings
    case 'py.str'
      x_mat = string(x_py);

    case 'py.pathlib.Path'
      x_mat = string(py.str(x_py));

    % Python integers
    case 'py.int'
      x_mat = x_py.int64;

    case 'py.float'
      x_mat = x_py.real;

    case 'py.complex'
      x_mat = complex(x_py.real, x_py.imag);

    case 'py.bool'
      x_mat = logical(x_py);

    case 'py.datetime.datetime'
      x_mat = datetime(int64(x_py.year),  ...
                       int64(x_py.month), ...
                       int64(x_py.day),   ...
                       int64(x_py.hour),  ...
                       int64(x_py.minute),...
                       int64(x_py.second),...
                       double(x_py.microsecond)/1000.0);

    case 'py.bytes'
      x_mat = uint8(x_py);

    case 'py.NoneType'
      x_mat = '';

    case 'py.scipy.optimize.optimize.OptimizeResult'
      for k = cell(py.list(x_py.keys))
          x_mat.(string(k{1})) = py2mat(x_py.get(k{1}));
      end

    case 'py.xarray.core.dataarray.DataArray'
      x_mat = double(py.numpy.asfortranarray(x_py));

    case "py.xarray.core.dataset.Dataset"
      error("xarray.Dataset: please index the DataArray before py2mat")

    otherwise
      error(class(x_py) + " not handled")
  end
end


function I = xarrayind2vector(V, key) %#ok<DEFNU>
%% XARRAYIND2VECTOR convert xarray Index to Matlab vector array
% by SciVision

C = cell(V.indexes{key}.values.tolist);
% might be numeric or cell array of strings

if iscellstr(C) || (length(C) > 1 && isa(C{1}, 'py.str'))
  I = cellfun(@char, C, uniformoutput=false);
elseif isa(C{1}, 'py.datetime.datetime')
  I = char(C{1}.isoformat());
elseif isa(C{1}, 'py.int') && C{1} > 1e12
  C = cellfun(@double,C)/1e9;
  I = datetime(C, convertfrom='posixtime');
else
  I = cell2mat(C);
end

end
