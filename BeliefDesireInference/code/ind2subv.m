function sub = ind2subv(siz,index)
%IND2SUBV   Subscript vector from linear index.
% IND2SUBV(SIZ,IND) returns a vector of the equivalent subscript values 
% corresponding to a single index into an array of size SIZ.
% If IND is a vector, then the result is a matrix, with subscript vectors
% as rows.
%
% Input:
%  -siz:
%  -index:
%
% Output:
%  -sub:
%        CB: class(sub) = uint32
%
% Written by Tom Minka
% (c) Microsoft Corporation. All rights reserved.


n = length(siz);
cum_size = cumprod(siz(:)');
prev_cum_size = [1 cum_size(1:end-1)];
index = index(:) - 1;
sub = rem(repmat(index,1,n),repmat(cum_size,length(index),1));
sub = uint32(floor(sub ./ repmat(prev_cum_size,length(index),1))+1);