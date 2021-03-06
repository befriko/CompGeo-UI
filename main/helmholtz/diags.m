function A = diags(a)
% construct sparse diagonal matrix
%
% use:
%   A = diags(A)
%
% input:
%   a - vector of length n
%
% output
%   A - nxn sparse matrix with a on the diagonal
%
% Modified from https://github.com/TristanvanLeeuwen/SimpleFWI
%%

n = length(a(:));
A = spdiags(a(:),0,n,n);
