function P = pow( x, Tau)
%
% function P = pow( x, Tau)
%
% Compute the sample power of the signal represented by x, with oversample ratio Tau.
%
%
% INPUTS
%   x       vector of signal samples (row or column)
%   Tau (optional)    oversample ratio.  Default to 1.
%
% OUTPUTS:
%   P      power of signal x
%
% 9/May/2016  GKW
% 

if nargin < 2
    Tau=1;
end

P = x(:)'*x(:) / length(x) * Tau;