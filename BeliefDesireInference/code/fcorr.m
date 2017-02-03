function r = fcorr(x,y)
% r = fcorr(x,y)
% fast Pearson correlation function
%
% x is P x N, y is P x M
% r is N x M
%
% Adapted from "CoSMo corr" (http://cosmomvpa.org)
%

nx=size(x,1);
ny=size(y,1);

% subtract mean
xd=bsxfun(@minus,x,sum(x,1)/nx);
yd=bsxfun(@minus,y,sum(y,1)/ny);

% normalization
n=1/(nx-1);

% standard deviation
xs=(n*sum(xd .^ 2)).^-0.5;
ys=(n*sum(yd .^ 2)).^-0.5;

% compute correlations
r=n * (xd' * yd) .* (xs' * ys);
