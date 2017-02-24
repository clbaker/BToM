function ind = sub2indv(siz,sub)
% ind = sub2indv(siz,sub)
%
% adapted from sub2ind2
%
% Improved version of sub2ind.
% 
% INPUTS
%   siz     - size of array into which sub is an index
%   sub     - sub(i,:) is the ith set of subscripts into the array.
% 
% OUTPUTS   
%   ind     - linear index (or vector of indices) into given array.
%             class(ind) = uint32
%
% See also IND2SUBV

if(isempty(sub)) ind=[]; return; end;

n = length(siz);
nsub = size(sub,2);

k = uint32([1 cumprod(siz(1:end-1))]');
ind = sum(uint32(sub-1) .* repmat(k,1,nsub),1)+1;